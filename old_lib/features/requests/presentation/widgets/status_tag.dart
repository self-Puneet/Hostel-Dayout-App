import 'package:flutter/material.dart';

class StatusTag extends StatelessWidget {
  final String status;
  final double fontSize;
  final bool overflow;

  const StatusTag({
    super.key,
    required this.status,
    this.fontSize = 12,
    this.overflow = true,
  });

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'requested': // Student submitted
        return Colors.blue;
      case 'referred': // Sent to parent
        return Colors.orange;
      case 'cancelled': // Warden cancelled before review
        return Colors.grey;
      case 'parent approved':
        return Colors.green;
      case 'parent denied':
        return Colors.redAccent;
      case 'rejected': // Warden rejected after parent approval
        return Colors.red;
      case 'approved': // Warden approved after parent approval
        return Colors.green.shade700;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _statusColor(status).withValues(alpha: 0.15),

        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        overflow ? status.split(' ').join('\n') : status,
        style: TextStyle(
          fontSize: fontSize,
          color: _statusColor(status),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
