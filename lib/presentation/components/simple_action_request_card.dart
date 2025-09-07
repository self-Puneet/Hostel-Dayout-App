import 'package:flutter/material.dart';
import 'package:hostel_mgmt/core/enums/enum.dart';
import 'package:hostel_mgmt/core/util/input_convertor.dart';
import 'package:hostel_mgmt/presentation/widgets/status_tag.dart';

class SimpleActionRequestCard extends StatelessWidget {
  final String name;
  final RequestStatus status;
  final RequestType leaveType;
  final DateTime fromDate;
  final DateTime toDate;
  final VoidCallback? onCancel;
  final VoidCallback? onReferToParent;

  const SimpleActionRequestCard({
    super.key,
    required this.name,
    required this.status,
    required this.leaveType,
    required this.fromDate,
    required this.toDate,
    this.onCancel,
    this.onReferToParent,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header row
            Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        leaveType.displayName.toUpperCase(),
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                StatusTag(
                  status: status.displayName,
                  color: status.statusColor,
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// Dates
            Row(
              children: [
                const Icon(Icons.north_east, size: 16),
                const SizedBox(width: 6),
                Text(InputConverter.dateFormater(fromDate)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.south_west, size: 16),
                const SizedBox(width: 6),
                Text(InputConverter.dateFormater(toDate)),
              ],
            ),

            const SizedBox(height: 16),

            /// Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onCancel,
                    child: const Text("cancel"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onReferToParent,
                    child: const Text("refer to parent"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
