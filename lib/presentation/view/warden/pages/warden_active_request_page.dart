import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hostel_mgmt/core/enums/actions.dart';
import 'package:hostel_mgmt/core/enums/enum.dart';
import 'package:hostel_mgmt/core/helpers/app_refreasher_widget.dart';
import 'package:hostel_mgmt/core/routes/app_route_constants.dart';
import 'package:hostel_mgmt/presentation/components/simple_action_request_card.dart';
import 'package:provider/provider.dart';
import 'package:hostel_mgmt/presentation/view/warden/state/warden_active_request_state.dart';
import 'package:hostel_mgmt/presentation/view/warden/controller/warden_active_request_controller.dart';
import 'package:hostel_mgmt/presentation/widgets/glass_segmented_button.dart';

class WardenHomePage extends StatelessWidget {
  final TimelineActor actor;
  WardenHomePage({Key? key, required this.actor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.read<WardenActionState>();
    final controller = WardenActionPageController(state);

    return AppRefreshWrapper(
      onRefresh: () async {
        state.resetForHostelChange();
        await controller.fetchRequestsFromApi();
      },
      child: Consumer<WardenActionState>(
        builder: (context, state, _) {
          if (!state.hostelsInitialized) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              WardenActionPageController(state).loadHostelsFromSession();
            });
          }

          if (state.hostelsInitialized &&
              !state.isLoading &&
              !state.isErrored &&
              !state.hasData) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              WardenActionPageController(state).fetchRequestsFromApi();
            });
          }

          if (state.isLoading && !state.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            padding: const EdgeInsets.all(0),
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              // Search + hostel picker
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
                  SizedBox(
                    width: 130,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blueGrey, width: 1.1),
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
                            state.hostelIds.length <= 1 &&
                                state.selectedHostelId != null
                            ? SizedBox(
                                height: 50,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.home,
                                      color: Colors.blueGrey,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        state.selectedHostelId!,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 13,
                                          color: Colors.blueGrey,
                                        ),
                                        textAlign: TextAlign.center,
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
                                        state.selectedHostelId ??
                                        (state.hostelIds.isNotEmpty
                                            ? state.hostelIds.first
                                            : null),
                                    items: state.hostelIds
                                        .map(
                                          (id) => DropdownMenuItem<String>(
                                            value: id,
                                            child: Row(
                                              children: [
                                                Icon(
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
                                      state.setSelectedHostelId(val);
                                      state.resetForHostelChange();
                                      await WardenActionPageController(
                                        state,
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
              const SizedBox(height: 12),

              // Bulk actions
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            state.isActioning || !state.hasSelection
                            ? Colors.grey
                            : Colors.red,
                        foregroundColor:
                            state.isActioning || !state.hasSelection
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
                        backgroundColor:
                            state.isActioning || !state.hasSelection
                            ? Colors.grey
                            : Colors.green,
                        foregroundColor:
                            state.isActioning || !state.hasSelection
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

              // Tabs + content: keep views non-scrollable; the page ListView scrolls everything
              // If your GlassSegmentedTabs requires a bounded height, keep SizedBox; contents below are non-scrollable.
              GlassSegmentedTabs(
                options: const ['All', 'Dayout', 'Leave'],
                onTabChanged: (_) {
                  context.read<WardenActionState>().clearSelection();
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
            ],
          );
        },
      ),
    );
  }
}

class _WardenTabBody extends StatelessWidget {
  final TimelineActor actor;
  final RequestType? type; // null = All

  const _WardenTabBody({required this.actor, required this.type});

  @override
  Widget build(BuildContext context) {
    const double padHeight = 48.0;
    final state = context.watch<WardenActionState>();
    final controller = WardenActionPageController(state);

    final wrapped = state.currentOnScreenRequests.where((w) {
      if (type == null) return true;
      return w.request.requestType == type;
    }).toList();

    return Column(
      mainAxisSize: MainAxisSize.min, // shrink to content
      children: [
        const SizedBox(height: padHeight / 2),
        const Divider(height: 1, thickness: 1),
        const SizedBox(height: 12),

        if (state.isActioning)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (wrapped.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: Text("no request currently")),
          )
        else
          ListView.separated(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true, // measure to content
            itemCount: wrapped.length,
            separatorBuilder: (_, __) => const SizedBox(height: 0),
            itemBuilder: (context, index) {
              final w = wrapped[index];
              final req = w.request;
              final stu = w.student;

              final safeName = (stu.name.trim().isNotEmpty)
                  ? stu.name
                  : (stu.enrollmentNo.trim().isNotEmpty
                        ? stu.enrollmentNo
                        : req.studentEnrollmentNumber);

              final selected = state.isSelectedById(req.requestId);

              return SimpleActionRequestCard(
                profileImageUrl: stu.profilePic,
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
    );
  }
}
