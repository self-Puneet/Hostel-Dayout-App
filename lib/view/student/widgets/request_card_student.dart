import 'package:flutter/material.dart';
import 'package:hostel_mgmt/core/enums/request_status.dart';
import 'package:hostel_mgmt/core/enums/request_type.dart';
import 'package:hostel_mgmt/core/enums/timeline_actor.dart';
import 'package:hostel_mgmt/view/student/widgets/approval_step.dart';
import 'package:hostel_mgmt/view/student/widgets/status_tag.dart';

class RequestCard extends StatelessWidget {
  final String reason;
  final RequestStatus status;
  final RequestType type; // <---- changed
  final String outTime;
  final String inTime;
  final int currentStep;

  const RequestCard({
    super.key,
    required this.reason,
    required this.status,
    required this.type,
    required this.outTime,
    required this.inTime,
    required this.currentStep,
  });
  List<ApprovalStep> mapStatusToSteps(RequestStatus status) {
    switch (status) {
      case RequestStatus.requested:
        return [
          ApprovalStep(
            title: TimelineActor.warden.displayName,
            status: StepStatus.pending,
          ),
          ApprovalStep(
            title: TimelineActor.parent.displayName,
            status: StepStatus.pending,
          ),
          ApprovalStep(
            title: TimelineActor.seniorWarden.displayName,
            status: StepStatus.pending,
          ),
        ];

      case RequestStatus.referred:
        return [
          ApprovalStep(
            title: TimelineActor.warden.displayName,
            status: StepStatus.completed,
          ),
          ApprovalStep(
            title: TimelineActor.parent.displayName,
            status: StepStatus.pending,
          ),
          ApprovalStep(
            title: TimelineActor.seniorWarden.displayName,
            status: StepStatus.pending,
          ),
        ];

      case RequestStatus.cancelled:
        return [
          ApprovalStep(
            title: TimelineActor.warden.displayName,
            status: StepStatus.rejected,
          ),
          ApprovalStep(
            title: TimelineActor.parent.displayName,
            status: StepStatus.pending,
          ),
          ApprovalStep(
            title: TimelineActor.seniorWarden.displayName,
            status: StepStatus.pending,
          ),
        ];

      case RequestStatus.parentApproved:
        return [
          ApprovalStep(
            title: TimelineActor.warden.displayName,
            status: StepStatus.completed,
          ),
          ApprovalStep(
            title: TimelineActor.parent.displayName,
            status: StepStatus.completed,
          ),
          ApprovalStep(
            title: TimelineActor.seniorWarden.displayName,
            status: StepStatus.pending,
          ),
        ];

      case RequestStatus.parentDenied:
        return [
          ApprovalStep(
            title: TimelineActor.warden.displayName,
            status: StepStatus.completed,
          ),
          ApprovalStep(
            title: TimelineActor.parent.displayName,
            status: StepStatus.rejected,
          ),
          ApprovalStep(
            title: TimelineActor.seniorWarden.displayName,
            status: StepStatus.pending,
          ),
        ];

      case RequestStatus.rejected:
        return [
          ApprovalStep(
            title: TimelineActor.warden.displayName,
            status: StepStatus.completed,
          ),
          ApprovalStep(
            title: TimelineActor.parent.displayName,
            status: StepStatus.completed,
          ),
          ApprovalStep(
            title: TimelineActor.seniorWarden.displayName,
            status: StepStatus.rejected,
          ),
        ];

      case RequestStatus.approved:
        return [
          ApprovalStep(
            title: TimelineActor.warden.displayName,
            status: StepStatus.completed,
          ),
          ApprovalStep(
            title: TimelineActor.parent.displayName,
            status: StepStatus.completed,
          ),
          ApprovalStep(
            title: TimelineActor.seniorWarden.displayName,
            status: StepStatus.completed,
          ),
        ];

      case RequestStatus.inactive:
        return [
          ApprovalStep(
            title: TimelineActor.warden.displayName,
            status: StepStatus.pending,
          ),
          ApprovalStep(
            title: TimelineActor.parent.displayName,
            status: StepStatus.pending,
          ),
          ApprovalStep(
            title: TimelineActor.seniorWarden.displayName,
            status: StepStatus.pending,
          ),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --------- Header Row (Type + Status badge) -------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    reason,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.italic,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                ),

                StatusTag(status: status),
              ],
            ),
            const SizedBox(height: 6),
            Divider(thickness: 1, color: Colors.grey),
            const SizedBox(height: 6),

            ApprovalTimeline(steps: mapStatusToSteps(status)),

            // --------- Reason (highlighted) -------------
            const SizedBox(height: 16),

            // --------- Out/In Time Row -------------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    _timeInfoTile(
                      label: "Out Time",
                      time: outTime,
                      icon: Icons.logout,
                      iconColor: Colors.redAccent,
                    ),
                    SizedBox(height: 10),
                    _timeInfoTile(
                      label: "In Time",
                      time: inTime,
                      icon: Icons.login,
                      iconColor: Colors.green,
                    ),
                  ],
                ),
                Chip(
                  avatar: Icon(
                    type.icon, // ✅ from enum
                    color: Colors.white,
                    size: 18,
                  ),
                  label: Text(
                    type.displayName, // ✅ from enum
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: type.color, // ✅ from enum
                ),
              ],
            ),
            // const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _timeInfoTile({
    required String label,
    required String time,
    required IconData icon,
    Color iconColor = Colors.blueGrey,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(width: 6),
            Text(
              time,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}
