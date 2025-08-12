import 'package:dartz/dartz.dart';
import 'package:hostel_dayout_app/core/failures.dart';
import 'package:intl/intl.dart';

class InputConverter {
  Either<Failure, String> dateFormater(DateTime datetime) {
    try {
      final formatter = DateFormat("MMM d, h:mm a"); // Aug 12, 11:00 AM
      final String dateString = formatter.format(datetime);
      return Right(dateString);
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {}
