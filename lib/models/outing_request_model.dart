
import 'package:flutter/material.dart';
import 'package:hostel_mgmt/core/enums/enum.dart';

/// Represents a full Outing Request (for submit).
class OutingRequestModel {
  final RequestType type;
  final DateTime? dayoutDate;
  final TimeOfDay? dayoutFromTime;
  final TimeOfDay? dayoutToTime;
  final DateTime? leaveFromDate;
  final DateTime? leaveToDate;
  final TimeOfDay? leaveFromTime;
  final TimeOfDay? leaveToTime;

  OutingRequestModel({
    required this.type,
    this.dayoutDate,
    this.dayoutFromTime,
    this.dayoutToTime,
    this.leaveFromDate,
    this.leaveToDate,
    this.leaveFromTime,
    this.leaveToTime,
  });
}

/// Helper to compare TimeOfDay by minutes-since-midnight.
int timeOfDayToMinutes(TimeOfDay t) => t.hour * 60 + t.minute;
