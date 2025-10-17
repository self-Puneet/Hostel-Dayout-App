import 'package:flutter/material.dart';
import 'package:hostel_mgmt/core/theme/app_theme.dart';
import 'package:hostel_mgmt/core/util/string_extensions.dart';
import 'package:hostel_mgmt/presentation/widgets/call_button.dart';

class ContactCard extends StatelessWidget {
  final String name;
  final String role;
  final String phoneNumber;
  final String? imageUrl;

  const ContactCard({
    Key? key,
    this.imageUrl,
    required this.name,
    required this.role,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Color.fromRGBO(246, 246, 246, 1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: Colors.blue.shade100,
            backgroundImage: (imageUrl != null && imageUrl!.trim() != "")
                ? NetworkImage(imageUrl!)
                : null,
            child: (imageUrl != null && imageUrl!.trim() != "")
                ? null
                : Text(name.initials, style: textTheme.h3.w500),
          ),
          const SizedBox(width: 12),
          // Name & Role
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Text(
                  role,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                ),
              ],
            ),
          ),
          // Call button
          CallButton(phoneNumber: phoneNumber),
        ],
      ),
    );
  }
}
