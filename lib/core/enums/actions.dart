import 'package:flutter/material.dart';
import 'package:hostel_mgmt/core/enums/enum.dart';
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
        return Icon(Icons.phone_in_talk_outlined, color: Colors.white);
      case RequestAction.cancel:
        return Icon(Icons.cancel_outlined, color: Colors.white);
      case RequestAction.approve:
        return Icon(Icons.check, color: Colors.white);
      case RequestAction.reject:
        return Icon(Icons.cancel_outlined);
      case RequestAction.none:
        return Icon(Icons.help_outline, color: Colors.white);
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
              'Your Current request will be cancelled. \n Are you sure you wanna continue ?',
          confirmText: 'Cancel Request',
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

  RequestStatus statusAfterAction(TimelineActor actor) {
    switch (this) {
      case RequestAction.refer:
        return RequestStatus.referred;
      case RequestAction.cancel:
        switch (actor) {
          case TimelineActor.student:
            return RequestStatus.cancelledStudent;
          case TimelineActor.assistentWarden:
            return RequestStatus.cancelled;
          default:
            return RequestStatus.cancelled;
        }
      case RequestAction.approve:
        switch (actor) {
          case TimelineActor.parent:
            return RequestStatus.parentApproved;
          case TimelineActor.seniorWarden:
            return RequestStatus.approved;
          default:
            return RequestStatus.approved;
        }
      case RequestAction.reject:
        return RequestStatus.rejected;
      case RequestAction.none:
        return RequestStatus.requested;
    }
  }

  static List<RequestAction> actionPossibleonStatus(
    RequestStatus status,
    TimelineActor actor,
  ) {
    switch (status) {
      case RequestStatus.requested:
        switch (actor) {
          case TimelineActor.student:
            return [RequestAction.cancel];
          case TimelineActor.assistentWarden:
            return [RequestAction.refer, RequestAction.cancel];
          default:
            return [];
        }
      case RequestStatus.cancelled:
        switch (actor) {
          default:
            return [];
        }
      case RequestStatus.referred:
        switch (actor) {
          case TimelineActor.student:
            return [RequestAction.cancel];
          case TimelineActor.parent:
            return [RequestAction.approve, RequestAction.approve];
          default:
            return [];
        }
      case RequestStatus.rejected:
        switch (actor) {
          default:
            return [];
        }
      case RequestStatus.approved:
        switch (actor) {
          case TimelineActor.student:
            return [RequestAction.cancel];
          default:
            return [];
        }
      case RequestStatus.parentApproved:
        switch (actor) {
          case TimelineActor.student:
            return [RequestAction.cancel];
          case TimelineActor.seniorWarden:
            return [RequestAction.approve, RequestAction.reject];
          default:
            return [];
        }
      case RequestStatus.parentDenied:
        switch (actor) {
          default:
            return [];
        }
      case RequestStatus.cancelledStudent:
        switch (actor) {
          default:
            return [];
        }
    }
  }
}
