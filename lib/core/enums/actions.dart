import 'package:flutter/material.dart';
import 'package:hostel_mgmt/core/enums/timeline_actor.dart';

class RequestActionDialogParam {
  final String title;
  final String description;
  final String confirmText;

  RequestActionDialogParam({
    required this.title,
    required this.description,
    required this.confirmText,
  });
}

enum RequestAction { refer, cancel, approve, reject, none }

extension RequestActionX on RequestAction {
  static List<RequestAction> actorActions(TimelineActor actor) {
    switch (actor) {
      case TimelineActor.student:
        return [RequestAction.cancel];
      case TimelineActor.parent:
        return [RequestAction.approve, RequestAction.reject];
      case TimelineActor.assistentWarden:
        return [RequestAction.cancel, RequestAction.refer];
      case TimelineActor.security:
        return [RequestAction.approve, RequestAction.reject];
      case TimelineActor.seniorWarden:
        return [RequestAction.approve, RequestAction.reject];
    }
  }

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

  RequestActionDialogParam get dialogBoxMessage {
    switch (this) {
      case RequestAction.refer:
        return RequestActionDialogParam(
          title: 'Refer All Requests',
          description:
              'All requests will be referred to their respective parents for further processing.',
          confirmText: 'Refer',
        );
      case RequestAction.cancel:
        return RequestActionDialogParam(
          title: 'Cancel All Requests',
          description:
              'All requests will be cancelled and will not be referred to their respective parents.',
          confirmText: 'Cancel',
        );
      case RequestAction.approve:
        return RequestActionDialogParam(
          title: 'Approve All Requests',
          description: 'All requests will be approved and marked as completed.',
          confirmText: 'Approve',
        );
      case RequestAction.reject:
        return RequestActionDialogParam(
          title: 'Reject All Requests',
          description:
              'All requests will be rejected and closed without approval.',
          confirmText: 'Reject',
        );
      case RequestAction.none:
        return RequestActionDialogParam(
          title: 'No Action Available',
          description:
              'There are no available actions for the selected requests.',
          confirmText: 'OK',
        );
    }
  }
}
