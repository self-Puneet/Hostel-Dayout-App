// warden_home_page.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hostel_mgmt/core/enums/actions.dart';
import 'package:hostel_mgmt/core/enums/enum.dart';
import 'package:hostel_mgmt/core/helpers/app_refreasher_widget.dart';
import 'package:hostel_mgmt/core/routes/app_route_constants.dart';
import 'package:hostel_mgmt/presentation/components/simple_action_request_card.dart';
import 'package:provider/provider.dart';
import 'package:hostel_mgmt/presentation/view/warden/state/warden_home_state.dart';
import 'package:hostel_mgmt/presentation/view/warden/controller/warden_home_controller.dart';
// Your segmented tabs widget (GlassSegmentedTabs)
import 'package:hostel_mgmt/presentation/widgets/segmented_button.dart';

class WardenHomePage extends StatelessWidget {
  final TimelineActor actor;
  WardenHomePage({Key? key, required this.actor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WardenHomeState>(
      builder: (context, state, _) {
        // Initialize hostel list once
        if (!state.hostelsInitialized) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            WardenHomeController(state).loadHostelsFromSession();
          });
        }

        // Fetch data after hostels are known and not yet loaded
        if (state.hostelsInitialized &&
            !state.isLoading &&
            !state.isErrored &&
            !state.hasData) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            WardenHomeController(state).fetchRequestsFromApi();
          });
        }

        final WardenHomeController controller = WardenHomeController(state);

        if (state.isLoading && !state.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        return Column(
          children: [
            // Search + Hostel picker row
            // Search + Hostel picker row
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: state.filterController,
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
                // Fixed width hostel selector
                if (state.hostelIds.length <= 1 &&
                    state.selectedHostelId != null)
                  Container(
                    decoration: BoxDecoration(
                      // color: Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      border: BoxBorder.all(color: Colors.black, width: 01),
                    ),

                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 15),
                    width: 100,
                    child: Text(
                      state.selectedHostelId!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12),
                    ),
                  )
                else if (state.hostelIds.length > 1)
                  Container(
                    decoration: BoxDecoration(
                      // color: Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      border: BoxBorder.all(color: Colors.black, width: 1),
                    ),

                    padding: EdgeInsets.symmetric(
                      horizontal: 8,
                      // vertical: 15,
                    ),
                    width: 100,
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value:
                            state.selectedHostelId ??
                            (state.hostelIds.isNotEmpty
                                ? state.hostelIds.first
                                : null),
                        items: state.hostelIds
                            .map(
                              (id) => DropdownMenuItem<String>(
                                value: id,
                                child: Text(
                                  id,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors
                                        .black, // menu item text color (opened dropdown)
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (val) async {
                          if (val == null) return;
                          state.setSelectedHostelId(val);
                          state.resetForHostelChange();
                          await WardenHomeController(
                            state,
                          ).fetchRequestsFromApi(hostelId: val);
                        },
                        iconSize: 16,
                        iconEnabledColor: Colors.black,
                        iconDisabledColor: Colors.black,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors
                              .white, // selected value text color (closed dropdown)
                        ),
                        dropdownColor:
                            Colors.white, // background of the opened menu
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 12),

            // Bulk-action buttons
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
                              controller.bulkActionSelected(
                                action: RequestAction.cancel,
                              );
                            } else {
                              controller.bulkActionSelected(
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
                              controller.bulkActionSelected(
                                action: RequestAction.refer,
                              );
                            } else {
                              controller.bulkActionSelected(
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
            const SizedBox(height: 12),

            // Tabs host the list content; clear selection on tab change
            Expanded(
              child: GlassSegmentedTabs(
                options: const ['All', 'Dayout', 'Leave'],
                onTabChanged: (_) {
                  context.read<WardenHomeState>().clearSelection();
                },
                views: [
                  _WardenTabBody(actor: actor, type: null),
                  _WardenTabBody(actor: actor, type: RequestType.dayout),
                  _WardenTabBody(actor: actor, type: RequestType.leave),
                ],
                labelFontSize: 12,
                selectedLabelFontSize: 12,
                showTabs: true,
                margin: 0,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _WardenTabBody extends StatelessWidget {
  final TimelineActor actor;
  final RequestType? type; // null = All

  const _WardenTabBody({required this.actor, required this.type});

  @override
  Widget build(BuildContext context) {
    const double height = 48.0;
    final state = context.watch<WardenHomeState>();
    final controller = WardenHomeController(state);

    final wrapped = state.currentOnScreenRequests.where((w) {
      if (type == null) return true;
      return w.request.requestType == type;
    }).toList();
    return AppRefreshWrapper(
      onRefresh: () async {
        final s = context.read<WardenHomeState>();
        // Keep current hostel selection; just refetch fresh data
        s.resetForHostelChange();
        await WardenHomeController(s).fetchRequestsFromApi();
      },
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: const [
                SizedBox(height: height),
                Divider(height: 1, thickness: 1),
                SizedBox(height: 12),
              ],
            ),
          ),
          if (state.isActioning)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: CircularProgressIndicator()),
            )
          else if (wrapped.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: Text("no request currently")),
            )
          else
            SliverList.separated(
              itemCount: wrapped.length,
              separatorBuilder: (_, __) => const SizedBox(height: 0),
              itemBuilder: (context, index) {
                final w = wrapped[index];
                final req = w.request;
                final stu = w.student;

                // Fallbacks: prefer student.name, else enrollmentNo, else request enrollment
                final safeName = (stu.name.trim().isNotEmpty)
                    ? stu.name
                    : (stu.enrollmentNo.trim().isNotEmpty
                          ? stu.enrollmentNo
                          : req.studentEnrollmentNumber);

                // Optional: if profilePic may be relative, join with base URL here
                final safeProfileUrl = (stu.profilePic ?? '').trim();

                final selected = state.isSelectedById(req.requestId);

                return SimpleActionRequestCard(
                  profileImageUrl: safeProfileUrl.isNotEmpty
                      ? safeProfileUrl
                      : null,
                  reason: req.reason,
                  name: safeName,
                  status: req.status,
                  leaveType: req.requestType,
                  fromDate: req.appliedFrom,
                  toDate: req.appliedTo,
                  selected: selected,
                  onLongPress: (!state.isActioning && !state.hasSelection)
                      ? () => state.toggleSelectedById(req.requestId)
                      : null,
                  onTap: (!state.isActioning && state.hasSelection)
                      ? () => state.toggleSelectedById(req.requestId)
                      : null,
                  onRejection: (!state.hasSelection && !state.isActioning)
                      ? () {
                          controller.actionRequestById(
                            action: actor == TimelineActor.assistentWarden
                                ? RequestAction.cancel
                                : RequestAction.reject,
                            requestId: req.requestId,
                          );
                          context.goNamed(
                            AppRoutes.wardenHome,
                            queryParameters: {
                              'ts': DateTime.now().millisecondsSinceEpoch
                                  .toString(),
                            },
                          );
                        }
                      : null,
                  onAcceptence: (!state.hasSelection && !state.isActioning)
                      ? () {
                          controller.actionRequestById(
                            action: actor == TimelineActor.assistentWarden
                                ? RequestAction.refer
                                : RequestAction.approve,
                            requestId: req.requestId,
                          );
                          context.goNamed(
                            "warden-home",
                            queryParameters: {
                              'ts': DateTime.now().millisecondsSinceEpoch
                                  .toString(),
                            },
                          );
                        }
                      : null,
                );
              },
            ),
        ],
      ),
    );
  }
}
