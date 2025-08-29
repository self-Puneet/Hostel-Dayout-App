class TimeUtils {
  /// Parse "HH:mm" into a Duration since midnight
  static Duration parse(String timeString) {
    final parts = timeString.split(':');
    final hours = int.parse(parts[0]);
    final minutes = int.parse(parts[1]);
    return Duration(hours: hours, minutes: minutes);
  }

  /// Format Duration back to "HH:mm"
  static String format(Duration time) {
    final hours = time.inHours;
    final minutes = time.inMinutes % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
  }

  /// Compare two times (Durations since midnight)
  static bool isBefore(Duration a, Duration b) => a < b;
  static bool isAfter(Duration a, Duration b) => a > b;
  static bool isSame(Duration a, Duration b) => a == b;

  /// Check if a time is within a range (inclusive)
  static bool isWithinRange(Duration time, Duration start, Duration end) {
    return time >= start && time <= end;
  }

  /// Get current time of day as Duration
  static Duration now() {
    final now = DateTime.now();
    return Duration(hours: now.hour, minutes: now.minute);
  }
}
