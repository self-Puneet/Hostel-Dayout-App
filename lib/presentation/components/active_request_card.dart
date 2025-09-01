import 'package:flutter/material.dart';
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
  final String requestType;
  final RequestStatus status;
  final DateTime fromDate;
  final DateTime toDate;
  final Widget timeline;

  const ActiveRequestCard({
    Key? key,
    required this.requestType,
    required this.status,
    required this.fromDate,
    required this.toDate,
    required this.timeline,
  }) : super(key: key);

  String _formatDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            offset: Offset(0, 0),
            blurRadius: 14,
            spreadRadius: 2,
          ),
        ],
      ),
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 24),
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
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        requestType,
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
            Divider(thickness: 1, color: Color(0xFF757575)),
            SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  color: Colors.grey[700],
                  size: 24,
                ),
                SizedBox(width: 6),
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
                Spacer(),
                Text(
                  'TO',
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.normal,
                    fontSize: 10,
                    height: 1.0,
                    letterSpacing: 0,
                  ),
                ),
                Spacer(),
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
            // SizedBox(height: 18),
            // SizedBox(height: 20),
            // Timeline Placeholder
            Container(
              // color: Colors.amber,
              height: 80,
              child: HorizontalCheckpointTimeline(
                checkpoints: status.chceckpointState,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
