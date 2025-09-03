import 'package:flutter/material.dart';
import 'package:timelines_plus/timelines_plus.dart';

class TimelineEvent {
  final String title;
  final String subtitle;
  final DateTime? time;
  final String? initials; // For avatar initials
  final String? profilePicUrl; // ✅ New field for profile pic
  final IconData? icon; // Optional icon
  final VoidCallback? onTap; // Optional click action

  TimelineEvent({
    required this.title,
    required this.subtitle,
    this.time,
    this.initials,
    this.profilePicUrl,
    this.icon,
    this.onTap,
  });
}

class RequestTimeline extends StatelessWidget {
  final List<TimelineEvent> events;

  const RequestTimeline({super.key, required this.events});

  String _formatTime(DateTime dt) {
    return "${dt.day} ${_month(dt.month)} | ${_formatClock(dt)}";
  }

  String _month(int m) {
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
    return months[m - 1];
  }

  String _formatClock(DateTime dt) {
    final hour = dt.hour > 12 ? dt.hour - 12 : dt.hour;
    final minute = dt.minute.toString().padLeft(2, '0');
    final amPm = dt.hour >= 12 ? "PM" : "AM";
    return "$hour:$minute $amPm";
  }

  @override
  Widget build(BuildContext context) {
    return Timeline.tileBuilder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      theme: TimelineThemeData(
        nodePosition: 0,
        color: Colors.blue,
        indicatorTheme: const IndicatorThemeData(size: 36),
        connectorTheme: const ConnectorThemeData(
          thickness: 2,
          color: Colors.blueAccent,
        ),
      ),
      builder: TimelineTileBuilder.connected(
        connectionDirection: ConnectionDirection.before,
        itemCount: events.length,
        contentsBuilder: (context, index) {
          final e = events[index];
          return Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  e.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (e.time != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    _formatTime(e.time!),
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
                if (e.subtitle.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    e.subtitle,
                    style: TextStyle(color: Colors.grey[700], fontSize: 13),
                  ),
                ],
              ],
            ),
          );
        },
        indicatorBuilder: (context, index) {
          final e = events[index];
          Widget indicator;

          if (e.profilePicUrl != null) {
            indicator = CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(
                e.profilePicUrl!,
              ), // ✅ show profile pic
              backgroundColor: Colors.grey[200],
            );
          } else if (e.initials != null) {
            indicator = CircleAvatar(
              radius: 18,
              backgroundColor: Colors.blue,
              child: Text(
                e.initials!,
                style: const TextStyle(color: Colors.white),
              ),
            );
          } else if (e.icon != null) {
            indicator = CircleAvatar(
              radius: 18,
              backgroundColor: Colors.grey[300],
              child: Icon(e.icon, color: Colors.black54),
            );
          } else {
            indicator = const DotIndicator(size: 20, color: Colors.blue);
          }

          // ✅ Make tappable if onTap is provided
          return e.onTap != null
              ? InkWell(
                  onTap: e.onTap,
                  borderRadius: BorderRadius.circular(18),
                  child: indicator,
                )
              : indicator;
        },

        connectorBuilder: (context, index, connectorType) {
          return const SolidLineConnector(color: Colors.blueAccent);
        },
      ),
    );
  }
}
