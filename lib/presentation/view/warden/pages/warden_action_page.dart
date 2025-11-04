// lib/presentation/view/warden/warden_home_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hostel_mgmt/core/enums/actions.dart';
import 'package:hostel_mgmt/core/enums/enum.dart';
import 'package:hostel_mgmt/core/rumtime_state/login_session.dart';
import 'package:hostel_mgmt/presentation/components/simple_action_request_card.dart';
import 'package:hostel_mgmt/presentation/components/skeleton_loaders/simple_action_request_card_skeleton.dart';
import 'package:hostel_mgmt/presentation/components/warden_request_list_tab.dart';
import 'package:hostel_mgmt/presentation/widgets/no_request_card.dart';
import 'package:hostel_mgmt/presentation/widgets/segmented_scrollable_tab_view.dart';
import 'package:hostel_mgmt/presentation/widgets/welcome_header.dart';
import 'package:provider/provider.dart';
import 'package:hostel_mgmt/presentation/view/warden/state/warden_action_state.dart';
import 'package:hostel_mgmt/presentation/view/warden/controller/warden_action_page_controller.dart';

class WardenHomePage extends StatefulWidget {
  final TimelineActor actor;
  final WardenTab? initialTab;

  const WardenHomePage({super.key, required this.actor, this.initialTab});

  @override
  State<WardenHomePage> createState() => _WardenHomePageState();
}

class _WardenHomePageState extends State<WardenHomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;
  late final WardenActionPageController _controller;

  @override
  void initState() {
    super.initState();
    final initTab = widget.initialTab ?? WardenTab.pendingApproval;
    final state = context.read<WardenActionState>();
    _controller = WardenActionPageController(state);

    _tabs = TabController(
      length: WardenTab.values.length,
      vsync: this,
      initialIndex: initTab.index,
    );
    _tabs.addListener(() {
      if (!_tabs.indexIsChanging) {
        final tab = WardenTabX.fromIndex(_tabs.index);
        context.read<WardenActionState>().setCurrentTab(tab);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final state = context.read<WardenActionState>();
        state.setCurrentTab(initTab);

        // Register your callbacks
        state.setSelectionCallbacks(
          onFirstSelected: () {
            state.layoutState.showActionsOverlay();
          },
          onNoneSelected: () {
            state.layoutState.hideActionsOverlay();
          },
        );
        state.setBulkActionCallback(({required action}) async {
          await _controller.bulkActionSelected(action: action);
          state.resetForHostelChange();
          await _controller.fetchRequestsFromApi();
        });
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
    final labels = WardenTab.values.map((t) => t.label(widget.actor)).toList();
    final state = context.read<WardenActionState>();
    // final controller = WardenActionPageController(state);
    final horizontalPad = EdgeInsets.symmetric(
      horizontal: 31 * media.size.width / 402,
    );
    final loginSession = Get.find<LoginSession>();
    final mediaQuery = MediaQuery.of(context);
        final topGap = mediaQuery.size.height * 50 / 874;


    return Column(
      children: [
                SizedBox(height: topGap),

        Container(
          margin: horizontalPad,
          child: WelcomeHeader(
            enrollmentNumber: loginSession.identityId,
            phoneNumber: loginSession.phone,
            actor: loginSession.role,
            hostelName: loginSession.hostels!
                .map((h) => h.hostelName)
                .toList()
                .join('\n'),
            name: loginSession.username,
            avatarUrl: loginSession.imageURL,
            greeting: 'Welcome back,',
          ),
        ),

        const SizedBox(height: 20),
        Expanded(
          // <-- give bounded height to the scrollable area
          child: RefreshIndicator(
            triggerMode: RefreshIndicatorTriggerMode.anywhere,
            color: Colors.black,
            backgroundColor: Colors.white,
            notificationPredicate: (notification) =>
                notification.metrics.axis == Axis.vertical &&
                notification.depth > 0,
            strokeWidth: 3,
            displacement: 60,
            onRefresh: () async {
              state.resetForHostelChange();
              await _controller.fetchRequestsFromApi();
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
                      padding: horizontalPad,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: s.filterController,
                              decoration: InputDecoration(
                                hintText: 'Search by Name',
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
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.blueGrey,
                                  width: 1.1,
                                ),
                                // boxShadow: const [
                                //   BoxShadow(
                                //     color: Colors.black12,
                                //     blurRadius: 6,
                                //     offset: Offset(0, 2),
                                //   ),
                                // ],
                              ),
                              child: hostelWidget(s),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Segmented, scrollable tabs
                        Padding(
                          padding: horizontalPad,
                          child: SegmentedTabs(
                            controller: _tabs,
                            labels: labels,
                          ),
                        ),
                        // const SizedBox(height: 6),
                        Positioned(
                          left: 0,
                          right: 0,
                          bottom:
                              (state.currentTab == WardenTab.pendingApproval)
                              ? -10
                              : 0,
                          child: Padding(
                            padding: horizontalPad,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    thickness: 2,
                                    height: 0,
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                (state.currentTab == WardenTab.pendingApproval)
                                    ? GestureDetector(
                                        onTap: () {
                                          state.toggleAllSelectedCheckbox(
                                            widget.actor,
                                          );
                                        },
                                        child: Container(
                                          color: const Color(0xFFE9E9E9),
                                          height: 20,
                                          width: 20,
                                          child: Icon(
                                            state.allSelected
                                                ? Icons.check_box
                                                : Icons.check_box_outline_blank,
                                            color: Colors.black,
                                            size: 20,
                                          ),
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    // Tab contents
                    (s.isLoading && !s.hasData)
                        ? Padding(
                            padding:
                                horizontalPad +
                                const EdgeInsets.symmetric(
                                  horizontal: 0,
                                  vertical: 8,
                                ),
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Column(
                                children: List.generate(2, (index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                    ),
                                    child: simpleActionRequestCardSkeleton(),
                                  );
                                }),
                              ),
                            ),
                          )
                        : Expanded(
                            child: TabBarView(
                              controller: _tabs,
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                if (widget.actor ==
                                    TimelineActor.seniorWarden) ...[
                                  // Pending (senior: referred + parentApproved)
                                  finalApprovalTab(_controller, state),
                                  // Approved
                                  approvedTab(_controller),
                                  // Pending Parent (show referred or parentApproved per your UX);
                                  parentPendingTab(_controller),
                                  // Requested
                                  requestedTab(_controller),
                                ] else if (widget.actor ==
                                    TimelineActor.assistentWarden) ...[
                                  // Pending (assistant: requested + cancelledStudent)
                                  _PendingApprovalList(
                                    actor: widget.actor,
                                    stateController: _controller,
                                    state: state,
                                    // status param kept for compatibility; ignored internally.
                                    status: RequestStatus.requested,
                                  ),
                                  // Approved
                                  StatusList(
                                    actor: widget.actor,
                                    stateController: _controller,
                                    status: RequestStatus.approved,
                                    showParent: true,
                                  ),
                                  // Referred
                                  StatusList(
                                    actor: widget.actor,
                                    stateController: _controller,
                                    status: RequestStatus.referred,
                                    showParent: true,
                                  ),
                                  // Parent Approved
                                  StatusList(
                                    actor: widget.actor,
                                    stateController: _controller,
                                    status: RequestStatus.parentApproved,
                                    showParent: true,
                                  ),
                                ],
                              ],
                            ),
                          ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget hostelWidget(WardenActionState s) {
    final items = s.hostels
        .map(
          (h) => DropdownMenuItem<String>(
            value: h.hostelId,
            child: Row(
              children: [
                const Icon(Icons.home, color: Colors.blueGrey, size: 16),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(h.hostelName, overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
          ),
        )
        .toList();

    final hasValue = s.hostels.any((h) => h.hostelId == s.selectedHostelId);
    final safeValue = hasValue
        ? s.selectedHostelId
        : (s.hostels.isNotEmpty ? s.hostels.first.hostelId : null);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: s.hostels.length <= 1 && s.selectedHostelId != null
          ? SizedBox(
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.home, color: Colors.blueGrey, size: 18),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      s.selectedHostelName!,
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
                  value: safeValue, // must be null or present in items
                  items: items, // items built from s.hostels

                  itemHeight: 48.0,
                  onChanged: (val) async {
                    if (val == null) return;

                    final hostel = s.hostels.firstWhere(
                      (h) => h.hostelId == val,
                      orElse: () => s.hostels.first,
                    );

                    // s.layoutState.clearState();
                    s.setSelectedHostelId(hostel.hostelId, hostel.hostelName);
                    s.resetForHostelChange();

                    await WardenActionPageController(
                      s,
                    ).fetchRequestsFromApi(hostelId: hostel.hostelId);
                  },
                  icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Colors.blueGrey,
                  ),
                  iconSize: 20,
                  style: const TextStyle(fontSize: 13, color: Colors.black87),
                  dropdownColor: Colors.white,
                ),
              ),
            ),
    );
  }

  Widget requestedTab(WardenActionPageController controller) {
    return StatusList(
      actor: widget.actor,
      stateController: controller,
      status: RequestStatus.requested,
      showParent: true,
    );
  }

  Widget parentPendingTab(WardenActionPageController controller) {
    return StatusList(
      actor: widget.actor,
      stateController: controller,
      status: RequestStatus.referred,
      showParent: true,
    );
  }

  Widget approvedTab(WardenActionPageController controller) {
    return StatusList(
      actor: widget.actor,
      stateController: controller,
      status: RequestStatus.approved,
      showParent: true,
    );
  }

  Widget finalApprovalTab(
    WardenActionPageController controller,
    WardenActionState state,
  ) {
    return _PendingApprovalList(
      actor: widget.actor,
      stateController: controller,
      state: state,
      // For senior we need union (handled inside the widget via the controller).
      status: (widget.actor == TimelineActor.seniorWarden)
          ? RequestStatus
                .approved // ignored for senior inside widget
          : RequestStatus.requested,
    );
  }
}

// Pending Approval: selection-enabled cards
class _PendingApprovalList extends StatelessWidget {
  final TimelineActor actor;
  final WardenActionPageController stateController;
  final WardenActionState state;
  final RequestStatus status; // kept for interface compatibility
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
    final double height = 84 + MediaQuery.of(context).viewPadding.bottom;
    return Container(
      margin: horizontalPad,
      child: Consumer<WardenActionState>(
        builder: (context, s, _) {
          // Build the correct union list per actor, filtered by search text, with selection applied.
          final List<OnScreenRequest> result = stateController
              .getRequestsForPending(actor);

          if (result.isEmpty) {
            final q = s.filterController.text.trim();
            return LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Center(
                    child: EmptyQueueCard(
                      title: q.isEmpty
                          ? 'Your queue is empty.'
                          : 'No matches found.',
                      subtitle: q.isEmpty
                          ? 'All clear! No requests for now.'
                          : 'Try refining your search.',
                      minHeight: 280,
                      bottomPadding: height, // already added via padding
                    ),
                  ),
                ),
              ),
            );
          }

          return Column(
            children: [
              // Container(height: 200,),
              Expanded(
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.only(
                    left: 0,
                    right: 0,
                    top: 16,
                    bottom: height,
                  ),
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
                          ? () => s.toggleSelectedById(req.requestId, actor)
                          : null,
                      onTap: (!s.isActioning && s.hasSelection)
                          ? () => s.toggleSelectedById(req.requestId, actor)
                          : null,
                      onRejection: (!s.hasSelection && !s.isActioning)
                          ? () async {
                              await stateController.actionRequestById(
                                action: actor == TimelineActor.assistentWarden
                                    ? RequestAction.cancel
                                    : RequestAction.reject,
                                requestId: req.requestId,
                              );
                              state.resetForHostelChange();
                              await stateController.fetchRequestsFromApi();
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
                              state.resetForHostelChange();
                              await stateController.fetchRequestsFromApi();
                            }
                          : null,
                      otherSelected: state.hasSelection,
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
