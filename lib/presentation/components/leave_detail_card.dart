import 'package:flutter/material.dart';
import 'package:hostel_mgmt/core/util/input_convertor.dart';

class LeaveDetailCard extends StatelessWidget {
  final DateTime outDateTime;
  final DateTime inDateTime;
  final String reason;
  final String? parentRemark;

  const LeaveDetailCard({
    super.key,
    required this.outDateTime,
    required this.inDateTime,
    required this.reason,
    this.parentRemark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _dateColumn(
                      icon: Icon(
                        Icons.calendar_month,
                        size: 30,
                        color: Colors.grey,
                      ),
                      label: "Out Date",
                      date: InputConverter.formatDate(outDateTime),
                    ),
                    _dateColumn(
                      icon: Icon(
                        Icons.access_time,
                        size: 30,
                        color: Colors.grey,
                      ),
                      label: "Out Time",
                      date: InputConverter.formatTime(outDateTime),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _dateColumn(
                      icon: Icon(
                        Icons.calendar_month,
                        size: 30,
                        color: Colors.grey,
                      ),
                      label: "In Date",
                      date: InputConverter.formatDate(inDateTime),
                    ),
                    _dateColumn(
                      icon: Icon(
                        Icons.access_time,
                        size: 30,
                        color: Colors.grey,
                      ),
                      label: "In Time",
                      date: InputConverter.formatTime(inDateTime),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// Reason
            const Text("Reason", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(reason, style: const TextStyle(color: Colors.black87)),

            parentRemark != null && parentRemark != ''
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      const Text(
                        "Parent Remark",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        parentRemark!,
                        style: const TextStyle(color: Colors.black87),
                      ),
                    ],
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget _dateColumn({
    required String label,
    required String date,
    required Icon icon,
  }) {
    return Padding(
      padding: EdgeInsetsGeometry.symmetric(vertical: 10),
      child: Row(
        children: [
          icon,
          const SizedBox(width: 4),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.grey)),
              Text(
                date,
                style: const TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
