import 'package:flutter/material.dart';

class StatusTag extends StatelessWidget {
  final String status;
  final double fontSize;
  final Color color;
  final bool overflow;

  const StatusTag({
    super.key,
    required this.status,
    this.fontSize = 12,
    this.overflow = true,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        overflow ? status.split(' ').join('\n') : status,
        style: TextStyle(
          fontSize: fontSize,
          // color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
