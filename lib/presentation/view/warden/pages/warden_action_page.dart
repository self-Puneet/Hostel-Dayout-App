import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hostel_mgmt/core/enums/actions.dart';
import 'package:hostel_mgmt/core/enums/enum.dart';
import 'package:hostel_mgmt/core/helpers/app_refreasher_widget.dart';
import 'package:hostel_mgmt/core/routes/app_route_constants.dart';
import 'package:hostel_mgmt/presentation/components/simple_action_request_card.dart';
import 'package:hostel_mgmt/presentation/widgets/segmented_scrollable_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:hostel_mgmt/presentation/view/warden/state/warden_action_state.dart';
import 'package:hostel_mgmt/presentation/view/warden/controller/warden_action_page_controller.dart';

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
    final labels = WardenTab.values.map((t) => t.label).toList();
    final state = context.read<WardenActionState>();
    final controller = WardenActionPageController(state);

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

          if (s.isLoading && !s.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              // Search + hostel picker
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
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
                padding: const EdgeInsets.symmetric(horizontal: 0),
                child: SegmentedTabs(controller: _tabs, labels: labels),
              ),
              const SizedBox(height: 12),

              // Tab contents
              Expanded(
                child: TabBarView(
                  controller: _tabs,
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
                  final wrap = s.currentOnScreenRequests[i];
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
    return Consumer<WardenActionState>(
      builder: (context, s, _) {
        final List<OnScreenRequest> reqeusts = stateController
            .getRequestByStatus(status_: status);
        if (reqeusts.isEmpty) {
          final q = s.filterController.text.trim();
          return Center(
            child: Text(q.isEmpty ? 'Nothing here yet' : 'No matches for "$q"'),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
          itemCount: s.currentOnScreenRequests.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (context, i) {
            final wrap = s.currentOnScreenRequests[i];
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
              // phone student
              cardBackgroundColor: Colors.red,
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
        );
      },
    );
  }
}

//               // Bulk actions
//               Row(
//                 children: [
//                   Expanded(
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor:
//                             state.isActioning || !state.hasSelection
//                             ? Colors.grey
//                             : Colors.red,
//                         foregroundColor:
//                             state.isActioning || !state.hasSelection
//                             ? Colors.black
//                             : Colors.white,
//                       ),
//                       onPressed: (!state.isActioning && state.hasSelection)
//                           ? () {
//                               if (actor == TimelineActor.assistentWarden) {
//                                 controller.bulkActionSelected(
//                                   action: RequestAction.cancel,
//                                 );
//                               } else {
//                                 controller.bulkActionSelected(
//                                   action: RequestAction.reject,
//                                 );
//                               }
//                             }
//                           : null,
//                       child: actor == TimelineActor.assistentWarden
//                           ? Text(RequestAction.cancel.name)
//                           : Text(RequestAction.reject.name),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor:
//                             state.isActioning || !state.hasSelection
//                             ? Colors.grey
//                             : Colors.green,
//                         foregroundColor:
//                             state.isActioning || !state.hasSelection
//                             ? Colors.black
//                             : Colors.white,
//                       ),
//                       onPressed: (!state.isActioning && state.hasSelection)
//                           ? () {
//                               if (actor == TimelineActor.assistentWarden) {
//                                 controller.bulkActionSelected(
//                                   action: RequestAction.refer,
//                                 );
//                               } else {
//                                 controller.bulkActionSelected(
//                                   action: RequestAction.approve,
//                                 );
//                               }
//                             }
//                           : null,
//                       child: actor == TimelineActor.assistentWarden
//                           ? Text(RequestAction.refer.name)
//                           : Text(RequestAction.approve.name),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 12),

//               // Tabs + content: keep views non-scrollable; the page ListView scrolls everything
//               // If your GlassSegmentedTabs requires a bounded height, keep SizedBox; contents below are non-scrollable.
//               GlassSegmentedTabs(
//                 options: const ['All', 'Dayout', 'Leave'],
//                 onTabChanged: (_) {
//                   context.read<WardenActionState>().clearSelection();
//                 },
//                 views: [
//                   _WardenTabBody(actor: actor, type: null),
//                   _WardenTabBody(actor: actor, type: RequestType.dayout),
//                   _WardenTabBody(actor: actor, type: RequestType.leave),
//                 ],
//                 labelFontSize: 12,
//                 selectedLabelFontSize: 12,
//                 showTabs: true,
//                 margin: 0,
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }

// class _WardenTabBody extends StatelessWidget {
//   final TimelineActor actor;
//   final RequestType? type; // null = All

//   const _WardenTabBody({required this.actor, required this.type});

//   @override
//   Widget build(BuildContext context) {
//     const double padHeight = 48.0;
//     final state = context.watch<WardenActionState>();
//     final controller = WardenActionPageController(state);

//     final wrapped = state.currentOnScreenRequests.where((w) {
//       if (type == null) return true;
//       return w.request.requestType == type;
//     }).toList();

//     return Column(
//       mainAxisSize: MainAxisSize.min, // shrink to content
//       children: [
//         const SizedBox(height: padHeight / 2),
//         const Divider(height: 1, thickness: 1),
//         const SizedBox(height: 12),

//         if (state.isActioning)
//           const Padding(
//             padding: EdgeInsets.symmetric(vertical: 24),
//             child: Center(child: CircularProgressIndicator()),
//           )
//         else if (wrapped.isEmpty)
//           const Padding(
//             padding: EdgeInsets.symmetric(vertical: 24),
//             child: Center(child: Text("no request currently")),
//           )
//         else
//           ListView.separated(
//             padding: EdgeInsets.zero,
//             physics: const NeverScrollableScrollPhysics(),
//             shrinkWrap: true, // measure to content
//             itemCount: wrapped.length,
//             separatorBuilder: (_, __) => const SizedBox(height: 0),
//             itemBuilder: (context, index) {
//               final w = wrapped[index];
//               final req = w.request;
//               final stu = w.student;

//               final safeName = (stu.name.trim().isNotEmpty)
//                   ? stu.name
//                   : (stu.enrollmentNo.trim().isNotEmpty
//                         ? stu.enrollmentNo
//                         : req.studentEnrollmentNumber);

//               final selected = state.isSelectedById(req.requestId);

//               return SimpleActionRequestCard(
//                 profileImageUrl: stu.profilePic,
//                 reason: req.reason,
//                 name: safeName,
//                 status: req.status,
//                 leaveType: req.requestType,
//                 fromDate: req.appliedFrom,
//                 toDate: req.appliedTo,
//                 selected: selected,
//                 onLongPress: (!state.isActioning && !state.hasSelection)
//                     ? () => state.toggleSelectedById(req.requestId)
//                     : null,
//                 onTap: (!state.isActioning && state.hasSelection)
//                     ? () => state.toggleSelectedById(req.requestId)
//                     : null,
//                 onRejection: (!state.hasSelection && !state.isActioning)
//                     ? () {
//                         controller.actionRequestById(
//                           action: actor == TimelineActor.assistentWarden
//                               ? RequestAction.cancel
//                               : RequestAction.reject,
//                           requestId: req.requestId,
//                         );
//                         context.goNamed(
//                           AppRoutes.wardenHome,
//                           queryParameters: {
//                             'ts': DateTime.now().millisecondsSinceEpoch
//                                 .toString(),
//                           },
//                         );
//                       }
//                     : null,
//                 onAcceptence: (!state.hasSelection && !state.isActioning)
//                     ? () {
//                         controller.actionRequestById(
//                           action: actor == TimelineActor.assistentWarden
//                               ? RequestAction.refer
//                               : RequestAction.approve,
//                           requestId: req.requestId,
//                         );
//                         context.goNamed(
//                           "warden-home",
//                           queryParameters: {
//                             'ts': DateTime.now().millisecondsSinceEpoch
//                                 .toString(),
//                           },
//                         );
//                       }
//                     : null,
//               );
//             },
//           ),
//       ],
//     );
//   }
// }
