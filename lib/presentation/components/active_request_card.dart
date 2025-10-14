// active_request_card.dart
import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
import 'package:hostel_mgmt/core/enums/enum.dart';
import 'package:hostel_mgmt/core/theme/app_theme.dart';
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
  final TimelineActor actor;
  final String reason;
  final RequestType requestType;
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
    required this.actor,
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
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        // if (actor == TimelineActor.student) {
        //   context.pushNamed(
        //     'request-detail',
        //     pathParameters: {'id': requestId},
        //   );
        // } else if (actor == TimelineActor.parent) {
        //   context.pushNamed(
        //     'request-detail-parent',
        //     pathParameters: {'id': requestId},
        //   );
        // }
      },
      borderRadius: BorderRadius.circular(28),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha((0.25 * 225).toInt()),
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
                        Text(
                          "ACTIVE REQUEST",
                          style: textTheme.h6.w500, // 14pt w700 closest
                        ),
                        Text(
                          requestType.displayName.toUpperCase(),
                          style: textTheme.h3.w300.copyWith(
                            letterSpacing: (requestType == RequestType.dayout)
                                ? 3.8
                                : 9,
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
              const SizedBox(height: 14),
              const Divider(thickness: 1, color: Color(0xFF757575)),
              const SizedBox(height: 15),
              // Reason
              Text(
                "\"$reason\"",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: textTheme.h5.w300.copyWith(fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 15),
              // Dates row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_month, color: Colors.grey, size: 24),
                  const SizedBox(width: 6),
                  Text(_formatDate(fromDate), style: textTheme.h7.w500.copyWith(color: greyColor)),
                  const Spacer(),
                  Text('TO', style: textTheme.h7.w500.copyWith(color: greyColor)),
                  const Spacer(),
                  Text(_formatDate(toDate), style: textTheme.h7.w500.copyWith(color: greyColor)),
                ],
              ),
              // Timeline
              SizedBox(
                height: 80,
                child: HorizontalCheckpointTimeline(
                  checkpoints: status.chceckpointState,
                ),
              ),
              if (showActions == true) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: onApprove,
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
                        onPressed: onDecline,
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
            ],
          ),
        ),
      ),
    );
  }
}
