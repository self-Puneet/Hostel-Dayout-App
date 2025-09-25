import 'package:flutter/material.dart';

class RestrictionWindow {
  final bool errroLoading;
  final bool allowedToday;
  final TimeOfDay minTime;
  final TimeOfDay maxTime;
  final String timezone;
  final String note;

  RestrictionWindow({
    this.errroLoading = false,
    required this.allowedToday,
    required this.minTime,
    required this.maxTime,
    required this.timezone,
    required this.note,
  });

  /// Parses from API JSON response (assumes HH:mm strings).
  factory RestrictionWindow.fromJson(Map<String, dynamic> json) {
    final min = _parseTime(json['minTime']);
    final max = _parseTime(json['maxTime']);
    return RestrictionWindow(
      allowedToday: json['allowedToday'] as bool,
      minTime: min,
      maxTime: max,
      timezone: json['timezone'] as String,
      note: json['note'] as String,
    );
  }

  /// Helper to parse "HH:mm" string into TimeOfDay.
  static TimeOfDay _parseTime(String str) {
    final parts = str.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }
}
