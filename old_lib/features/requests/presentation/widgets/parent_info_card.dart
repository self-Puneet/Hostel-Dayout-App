import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ParentInfoCard extends StatelessWidget {
  final String title;
  final String name;
  final String relation;
  final String phoneNumber;

  const ParentInfoCard({
    Key? key,
    required this.title,
    required this.name,
    required this.relation,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 2,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "$name • $relation",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  phoneNumber,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.blue[700]),
                ),
              ],
            ),
            IconButton(
              onPressed: () async {
                final Uri uri = Uri(scheme: 'tel', path: phoneNumber);

                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Could not launch dialer')),
                  );
                }
              },
              // style: ButtonStyle(backgroundColor: Theme.of(context).primaryColor),
              icon: const Icon(Icons.phone),
              color: Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }
}
