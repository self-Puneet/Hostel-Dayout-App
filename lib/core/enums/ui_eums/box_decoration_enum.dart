import 'package:flutter/material.dart';
import 'package:hostel_mgmt/core/theme/box_decoration.dart';

enum AppBoxDecoration { normal, alert, success, warning }

extension AppBoxDecorationExtension on AppBoxDecoration {
  BoxDecoration get decoration {
    switch (this) {
      case AppBoxDecoration.normal:
        return AppDecorations.base;

      case AppBoxDecoration.alert:
        return AppDecorations.base.copyWith(
          color: Colors.red.shade50,
          border: Border.all(color: Colors.transparent, width: 0),
          boxShadow: [],
        );

      case AppBoxDecoration.success:
        return AppDecorations.base.copyWith(
          color: Colors.green.shade50,
          border: Border.all(color: Colors.transparent, width: 0),
          boxShadow: [],
        );

      case AppBoxDecoration.warning:
        return AppDecorations.base.copyWith(
          color: Colors.yellow.shade50,
          border: Border.all(color: Colors.transparent, width: 0),
          boxShadow: [],
        );
    }
  }
}
