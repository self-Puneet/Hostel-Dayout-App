// lib/models/warden_statistics.dart
import 'dart:math';

class WardenStatistics {
  final int count;       // This month
  final int outCount;    // Students out (total)
  final int lateCount;   // Late students (total)
  final int actionCount; // Active requests

  // Temporary fabricated breakdowns
  final int outLeaveCount;
  final int outOutingCount;
  final int lateLeaveCount;
  final int lateOutingCount;

  WardenStatistics({
    required this.count,
    required this.outCount,
    required this.lateCount,
    required this.actionCount,
    required this.outLeaveCount,
    required this.outOutingCount,
    required this.lateLeaveCount,
    required this.lateOutingCount,
  });

  factory WardenStatistics.fromJson(Map<String, dynamic> json) {
    final count = (json['count'] ?? 0) as int;
    final out = (json['outCount'] ?? 0) as int;
    final late = (json['lateCount'] ?? 0) as int;
    final action = (json['actionCount'] ?? 0) as int;

    int split60(int total) => (total * 0.6).round();
    int split40(int total) => (total * 0.4).round();

    final outLeave = split60(out);
    final outOuting = max(0, out - outLeave);
    final lateLeave = split40(late);
    final lateOuting = max(0, late - lateLeave);

    return WardenStatistics(
      count: count,
      outCount: out,
      lateCount: late,
      actionCount: action,
      outLeaveCount: outLeave,
      outOutingCount: outOuting,
      lateLeaveCount: lateLeave,
      lateOutingCount: lateOuting,
    );
  }
}
