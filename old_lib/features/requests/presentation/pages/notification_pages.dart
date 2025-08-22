import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          // Simulate loading for 1 second
          await Future.delayed(const Duration(seconds: 1));
        },
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: const [
            NotificationCard(
              title: 'Parent accepted request REQ-0002',
              timestamp: '8/19/2025, 10:38:54 AM',
            ),
            SizedBox(height: 12), // Spacing between cards
            NotificationCard(
              title: 'Overdue return for REQ-0004',
              timestamp: '8/19/2025 -  9:38:54 AM',
            ),
          ],
        ),
      ),
    );
  }
}

/// A reusable widget to display a notification card.
class NotificationCard extends StatelessWidget {
  final String title;
  final String timestamp;

  const NotificationCard({
    super.key,
    required this.title,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    // Card provides the rounded corners, shadow, and background color.
    return Card(
      elevation: 2.0,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        // The original image has a very light border
        side: BorderSide(color: Colors.grey.shade300, width: 1),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          // Align text to the start (left)
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Main notification text
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF333333),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8), // Spacing between title and timestamp
            // Timestamp text
            Text(
              timestamp,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
