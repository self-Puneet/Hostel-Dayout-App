// make a enum for all possible actions
import 'package:flutter/material.dart';

enum RequestAction { refer, cancel, approve, reject, none }

extension RequestActionX on RequestAction {
  String get name {
    switch (this) {
      case RequestAction.refer:
        return 'Refer to Parents';
      case RequestAction.cancel:
        return 'Cancel';
      case RequestAction.approve:
        return 'Approve';
      case RequestAction.reject:
        return 'Reject';
      case RequestAction.none:
        return 'None';
    }
  }

  Icon get icon {
    switch (this) {
      case RequestAction.refer:
        return Icon(Icons.phone_in_talk_outlined);
      case RequestAction.cancel:
        return Icon(Icons.cancel_outlined);
      case RequestAction.approve:
        return Icon(Icons.check);
      case RequestAction.reject:
        return Icon(Icons.cancel_outlined);
      case RequestAction.none:
        return Icon(Icons.help_outline);
    }
  }

  Color get actionColor {
    switch (this) {
      case RequestAction.refer:
        return Colors.orange;
      case RequestAction.cancel:
        return Colors.grey;
      case RequestAction.approve:
        return Colors.green.shade700;
      case RequestAction.reject:
        return Colors.red;
      case RequestAction.none:
        return Colors.grey;
    }
  }
}
