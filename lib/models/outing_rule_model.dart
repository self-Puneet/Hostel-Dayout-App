import 'package:flutter/material.dart';

class OutingRule {
  final bool isRestricted;
  final bool isUnrestricted;
  final Duration? fromTime;
  final Duration? toTime;

  OutingRule.restricted()
    : isRestricted = true,
      isUnrestricted = false,
      fromTime = null,
      toTime = null;

  OutingRule.unrestricted()
    : isRestricted = false,
      isUnrestricted = true,
      fromTime = null,
      toTime = null;

  OutingRule.allowed({required this.fromTime, required this.toTime})
    : isRestricted = false,
      isUnrestricted = false {
    if (fromTime == null || toTime == null) {
      throw ArgumentError("fromTime and toTime must be provided.");
    }
    if (fromTime! >= toTime!) {
      throw ArgumentError("fromTime must be before toTime.");
    }
  }

  /// Checks if a given DateTime's time-of-day falls in the allowed window
  bool isWithinAllowedTime(DateTime checkDateTime) {
    if (isRestricted) return false;
    if (isUnrestricted) return true;
    final checkTime = Duration(
      hours: checkDateTime.hour,
      minutes: checkDateTime.minute,
    );
    return checkTime >= fromTime! && checkTime <= toTime!;
  }

  /// Helper: formats a Duration into a readable string like "09:30"
  static String formatDuration(Duration d) {
    final hours = d.inHours;
    final minutes = d.inMinutes % 60;
    return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}";
  }
}
