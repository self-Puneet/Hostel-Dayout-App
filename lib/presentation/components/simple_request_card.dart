import 'package:flutter/material.dart';
import 'package:hostel_mgmt/core/enums/request_status.dart';
import 'package:hostel_mgmt/core/enums/request_type.dart';
import 'package:hostel_mgmt/core/util/input_convertor.dart';
import 'package:hostel_mgmt/presentation/widgets/status_tag.dart';

class SimpleRequestCard extends StatelessWidget {
  final RequestType requestType;
  final DateTime fromDate;
  final DateTime toDate;
  final RequestStatus status; // e.g., "Approved"
  final DateTime statusDate; // e.g., "22/08"
  final String reason; // NEW

  const SimpleRequestCard({
    Key? key,
    required this.requestType,
    required this.fromDate,
    required this.toDate,
    required this.status,
    required this.statusDate,
    required this.reason, // NEW
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Request info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                requestType.displayName,
                style: const TextStyle(
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w500, // 500 = Medium
                  fontStyle: FontStyle.normal,
                  fontSize: 18,
                  height: 1.0,
                  letterSpacing: 0.0,
                ),
              ),

              const SizedBox(height: 10),
              Text(
                "\"$reason\"",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                style: const TextStyle(
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.italic,
                  fontSize: 12,
                  height: 1.2,
                  letterSpacing: 0.0,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "${InputConverter.dateFormater(fromDate)}\n\n${InputConverter.dateFormater(toDate)}",
                style: const TextStyle(
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.normal,
                  fontSize: 12,
                  height: 1.0,
                  letterSpacing: 0.0,
                ),
              ),

              // Reason text (2 lines + ellipsis)
            ],
          ),
        ),
        const SizedBox(width: 12),
        // Status and date
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            StatusTag(
              status: status.minimalDisplayName,
              color: status.minimalStatusColor,
            ),
            const SizedBox(height: 10),
            Text(
              'ON ${InputConverter.dateToDayMonth(statusDate)}',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                fontSize: 12,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
