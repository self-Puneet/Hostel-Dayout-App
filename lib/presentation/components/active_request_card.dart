// active_request_card.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hostel_mgmt/core/enums/enum.dart';
import 'package:hostel_mgmt/presentation/widgets/status_tag.dart';
import 'package:hostel_mgmt/presentation/widgets/timeline.dart';

extension RequestStatusX1 on RequestStatus {
  List<Checkpoint> get chceckpointState {
    switch (this) {
      case RequestStatus.requested:
        return [
          Checkpoint('Requested', CheckpointState.completed),
          Checkpoint('Assistent Warden', CheckpointState.notCompleted),
          Checkpoint('Parent', CheckpointState.notCompleted),
          Checkpoint('Senior Warden', CheckpointState.notCompleted),
        ];
      case RequestStatus.referred:
        return [
          Checkpoint('Requested', CheckpointState.completed),
          Checkpoint('Assistent Warden', CheckpointState.completed),
          Checkpoint('Parent', CheckpointState.notCompleted),
          Checkpoint('Senior Warden', CheckpointState.notCompleted),
        ];
      case RequestStatus.cancelled:
        return [
          Checkpoint('Requested', CheckpointState.completed),
          Checkpoint('Assistent Warden', CheckpointState.rejected),
          Checkpoint('Parent', CheckpointState.notCompleted),
          Checkpoint('Senior Warden', CheckpointState.notCompleted),
        ];
      case RequestStatus.parentApproved:
        return [
          Checkpoint('Requested', CheckpointState.completed),
          Checkpoint('Assistent Warden', CheckpointState.completed),
          Checkpoint('Parent', CheckpointState.completed),
          Checkpoint('Senior Warden', CheckpointState.notCompleted),
        ];
      case RequestStatus.parentDenied:
        return [
          Checkpoint('Requested', CheckpointState.completed),
          Checkpoint('Assistent Warden', CheckpointState.completed),
          Checkpoint('Parent', CheckpointState.rejected),
          Checkpoint('Senior Warden', CheckpointState.notCompleted),
        ];
      case RequestStatus.rejected:
        return [
          Checkpoint('Requested', CheckpointState.completed),
          Checkpoint('Assistent Warden', CheckpointState.completed),
          Checkpoint('Parent', CheckpointState.completed),
          Checkpoint('Senior Warden', CheckpointState.rejected),
        ];
      case RequestStatus.approved:
        return [
          Checkpoint('Requested', CheckpointState.completed),
          Checkpoint('Assistent Warden', CheckpointState.completed),
          Checkpoint('Parent', CheckpointState.completed),
          Checkpoint('Senior Warden', CheckpointState.completed),
        ];
      case RequestStatus.cancelledStudent:
        return [
          Checkpoint('Requested', CheckpointState.rejected),
          Checkpoint('Assistent Warden', CheckpointState.notCompleted),
          Checkpoint('Parent', CheckpointState.notCompleted),
          Checkpoint('Senior Warden', CheckpointState.notCompleted),
        ];
    }
  }
}

class ActiveRequestCard extends StatelessWidget {
  final String reason;
  final String requestType;
  final RequestStatus status;
  final DateTime fromDate;
  final DateTime toDate;
  final Widget timeline;
  final String requestId;
  final bool? showActions;

  // NEW: optional actions
  final VoidCallback? onApprove;
  final VoidCallback? onDecline;

  const ActiveRequestCard({
    Key? key,
    required this.reason,
    required this.requestType,
    required this.status,
    required this.fromDate,
    required this.toDate,
    required this.timeline,
    required this.requestId,
    this.showActions = false,
    this.onApprove,
    this.onDecline,
  }) : super(key: key);

  String _formatDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';

  @override
  Widget build(BuildContext context) {
    print("Show actions: $showActions");
    // final showActions = onApprove != null || onDecline != null;
    return InkWell(
      // remove splash effect
      highlightColor: Colors.transparent,

      splashColor: Colors.transparent,
      // onTap: () {
      // context.push('/request/$requestId');
      onTap: () {
        context.pushNamed('request-detail', pathParameters: {'id': requestId});
        // }
      },
      borderRadius: BorderRadius.circular(28),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              offset: const Offset(0, 0),
              blurRadius: 14,
              spreadRadius: 2,
            ),
          ],
        ),
        margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 24),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title Section
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "ACTIVE REQUEST",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          requestType.toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 22,
                            letterSpacing: 6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  StatusTag(
                    status: status.minimalDisplayName,
                    color: status.minimalStatusColor,
                  ),
                ],
              ),
              const Divider(thickness: 1, color: Color(0xFF757575)),
              const SizedBox(height: 15),
              // Reason
              Text(
                "\"$reason\"",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 15),
              // Dates
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    color: Colors.grey,
                    size: 24,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _formatDate(fromDate),
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.normal,
                      fontSize: 10,
                      height: 1.0,
                      letterSpacing: 0,
                    ),
                  ),
                  const Spacer(),
                  const Text(
                    'TO',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.normal,
                      fontSize: 10,
                      height: 1.0,
                      letterSpacing: 0,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    _formatDate(toDate),
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.normal,
                      fontSize: 10,
                      height: 1.0,
                      letterSpacing: 0,
                    ),
                  ),
                ],
              ),
              // Timeline
              SizedBox(
                height: 80,
                child: HorizontalCheckpointTimeline(
                  checkpoints: status.chceckpointState,
                ),
              ),
              showActions == true
                  ? Column(
                      children: [
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: onApprove, // null => disabled
                                icon: const Icon(Icons.check),
                                label: const Text('Approve'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: onDecline, // null => disabled
                                icon: const Icon(Icons.close),
                                label: const Text('Decline'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),

              // NEW: actions row at the bottom if provided
            ],
          ),
        ),
      ),
    );
  }
}
