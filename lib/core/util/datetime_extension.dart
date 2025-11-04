extension DateTimeIST on DateTime {
  /// Converts this DateTime to Indian Standard Time (UTC+5:30)
  DateTime get toIST {
    if (isUtc) {
      // If time is in UTC, add +5:30
      return add(const Duration(hours: 5, minutes: 30));
    } else {
      // If local already, return as-is (or convert to local system time)
      return toLocal();
    }
  }
}
