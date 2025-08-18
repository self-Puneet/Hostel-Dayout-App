import 'package:flutter/material.dart';
import 'package:hostel_dayout_app/core/enums/enum.dart';
import 'package:hostel_dayout_app/core/util/input_convertor.dart';
import 'package:hostel_dayout_app/features/requests/domain/entities/timeline_event.dart';

class TimelineItem extends StatelessWidget {
  final TimelineEvent eventType;

  const TimelineItem({super.key, required this.eventType});

  @override
  Widget build(BuildContext context) {
    final inputConverter = InputConverter();
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline indicator
          Column(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.purple.shade200,
                  shape: BoxShape.circle,
                ),
                child: eventType.icon,
              ),
            ],
          ),
          const SizedBox(width: 8),
          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  eventType.description,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      inputConverter
                          .dateFormater(eventType.timestamp)
                          .getOrElse(() => ''),
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '• ${eventType.actor.displayName}',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
