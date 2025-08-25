import 'package:flutter/material.dart';

enum AppSnackBarType { error, success, info, alert }

extension AppSnackBarTypeExtension on AppSnackBarType {
  Color get bgColor {
    switch (this) {
      case AppSnackBarType.error:
        return Colors.red;
      case AppSnackBarType.success:
        return Colors.green;
      case AppSnackBarType.info:
        return Colors.blue;
      case AppSnackBarType.alert:
        return Colors.orange;
    }
    }
}
