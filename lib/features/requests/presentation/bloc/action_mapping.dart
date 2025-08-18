import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hostel_dayout_app/core/enums/actions.dart';
import 'package:hostel_dayout_app/core/enums/enum.dart';
import 'package:hostel_dayout_app/features/requests/domain/entities/request.dart';
import 'package:hostel_dayout_app/features/requests/presentation/bloc/runtime_storage.dart';
import 'package:hostel_dayout_app/injection.dart';

class ActionParams {
  final Icon icon;
  final String label;
  final Color backgroundColor;
  final VoidCallback onPressed;

  ActionParams({
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.onPressed,
  });
}

class ActionMapping {
  static final Map<RequestStatus, Set<RequestAction>> statusToAction = {
    RequestStatus.requested: {RequestAction.refer, RequestAction.cancel},
    RequestStatus.referred: {RequestAction.none},
    RequestStatus.cancelled: {RequestAction.none},
    RequestStatus.parentApproved: {RequestAction.approve, RequestAction.reject},
    RequestStatus.parentDenied: {RequestAction.none},
    RequestStatus.rejected: {RequestAction.none},
    RequestStatus.approved: {RequestAction.none},
    RequestStatus.inactive: {RequestAction.none},
  };

  static final Map<RequestAction, RequestStatus> actionToResultingStatus = {
    RequestAction.refer: RequestStatus.referred,
    RequestAction.cancel: RequestStatus.cancelled,
    RequestAction.approve: RequestStatus.approved,
    RequestAction.reject: RequestStatus.rejected,
  };

  static List<RequestAction> getActionForRequest(RequestStatus status) {
    return statusToAction[status]!.toList();
  }

  static List<RequestAction> possibleActions(List<Request> requests) {
    final Set<RequestAction> actions = {};
    for (var request in requests) {
      actions.addAll(statusToAction[request.status] ?? {});
    }
    return actions.toList();
  }

  static List<RequestAction> possibleActionsForRequest(Request request) {
    return statusToAction[request.status]?.toList() ?? [];
  }

  static List<RequestAction> getPossibleActionsForOnScreenRequests() {
    final List<Request> onScreenRequests = sl<RequestStorage>()
        .getOnScreenRequests();
    return possibleActions(onScreenRequests);
  }

  static Map<String, RequestStatus> getStatusMappingForAction(
    RequestAction action,
  ) {
    final Map<String, RequestStatus> mapping = {};
    final requestIds = getRequestIdsForAction(action);
    for (var id in requestIds) {
      mapping[id] = getResultingStatusForAction(action);
    }
    return mapping;
  }

  static RequestStatus getStatusForAction(RequestAction action) {
    for (var entry in statusToAction.entries) {
      if (entry.value.contains(action)) {
        return entry.key;
      }
    }
    throw ArgumentError('No RequestStatus found for action: $action');
  }

  static List<String> getRequestIdsForAction(RequestAction action) {
    final List<String> requestIds = [];
    final List<Request> onScreenRequests = sl<RequestStorage>()
        .getOnScreenRequests();

    for (var request in onScreenRequests) {
      final possibleActions = possibleActionsForRequest(request);
      if (possibleActions.contains(action)) {
        requestIds.add(request.id);
      }
    }
    return requestIds;
  }

  // get resulting status for action
  static RequestStatus getResultingStatusForAction(RequestAction action) {
    return actionToResultingStatus[action] ?? RequestStatus.inactive;
  }
}
