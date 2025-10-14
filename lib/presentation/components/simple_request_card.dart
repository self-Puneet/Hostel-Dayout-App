import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hostel_mgmt/core/enums/enum.dart';
import 'package:hostel_mgmt/core/enums/request_status.dart';
import 'package:hostel_mgmt/core/enums/request_type.dart';
import 'package:hostel_mgmt/core/theme/app_theme.dart';
import 'package:hostel_mgmt/core/util/input_convertor.dart';
import 'package:hostel_mgmt/presentation/widgets/status_tag.dart';

class SimpleRequestCard extends StatelessWidget {
  final RequestType requestType;
  final DateTime fromDate;
  final DateTime toDate;
  final RequestStatus status; // e.g., "Approved"
  final DateTime statusDate; // e.g., "22/08"
  final String reason; // NEW
  final TimelineActor? actor; // NEW
  final String requestId; // NEW

  const SimpleRequestCard({
    Key? key,
    required this.requestType,
    required this.fromDate,
    required this.toDate,
    required this.status,
    required this.statusDate,
    required this.reason,
    required this.actor,
    required this.requestId,
  }) : super(key: key);
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
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(), // 🟢 left column flexes (takes all remaining width)
          1: IntrinsicColumnWidth(), // 🟣 right column only takes required space
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          // 🟢 Row 1: Request type + Status tag
          TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(requestType.displayName, style: textTheme.h4.w500),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: StatusTag(
                  status: status.minimalDisplayName,
                  color: status.minimalStatusColor,
                ),
              ),
            ],
          ),

          // 🟣 Row 2: Date range/time + Status date
          TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: requestType == RequestType.leave
                    ? Text(
                        "${InputConverter.dateToMonthDay(fromDate)} - ${InputConverter.dateToMonthDay(toDate)}",
                        style: textTheme.h6,
                      )
                    : Text(
                        "${InputConverter.dateToMonthDay(fromDate)} | ${InputConverter.formatTime(fromDate)} - ${InputConverter.formatTime(toDate)}",
                        style: textTheme.h6,
                      ),
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    'ON ${InputConverter.dateToDayMonth(statusDate)}',
                    style: textTheme.h7.w300,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget reasonSection(TextTheme textTheme) {
    return Text(
      "\"$reason\"",
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      softWrap: true,
      style: textTheme.bodySmall?.copyWith(
        fontStyle: FontStyle.italic,
        height: 1.2,
        color: Colors.black87,
      ),
    );
  }
}
