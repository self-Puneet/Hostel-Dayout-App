import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CallButton extends StatelessWidget {
  final String phoneNumber;

  const CallButton({super.key, required this.phoneNumber});

  Future<void> _makePhoneCall(String number) async {
    final Uri uri = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _makePhoneCall(phoneNumber);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blue.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.call, color: Colors.blue, size: 20),
      ),
    );
  }
}
