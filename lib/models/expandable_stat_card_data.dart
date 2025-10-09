import 'package:flutter/material.dart';

class ExpandableStatCardData {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final int value;
  final String valueLabel;
  final String title;
  final List<Map<String, dynamic>> breakdown;
  final VoidCallback? onTap;

  const ExpandableStatCardData({
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.value,
    required this.valueLabel,
    required this.title,
    this.breakdown = const [],
    this.onTap,
  });
}