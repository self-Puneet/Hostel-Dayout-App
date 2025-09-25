import 'package:flutter/material.dart';
import 'package:hostel_mgmt/core/util/time_utils.dart';
import 'package:hostel_mgmt/models/restriction_window.dart';

class HostelSingleResponse {
  final String message;
  final HostelModel hostel;

  HostelSingleResponse({required this.message, required this.hostel});

  factory HostelSingleResponse.fromJson(Map<String, dynamic> json) {
    return HostelSingleResponse(
      message: json['message'] as String? ?? '',
      hostel: HostelModel.fromJson(json['hostel'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {'message': message, 'hostel': hostel.toJson()};
  }
}

class HostelResponse {
  final String message;
  final List<HostelModel> hostels;

  HostelResponse({required this.message, required this.hostels});

  factory HostelResponse.fromJson(Map<String, dynamic> json) {
    return HostelResponse(
      message: json['message'] as String,
      hostels: (json['hostels'] as List)
          .map((h) => HostelModel.fromJson(h))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'hostels': hostels.map((h) => h.toJson()).toList(),
    };
  }
}

class HostelModel {
  final String hostelId;
  final String hostelName;
  final Duration checkOutStartTime; // since midnight
  final Duration latestReturnTime; // since midnight
  final bool outingAllowed;

  HostelModel({
    required this.hostelId,
    required this.hostelName,
    required this.checkOutStartTime,
    required this.latestReturnTime,
    required this.outingAllowed,
  });

  factory HostelModel.fromJson(Map<String, dynamic> json) {
    return HostelModel(
      hostelId: json['hostel_id'] as String,
      hostelName: json['name'] as String,
      checkOutStartTime: TimeUtils.parse(json['check_out_start_time']),
      latestReturnTime: TimeUtils.parse(json['latest_return_time']),
      outingAllowed: json['outing_allowed'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hostel_id': hostelId,
      'name': hostelName,
      'check_out_start_time': TimeUtils.format(checkOutStartTime),
      'latest_return_time': TimeUtils.format(latestReturnTime),
      'outing_allowed': outingAllowed,
    };
  }

  /// Convert this HostelModel into a RestrictionWindow.
  /// - Interprets checkOutStartTime/latestReturnTime as minutes since midnight.
  /// - Builds a user note; when not allowed, shows the reason text instead.
  /// - Timezone defaults to Asia/Kolkata but can be overridden.
  RestrictionWindow toRestrictionWindow({
    String timezone = 'Asia/Kolkata',
    String? notAllowedReason,
  }) {
    final min = _durationToTimeOfDay(checkOutStartTime);
    final max = _durationToTimeOfDay(latestReturnTime);

    final note = outingAllowed
        ? "Allowed time: ${_format12h(min)} – ${_format12h(max)}"
        : (notAllowedReason ?? "Outing not allowed today.");

    return RestrictionWindow(
      allowedToday: outingAllowed,
      minTime: min,
      maxTime: max,
      timezone: timezone,
      note: note,
    );
  }

  /// Safely converts a Duration since midnight to TimeOfDay.
  /// Handles values beyond 24h by wrapping within a 24h range.
  TimeOfDay _durationToTimeOfDay(Duration d) {
    // Normalize to [0, 1440) minutes since midnight
    final total = d
        .inMinutes; // total minutes (can be > 1440 or negative) [web:175][web:180]
    final mod = ((total % 1440) + 1440) % 1440; // safe modulo for negatives
    final h = mod ~/ 60; // integer hours [web:173]
    final m = mod % 60; // remainder minutes [web:173]
    return TimeOfDay(
      hour: h,
      minute: m,
    ); // TimeOfDay expects 0–23 hours [web:107]
  }

  /// 12-hour formatter without BuildContext (for notes).
  String _format12h(TimeOfDay t) {
    final h = t.hourOfPeriod == 0
        ? 12
        : t.hourOfPeriod; // 12 for 0 and 12 [web:112]
    final m = t.minute.toString().padLeft(2, '0');
    final period = t.period == DayPeriod.am ? 'AM' : 'PM';
    return "$h:$m $period";
  }
}
