import 'package:flutter/material.dart';
import 'package:hostel_mgmt/core/enums/enum.dart';

class StatusTag extends StatelessWidget {
  final RequestStatus status;
  final double fontSize;
  final bool overflow;

  const StatusTag({
    super.key,
    required this.status,
    this.fontSize = 12,
    this.overflow = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: status.statusColor.withValues(alpha: 0.15),

        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        overflow
            ? status.displayName.split(' ').join('\n')
            : status.displayName,
        style: TextStyle(
          fontSize: fontSize,
          color: status.statusColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
