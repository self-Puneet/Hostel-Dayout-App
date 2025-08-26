import 'package:flutter/material.dart';

class OutingRule {
  final bool isRestricted;
  final bool isUnrestricted;
  final TimeOfDay? fromTime;
  final TimeOfDay? toTime;

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
    if (_compareTimeOfDay(fromTime!, toTime!) >= 0) {
      throw ArgumentError("fromTime must be before toTime.");
    }
  }

  /// Checks if a given DateTime's time-of-day falls in the allowed window
  bool isWithinAllowedTime(DateTime checkDateTime) {
    if (isRestricted) return false;
    if (isUnrestricted) return true;
    final checkTime = TimeOfDay.fromDateTime(checkDateTime);
    return _compareTimeOfDay(checkTime, fromTime!) >= 0 &&
        _compareTimeOfDay(checkTime, toTime!) <= 0;
  }

  /// Helper: formats a TimeOfDay into a readable string like "9:30 AM"
  static String formatTimeOfDay(TimeOfDay tod) {
    final hour = tod.hourOfPeriod == 0 ? 12 : tod.hourOfPeriod;
    final minute = tod.minute.toString().padLeft(2, '0');
    final period = tod.period == DayPeriod.am ? "AM" : "PM";
    return "$hour:$minute $period";
  }

  /// Utility: compares two TimeOfDay values
  /// returns negative if a < b, zero if equal, positive if a > b
  static int _compareTimeOfDay(TimeOfDay a, TimeOfDay b) {
    final aMinutes = a.hour * 60 + a.minute;
    final bMinutes = b.hour * 60 + b.minute;
    return aMinutes - bMinutes;
  }
}
