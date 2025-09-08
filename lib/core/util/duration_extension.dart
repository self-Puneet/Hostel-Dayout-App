extension DurationFormat on Duration {
  /// Format a Duration as time (hh:mm) → "h:mm AM/PM"
  String toAmPmString() {
    final totalMinutes = inMinutes;
    final hours = (totalMinutes ~/ 60) % 24;
    final minutes = totalMinutes % 60;

    final period = hours >= 12 ? "PM" : "AM";
    final hour12 = hours % 12 == 0 ? 12 : hours % 12;

    if (minutes == 0) {
      return "$hour12 $period"; // e.g. "10 AM", "1 PM"
    } else {
      final minuteStr = minutes.toString().padLeft(2, '0');
      return "$hour12:$minuteStr $period"; // e.g. "10:30 AM"
    }
  }
}
