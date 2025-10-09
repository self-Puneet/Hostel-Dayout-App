import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hostel_mgmt/core/enums/actions.dart';
import 'package:hostel_mgmt/core/enums/enum.dart';
import 'package:hostel_mgmt/core/routes/app_route_constants.dart';
import 'package:hostel_mgmt/presentation/components/simple_action_request_card.dart';
import 'package:hostel_mgmt/presentation/widgets/segmented_scrollable_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:hostel_mgmt/presentation/view/warden/state/warden_action_state.dart';
import 'package:hostel_mgmt/presentation/view/warden/controller/warden_action_page_controller.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> _openDialer(String number) async {
  final Uri phoneUri = Uri(scheme: 'tel', path: number);
  if (await canLaunchUrl(phoneUri)) {
    await launchUrl(phoneUri);
  } else {
    throw 'Could not open dialer for $number';
  }
}

class WardenHomePage extends StatefulWidget {
  final TimelineActor actor;
  const WardenHomePage({super.key, required this.actor});

  @override
  State<WardenHomePage> createState() => _WardenHomePageState();
}

class _WardenHomePageState extends State<WardenHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: WardenTab.values.length, vsync: this);
    _tabs.addListener(() {
      if (!_tabs.indexIsChanging) {
        final tab = WardenTabX.fromIndex(_tabs.index);
        context.read<WardenActionState>().setCurrentTab(tab);
      }
    });
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final labels = WardenTab.values.map((t) => t.label).toList();
    final state = context.read<WardenActionState>();
    final controller = WardenActionPageController(state);
    final horizontalPad = EdgeInsets.symmetric(
      horizontal: 31 * media.size.width / 402,
    );

    return RefreshIndicator(
      triggerMode: RefreshIndicatorTriggerMode.anywhere,
      color: Colors.black,
      backgroundColor: Colors.white,

      notificationPredicate: (notification) =>
          notification.metrics.axis == Axis.vertical && notification.depth > 0,
      strokeWidth: 3,
      displacement: 60,
      onRefresh: () async {
        state.resetForHostelChange();
        await controller.fetchRequestsFromApi();
      },
      child: Consumer<WardenActionState>(
        builder: (context, s, _) {
          if (!s.hostelsInitialized) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              WardenActionPageController(s).loadHostelsFromSession();
            });
          }

          if (s.hostelsInitialized &&
              !s.isLoading &&
              !s.isErrored &&
              !s.hasData) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              WardenActionPageController(s).fetchRequestsFromApi();
            });
          }

          return Column(
            children: [
              // Search + hostel picker
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 8) +
                    horizontalPad,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: s.filterController,
                        decoration: InputDecoration(
                          hintText: 'Search by Name ...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          isDense: true,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 130,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.blueGrey,
                            width: 1.1,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child:
                              s.hostelIds.length <= 1 &&
                                  s.selectedHostelId != null
                              ? SizedBox(
                                  height: 50,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.home,
                                        color: Colors.blueGrey,
                                        size: 18,
                                      ),
                                      const SizedBox(width: 5),
                                      Expanded(
                                        child: Text(
                                          s.selectedHostelId!,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13,
                                            color: Colors.blueGrey,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : SizedBox(
                                  height: 50,
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      isDense: true,
                                      isExpanded: true,
                                      itemHeight: 48.0,
                                      value:
                                          s.selectedHostelId ??
                                          (s.hostelIds.isNotEmpty
                                              ? s.hostelIds.first
                                              : null),
                                      items: s.hostelIds
                                          .map(
                                            (id) => DropdownMenuItem<String>(
                                              value: id,
                                              child: Row(
                                                children: [
                                                  const Icon(
                                                    Icons.home,
                                                    color: Colors.blueGrey,
                                                    size: 16,
                                                  ),
                                                  const SizedBox(width: 6),
                                                  Expanded(
                                                    child: Text(
                                                      id,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: const TextStyle(
                                                        fontSize: 13,
                                                        color: Colors.black87,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                          .toList(),
                                      onChanged: (val) async {
                                        if (val == null) return;
                                        s.setSelectedHostelId(val);
                                        s.resetForHostelChange();
                                        await WardenActionPageController(
                                          s,
                                        ).fetchRequestsFromApi(hostelId: val);
                                      },
                                      icon: const Icon(
                                        Icons.keyboard_arrow_down_rounded,
                                        color: Colors.blueGrey,
                                      ),
                                      iconSize: 20,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.black87,
                                      ),
                                      dropdownColor: Colors.white,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Segmented, scrollable tabs
              Padding(
                padding: horizontalPad,
                child: SegmentedTabs(controller: _tabs, labels: labels),
              ),
              const SizedBox(height: 6),
              Padding(
                padding: horizontalPad,
                child: Divider(thickness: 2, color: Colors.grey.shade300),
              ),
              // Tab contents
              Expanded(
                child: (s.isLoading && !s.hasData)
                    ? const Center(child: CircularProgressIndicator())
                    : TabBarView(
                        controller: _tabs,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          // Pending Approval (selection + actions)
                          _PendingApprovalList(
                            actor: widget.actor,
                            stateController: controller,
                            state: state,
                            status: RequestStatus.approved,
                          ),
                          // Approved
                          _StatusList(
                            actor: widget.actor,
                            stateController: controller,
                            status: RequestStatus.approved,
                          ),
                          // Pending Parent
                          _StatusList(
                            actor: widget.actor,
                            stateController: controller,
                            status: RequestStatus.referred,
                          ),
                          // Requested
                          _StatusList(
                            actor: widget.actor,
                            stateController: controller,
                            status: RequestStatus.requested,
                          ),
                        ],
                      ),
              ),
              Container(height: 84 + MediaQuery.of(context).viewPadding.bottom),
            ],
          );
        },
      ),
    );
  }
}

// Pending Approval: selection-enabled cards
class _PendingApprovalList extends StatelessWidget {
  final TimelineActor actor;
  final WardenActionPageController stateController;
  final WardenActionState state;
  final RequestStatus status;
  const _PendingApprovalList({
    required this.actor,
    required this.stateController,
    required this.state,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final horizontalPad = EdgeInsets.symmetric(
      horizontal: 31 * media.size.width / 402,
    );
    return Consumer<WardenActionState>(
      builder: (context, s, _) {
        final List<OnScreenRequest> result = stateController.getRequestByStatus(
          status_: RequestStatus.parentApproved,
        );
        if (result.isEmpty) {
          final q = s.filterController.text.trim();
          return Center(
            child: Text(
              q.isEmpty ? 'No requests to review' : 'No matches for "$q"',
            ),
          );
        }
        return Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: state.isActioning || !state.hasSelection
                          ? Colors.grey
                          : Colors.red,
                      foregroundColor: state.isActioning || !state.hasSelection
                          ? Colors.black
                          : Colors.white,
                    ),
                    onPressed: (!state.isActioning && state.hasSelection)
                        ? () {
                            if (actor == TimelineActor.assistentWarden) {
                              stateController.bulkActionSelected(
                                action: RequestAction.cancel,
                              );
                            } else {
                              stateController.bulkActionSelected(
                                action: RequestAction.reject,
                              );
                            }
                          }
                        : null,
                    child: actor == TimelineActor.assistentWarden
                        ? Text(RequestAction.cancel.name)
                        : Text(RequestAction.reject.name),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: state.isActioning || !state.hasSelection
                          ? Colors.grey
                          : Colors.green,
                      foregroundColor: state.isActioning || !state.hasSelection
                          ? Colors.black
                          : Colors.white,
                    ),
                    onPressed: (!state.isActioning && state.hasSelection)
                        ? () {
                            if (actor == TimelineActor.assistentWarden) {
                              stateController.bulkActionSelected(
                                action: RequestAction.refer,
                              );
                            } else {
                              stateController.bulkActionSelected(
                                action: RequestAction.approve,
                              );
                            }
                          }
                        : null,
                    child: actor == TimelineActor.assistentWarden
                        ? Text(RequestAction.refer.name)
                        : Text(RequestAction.approve.name),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // 👇 This makes the list take the remaining space properly
            Expanded(
              child: ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                itemCount: result.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, i) {
                  final wrap = result[i];
                  final req = wrap.request;
                  final stu = wrap.student;
                  final selected = wrap.isSelected;
                  final safeName = (stu.name).isEmpty ? 'Unknown' : stu.name;

                  return SimpleActionRequestCard(
                    profileImageUrl: stu.profilePic,
                    reason: req.reason,
                    name: safeName,
                    status: req.status,
                    leaveType: req.requestType,
                    fromDate: req.appliedFrom,
                    toDate: req.appliedTo,
                    selected: selected,
                    onLongPress: (!s.isActioning && !s.hasSelection)
                        ? () => s.toggleSelectedById(req.requestId)
                        : null,
                    onTap: (!s.isActioning && s.hasSelection)
                        ? () => s.toggleSelectedById(req.requestId)
                        : null,
                    onRejection: (!s.hasSelection && !s.isActioning)
                        ? () async {
                            await stateController.actionRequestById(
                              action: actor == TimelineActor.assistentWarden
                                  ? RequestAction.cancel
                                  : RequestAction.reject,
                              requestId: req.requestId,
                            );
                            if (context.mounted) {
                              context.goNamed(
                                AppRoutes.wardenHome,
                                queryParameters: {
                                  'ts': DateTime.now().millisecondsSinceEpoch
                                      .toString(),
                                },
                              );
                            }
                          }
                        : null,
                    onAcceptence: (!s.hasSelection && !s.isActioning)
                        ? () async {
                            await stateController.actionRequestById(
                              action: actor == TimelineActor.assistentWarden
                                  ? RequestAction.refer
                                  : RequestAction.approve,
                              requestId: req.requestId,
                            );
                            if (context.mounted) {
                              context.goNamed(
                                AppRoutes.wardenHome,
                                queryParameters: {
                                  'ts': DateTime.now().millisecondsSinceEpoch
                                      .toString(),
                                },
                              );
                            }
                          }
                        : null,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

// Other tabs: read-only cards
class _StatusList extends StatelessWidget {
  final TimelineActor actor;
  final WardenActionPageController stateController;
  final RequestStatus status;

  const _StatusList({
    required this.actor,
    required this.stateController,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final horizontalPad = EdgeInsets.symmetric(
      horizontal: 31 * media.size.width / 402,
    );
    return Container(
      margin: horizontalPad,
      child: Consumer<WardenActionState>(
        builder: (context, s, _) {
          final List<OnScreenRequest> reqeusts = stateController
              .getRequestByStatus(status_: status);
          print(reqeusts.length);
          if (reqeusts.isEmpty) {
            final q = s.filterController.text.trim();
            return Center(
              child: Text(
                q.isEmpty ? 'Nothing here yet' : 'No matches for "$q"',
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
            itemCount: reqeusts.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, i) {
              final wrap = reqeusts[i];
              final req = wrap.request;
              final stu = wrap.student;
              final selected = wrap.isSelected;
              final safeName = (stu.name).isEmpty ? 'Unknown' : stu.name;

              return SimpleActionRequestCard(
                profileImageUrl: stu.profilePic,
                reason: req.reason,
                name: safeName,
                status: req.status,
                leaveType: req.requestType,
                fromDate: req.appliedFrom,
                toDate: req.appliedTo,
                selected: selected,
                isRejection: false,
                isLate: req.appliedTo.isBefore(DateTime.now()),
                borderColor: req.appliedTo.isBefore(DateTime.now())
                    ? Colors.red
                    : null,
                acceptenceIcon: Icons.phone,
                accrptenceCOlor: Colors.blue,
                onLongPress: (!s.isActioning && !s.hasSelection)
                    ? () => s.toggleSelectedById(req.requestId)
                    : null,
                onTap: (!s.isActioning && s.hasSelection)
                    ? () => s.toggleSelectedById(req.requestId)
                    : null,
                onRejection: (!s.hasSelection && !s.isActioning)
                    ? () async {
                        await stateController.actionRequestById(
                          action: actor == TimelineActor.assistentWarden
                              ? RequestAction.cancel
                              : RequestAction.reject,
                          requestId: req.requestId,
                        );
                        if (context.mounted) {
                          context.goNamed(
                            AppRoutes.wardenHome,
                            queryParameters: {
                              'ts': DateTime.now().millisecondsSinceEpoch
                                  .toString(),
                            },
                          );
                        }
                      }
                    : null,
                onAcceptence: (!s.hasSelection && !s.isActioning)
                    ? () async {
                        _openDialer(stu.phoneNo);
                      }
                    : null,
              );
            },
          );
        },
      ),
    );
  }
}
