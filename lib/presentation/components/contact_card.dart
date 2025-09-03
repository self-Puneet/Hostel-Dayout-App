import 'package:flutter/material.dart';
import 'package:hostel_mgmt/presentation/widgets/call_button.dart';

class ContactCard extends StatelessWidget {
  final String name;
  final String role;
  final String phoneNumber;

  const ContactCard({
    Key? key,
    required this.name,
    required this.role,
    required this.phoneNumber,
  }) : super(key: key);

  /// Get initials from name
  String _getInitials(String fullName) {
    final parts = fullName.trim().split(" ");
    if (parts.length > 1) {
      return "${parts[0][0]}${parts[1][0]}".toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar with initials
          CircleAvatar(
            radius: 22,
            backgroundColor: Colors.blue.shade50,
            child: Text(
              _getInitials(name),
              style: const TextStyle(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
            ),
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
