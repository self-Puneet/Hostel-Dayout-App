import 'package:flutter/material.dart';
import 'simple_request_card.dart';

class MonthlyRequestSection extends StatelessWidget {
  final String monthYear; // e.g. "August 2025"
  final List<SimpleRequestCard> requests;

  const MonthlyRequestSection({
    super.key,
    required this.monthYear,
    required this.requests,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Month header
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Month",
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              ),
              Text(
                monthYear,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(),
          // Requests list - appears from most recent to oldest
          ...requests.reversed.toList().asMap().entries.map((entry) {
            final index = entry.key;
            final request = entry.value;
            final isLast = index == requests.length - 1;
            return Column(children: [request, if (!isLast) const Divider()]);
          }),
        ],
      ),
    );
  }
}
