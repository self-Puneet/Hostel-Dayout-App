import 'package:hostel_mgmt/core/exception.dart';
import 'package:intl/intl.dart';

class InputConverter {
  static String dateFormater(DateTime datetime) {
    try {
      final formatter = DateFormat("MMM d | h:mm a"); // Aug 12, 11:00 AM
      final String dateString = formatter.format(datetime);
      return dateString;
    } on FormatException {
      throw InputFormatException("sdf");
    }
  }

  static String dateToDayMonth(DateTime datetime) {
    try {
      final formatter = DateFormat("dd/MM");
      final String dateString = formatter.format(datetime);
      return dateString;
    } on FormatException {
      throw InputFormatException("Invalid date format");
    }
  }
}
