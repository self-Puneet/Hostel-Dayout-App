import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hostel_mgmt/core/enums/actions.dart';
import 'package:hostel_mgmt/core/enums/enum.dart';
import 'package:hostel_mgmt/core/routes/app_route_constants.dart';
import 'package:hostel_mgmt/presentation/components/simple_action_request_card.dart';
import 'package:provider/provider.dart';
import 'package:hostel_mgmt/presentation/view/warden/state/warden_home_state.dart';
import 'package:hostel_mgmt/presentation/view/warden/controller/warden_home_controller.dart';

class WardenHomePage extends StatelessWidget {
  final TimelineActor actor;
  WardenHomePage({Key? key, required this.actor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WardenHomeState>(
      builder: (context, state, _) {
        if (!state.isLoading && !state.isErrored && !state.hasData) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            WardenHomeController(state).fetchRequestsFromApi();
          });
        }
        final WardenHomeController controller = WardenHomeController(state);

        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        } else {
          final requests = state.currentOnScreenRequests
              .map((req) => req.request)
              .toList();
          return Column(
            children: [
              TextField(
                controller: state.filterController,
                decoration: InputDecoration(
                  hintText: 'Search by Enrollment no ...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),

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
                              // negative action
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
                          : null, // disabled when no selection
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
                          : null, // disabled when no selection
                      child: actor == TimelineActor.assistentWarden
                          ? Text(RequestAction.refer.name)
                          : Text(RequestAction.approve.name),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              // Tight divider with no extra vertical spacing
              const Divider(height: 1, thickness: 1),
              SizedBox(height: 12),
              Expanded(
                child: requests.isEmpty
                    ? const Center(child: Text('No requests found.'))
                    : state.isActioning
                    ? const Center(child: CircularProgressIndicator())
                    : MediaQuery.removePadding(
                        context: context,
                        removeTop: true, // remove the automatic top padding
                        child: ListView.builder(
                          padding: EdgeInsets.zero, // no extra list padding
                          primary: false, // don’t apply primary scroll padding
                          itemCount: requests.length,
                          itemBuilder: (context, index) {
                            final req = requests[index];
                            final selected = state.isSelectedById(
                              req.requestId,
                            );
                            return SimpleActionRequestCard(
                              reason: req.reason,
                              name: req.studentEnrollmentNumber,
                              status: req.status,
                              leaveType: req.requestType,
                              fromDate: req.appliedFrom,
                              toDate: req.appliedTo,
                              selected: selected,

                              // gestures
                              onLongPress:
                                  (!state.isActioning && !state.hasSelection)
                                  ? () =>
                                        state.toggleSelectedById(req.requestId)
                                  : null,
                              onTap: (!state.isActioning && state.hasSelection)
                                  ? () =>
                                        state.toggleSelectedById(req.requestId)
                                  : null,

                              // per-item actions disabled during selection
                              onRejection:
                                  (!state.hasSelection && !state.isActioning)
                                  ? () {
                                      controller.actionRequestById(
                                        action:
                                            actor ==
                                                TimelineActor.assistentWarden
                                            ? RequestAction.cancel
                                            : RequestAction.reject,
                                        requestId: req.requestId,
                                      );
                                      context.goNamed(
                                        AppRoutes.wardenHome,
                                        queryParameters: {
                                          'ts': DateTime.now()
                                              .millisecondsSinceEpoch
                                              .toString(),
                                        },
                                      );
                                    }
                                  : null,
                              onAcceptence:
                                  (!state.hasSelection && !state.isActioning)
                                  ? () {
                                      controller.actionRequestById(
                                        action:
                                            actor ==
                                                TimelineActor.assistentWarden
                                            ? RequestAction.refer
                                            : RequestAction.approve,
                                        requestId: req.requestId,
                                      );
                                      context.goNamed(
                                        // AppRoutes.wardenHome,
                                        "warden-home",
                                        queryParameters: {
                                          'ts': DateTime.now()
                                              .millisecondsSinceEpoch
                                              .toString(),
                                        },
                                      );
                                    }
                                  : null,
                            );
                          },
                        ),
                      ),
              ),
            ],
          );
        }
      },
    );
  }
}
