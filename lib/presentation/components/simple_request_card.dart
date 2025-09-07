import 'package:flutter/material.dart';
import 'package:hostel_mgmt/core/enums/request_status.dart';
import 'package:hostel_mgmt/core/enums/request_type.dart';
import 'package:hostel_mgmt/core/util/input_convertor.dart';
import 'package:hostel_mgmt/presentation/widgets/status_tag.dart';

class SimpleRequestCard extends StatelessWidget {
  final RequestType? requestType;
  final DateTime fromDate;
  final DateTime toDate;
  final RequestStatus status; // e.g., "Approved"
  final DateTime statusDate; // e.g., "22/08"

  const SimpleRequestCard({
    Key? key,
    required this.requestType,
    required this.fromDate,
    required this.toDate,
    required this.status,
    required this.statusDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Request info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                requestType,
                style: const TextStyle(
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w500, // 500 = Medium
                  fontStyle: FontStyle
                      .normal, // "Medium" here means weight, not italic
                  fontSize: 18, // px → logical pixels
                  height: 1.0, // line-height: 100% → 1.0
                  letterSpacing: 0.0, // 0%
                ),
              ),
              SizedBox(height: 15),
              Text(
                "${InputConverter.dateFormater(fromDate)}\n\n${InputConverter.dateFormater(toDate)}",
                style: const TextStyle(
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w400, // 400 = regular
                  fontStyle: FontStyle.normal, // Regular
                  fontSize: 12, // in logical pixels
                  height: 1.0, // line-height: 100% → 1.0
                  letterSpacing: 0.0, // 0%
                ),
              ),
            ],
          ),
        ),
        // Status and date
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            StatusTag(
              status: status.minimalDisplayName,
              color: status.minimalStatusColor,
            ),
            SizedBox(height: 10),
            Text(
              'ON ${InputConverter.dateToDayMonth(statusDate)}',
              style: TextStyle(
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
