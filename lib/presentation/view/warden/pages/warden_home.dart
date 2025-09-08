import 'package:flutter/material.dart';
import 'package:hostel_mgmt/core/enums/actions.dart';
import 'package:hostel_mgmt/core/enums/enum.dart';
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
        } else if (state.isErrored) {
          return Center(
            child: Text(
              state.errorMessage,
              style: const TextStyle(color: Colors.red, fontSize: 16),
            ),
          );
        } else {
          final requests = state.currentOnScreenRequests
              .map((req) => req.request)
              .toList();
          return Column(
            children: [
              TextField(
                controller: state.filterController,
                decoration: InputDecoration(
                  hintText: 'Search by student name...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Top action row: enable only if selection exists and not actioning
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
                                // controller.bulkCancelSelected();
                              } else {
                                // controller.bulkRejectSelected();
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
                              // positive action
                              if (actor == TimelineActor.assistentWarden) {
                                // controller.bulkReferSelected();
                              } else {
                                // controller.bulkApproveSelected();
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
                              onCancel:
                                  (!state.hasSelection && !state.isActioning)
                                  ? () => controller.acceptRequestbyId(
                                      req.requestId,
                                    )
                                  : null,
                              onReferToParent:
                                  (!state.hasSelection && !state.isActioning)
                                  ? () => controller.rejectRequestbyId(
                                      req.requestId,
                                    )
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
