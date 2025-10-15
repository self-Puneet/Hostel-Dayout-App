import 'package:flutter/material.dart';
class StatCardData {
  final Color dotColor;
  final int value;
  final String valueLabel;
  final List<Map<String, dynamic>> breakdown; // e.g., [{"label": ..., "value": ...}]
  final VoidCallback? onTap;

  const StatCardData({
    required this.dotColor,
    required this.value,
    required this.valueLabel,
    this.breakdown = const [],
    this.onTap,
  });
}
