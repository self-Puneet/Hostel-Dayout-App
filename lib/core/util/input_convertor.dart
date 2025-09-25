import 'package:hostel_mgmt/core/exception.dart';
import 'package:intl/intl.dart';

class InputConverter {
  /// Takes a DateTime and returns formatted string like "Aug 12 | 11:00 AM"
  static String dateFormater(DateTime datetime) {
    try {
      final formatter = DateFormat("MMM d | h:mm a"); // Aug 12, 11:00 AM
      final String dateString = formatter.format(datetime);
      return dateString;
    } on FormatException {
      throw InputFormatException("sdf");
    }
  }

  /// Takes a DateTime and returns formatted string like "12/08"
  static String dateToDayMonth(DateTime datetime) {
    try {
      final formatter = DateFormat("dd/MM");
      final String dateString = formatter.format(datetime);
      return dateString;
    } on FormatException {
      throw InputFormatException("Invalid date format");
    }
  }

  /// Takes a DateTime and returns formatted string like "Aug 12, 2025"
  static String formatDate(DateTime date) {
    return DateFormat("MMM d, y").format(date);
  }

  /// Takes a DateTime and returns formatted string like "Aug 12"
  static String dateToMonthDay(DateTime datetime) {
    try {
      final formatter = DateFormat("d MMM");
      final String dateString = formatter.format(datetime);
      return dateString;
    } on FormatException {
      throw InputFormatException("Invalid date format");
    }
  }

  /// Takes a DateTime and returns formatted string like "10:25 AM"
  static String formatTime(DateTime date) {
    return DateFormat("h:mm a").format(date);
  }
}
