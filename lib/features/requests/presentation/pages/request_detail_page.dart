import 'package:flutter/material.dart';
import 'package:hostel_dayout_app/core/enums/actions.dart';
import 'package:hostel_dayout_app/core/enums/request_status.dart';
import 'package:hostel_dayout_app/injection.dart';
import 'package:hostel_dayout_app/features/requests/presentation/bloc/action_mapping.dart';
import 'package:hostel_dayout_app/features/requests/presentation/widgets/confirmation_dialog.dart';
import 'package:hostel_dayout_app/features/requests/presentation/widgets/parent_info_card.dart';
import 'package:hostel_dayout_app/features/requests/presentation/widgets/request_detail_card.dart';
import 'package:hostel_dayout_app/features/requests/presentation/widgets/status_tag.dart';
import 'package:hostel_dayout_app/features/requests/presentation/widgets/timeline_item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/request_detail_bloc.dart';
import '../bloc/request_detail_event.dart';
import '../bloc/request_detail_state.dart';

class RequestDetailsPage extends StatelessWidget {
  final String requestId;

  const RequestDetailsPage({super.key, required this.requestId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider<RequestDetailBloc>(
        create: (context) =>
            sl<RequestDetailBloc>()..add(LoadRequestDetailEvent(requestId)),
        child: BlocBuilder<RequestDetailBloc, RequestDetailState>(
          builder: (context, state) {
            if (state is RequestDetailLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is RequestDetailError) {
              return Center(
                child: Text(state.message, style: TextStyle(color: Colors.red)),
              );
            } else if (state is RequestDetailLoaded) {
              final request = state.request;
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => FocusScope.of(context).unfocus(),
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    request.student.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text(
                                    '${request.student.enrollment} - ${request.student.room}',
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                ],
                              ),
                              StatusTag(
                                status: request.status.displayName,
                                overflow: false,
                                fontSize: 14,
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          RequestDetailCard(
                            type: request.type.name,
                            outTime: request.outTime,
                            returnTime: request.returnTime,
                            reason: request.reason,
                            requestedOn: request.requestedAt,
                          ),

                          const SizedBox(height: 12),

                          ParentInfoCard(
                            title: 'Parent',
                            name: request.parent.name,
                            relation: request.parent.relationship,
                            phoneNumber: request.parent.phone,
                          ),

                          const SizedBox(height: 12),

                          const Text(
                            'Timeline',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),

                          const SizedBox(height: 8),

                          ...request.timeline.reversed.map(
                            (event) => TimelineItem(eventType: event),
                          ),
                          if (request.timeline.isEmpty)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Text(
                                'No actions available for this status.',
                                style: TextStyle(color: Colors.black54),
                              ),
                            ),

                          (!ActionMapping.getActionForRequest(
                                request.status,
                              ).contains(RequestAction.none))
                              ? ElevatedButton(
                                  onPressed: null,
                                  child: null,
                                  style: ElevatedButtonTheme.of(context).style!
                                      .copyWith(
                                        backgroundColor:
                                            WidgetStateProperty.all(
                                              Colors.transparent,
                                            ),
                                      ),
                                )
                              : const SizedBox.shrink(),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          boxShadow:
                              //       (!ActionMapping.getActionForRequest(
                              //         request.status,
                              //       ).contains(RequestAction.none))
                              //       ? [
                              //           BoxShadow(
                              //             color: Colors.black12,
                              //             blurRadius: 4,
                              //             offset: Offset(0, -2),
                              //           ),
                              //         ]
                              [],
                        ),
                        child: Row(
                          children:
                              ActionMapping.getActionForRequest(
                                request.status,
                              ).map((action) {
                                return (action != RequestAction.none)
                                    ? Expanded(
                                        flex: 1,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 4,
                                          ),
                                          child: ElevatedButton(
                                            onPressed: () {
                                              ConfirmDialog.show(
                                                context: context,
                                                title: action
                                                    .dialogBoxMessage
                                                    .title,
                                                description: action
                                                    .dialogBoxMessage
                                                    .description,
                                                confirmText: action
                                                    .dialogBoxMessage
                                                    .confirmText,
                                                onConfirm: () {
                                                  context
                                                      .read<RequestDetailBloc>()
                                                      .add(
                                                        UpdateRequestDetailEvent(
                                                          request:
                                                              state.request,
                                                          updatedStatuse:
                                                              ActionMapping.getResultingStatusForAction(
                                                                action,
                                                              ),
                                                        ),
                                                      );
                                                },
                                              );
                                            },
                                            style:
                                                ElevatedButtonTheme.of(
                                                  context,
                                                ).style!.copyWith(
                                                  backgroundColor:
                                                      WidgetStateProperty.all(
                                                        action.actionColor,
                                                      ),
                                                  foregroundColor:
                                                      WidgetStateProperty.all(
                                                        Colors.white,
                                                      ),
                                                ),
                                            child: Text(action.name),
                                          ),
                                        ),
                                      )
                                    : const SizedBox.shrink();
                              }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
