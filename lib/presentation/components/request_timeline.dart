import 'package:flutter/material.dart';
import 'package:hostel_mgmt/core/theme/app_theme.dart';
import 'package:timelines_plus/timelines_plus.dart';

enum TimelineStatus { inProgress, completed, rejected }

class TimelineEvent {
  final String title;
  final String? subtitle;
  final DateTime? time;
  final TimelineStatus status;

  TimelineEvent({
    required this.title,
    required this.subtitle,
    this.time,
    required this.status,
  });
}

class RequestTimeline extends StatelessWidget {
  final List<TimelineEvent> events;

  const RequestTimeline({super.key, required this.events});

  String _formatDate(DateTime dt) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    return "${dt.day.toString().padLeft(2, '0')} ${months[dt.month - 1]} ${dt.year}";
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour > 12 ? dt.hour - 12 : dt.hour;
    final minute = dt.minute.toString().padLeft(2, '0');
    final amPm = dt.hour >= 12 ? "PM" : "AM";
    return "$hour:$minute $amPm";
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    const double padding = 25;
    return Timeline.tileBuilder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      theme: TimelineThemeData(
        nodePosition: 0.4, // indicator in the center
        indicatorTheme: const IndicatorThemeData(size: 28),
        connectorTheme: const ConnectorThemeData(
          thickness: 3,
          color: Colors.green,
        ),
      ),
      padding: EdgeInsets.zero,
      builder: TimelineTileBuilder.connected(
        connectionDirection: ConnectionDirection.before,
        itemCount: events.length,

        // itemExtentBuilder: (_, __) => 120,
        contentsBuilder: (context, index) {
          final e = events[index];
          return Padding(
            padding: EdgeInsetsGeometry.symmetric(vertical: padding),
            child: Align(
              alignment: Alignment.centerLeft, // center with indicator
              child: (e.subtitle == null || e.subtitle == "")
                  ? Text(e.title, style: textTheme.h6)
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(e.title, style: textTheme.h6),
                        Text(
                          e.subtitle!,
                          style: textTheme.h7.copyWith(
                            color: Color.fromRGBO(0, 0, 0, 0.6),
                          ),
                        ),
                      ],
                    ),
            ),
          );
        },

        oppositeContentsBuilder: (context, index) {
          final e = events[index];
          return Padding(
            padding: EdgeInsetsGeometry.symmetric(vertical: padding),
            child: Align(
              alignment: Alignment.centerRight, // center with indicator
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (e.time != null)
                    Text(_formatDate(e.time!), style: textTheme.h6),
                  if (e.time != null)
                    Text(
                      _formatTime(e.time!),
                      style: textTheme.h7.copyWith(
                        color: Color.fromRGBO(0, 0, 0, 0.6),
                      ),
                    ),
                ],
              ),
            ),
          );
        },

        // ✅ Status indicator
        indicatorBuilder: (context, index) {
          final e = events[index];
          switch (e.status) {
            case TimelineStatus.completed:
              return Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 30),
                child: CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.green,
                  child: const Icon(Icons.check, color: Colors.white, size: 12),
                ),
              );
            case TimelineStatus.inProgress:
              return Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 30),
                child: CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.grey,
                  child: const Icon(
                    Icons.hourglass_top_rounded,
                    color: Colors.white,
                    size: 12,
                  ),
                ),
              );
            case TimelineStatus.rejected:
              return Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 30),
                child: CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.red,
                  child: const Icon(Icons.close, color: Colors.white, size: 12),
                ),
              );
          }
        },

        // ✅ Connector color
        connectorBuilder: (context, index, type) {
          final e = events[index];
          if (e.status == TimelineStatus.rejected) {
            return const SolidLineConnector(color: Colors.red, thickness: 3);
          } else if (e.status == TimelineStatus.inProgress) {
            return const SolidLineConnector(color: Colors.grey, thickness: 3);
          }
          return const SolidLineConnector(color: Colors.green, thickness: 3);
        },
      ),
    );
  }
}
