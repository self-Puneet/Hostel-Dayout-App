import 'package:flutter/material.dart';

enum RequestStatus {
  requested,
  referred,
  cancelled,
  parentApproved,
  parentDenied,
  rejected,
  approved,
  inactive,
}

extension RequestStatusX on RequestStatus {
  String get displayName {
    switch (this) {
      case RequestStatus.requested:
        return 'Requested';
      case RequestStatus.referred:
        return 'Referred';
      case RequestStatus.cancelled:
        return 'Cancelled';
      case RequestStatus.parentApproved:
        return 'Parent Approved';
      case RequestStatus.parentDenied:
        return 'Parent Denied';
      case RequestStatus.rejected:
        return 'Rejected';
      case RequestStatus.approved:
        return 'Approved';
      case RequestStatus.inactive:
        return 'Inactive';
    }
  }

  String get minimalDisplayName {
    switch (this) {
      case RequestStatus.requested:
        return 'Requested';
      case RequestStatus.referred:
        return 'In Progress';
      case RequestStatus.cancelled:
        return 'Rejected';
      case RequestStatus.parentApproved:
        return 'In Progress';
      case RequestStatus.parentDenied:
        return 'Rejected';
      case RequestStatus.rejected:
        return 'Rejected';
      case RequestStatus.approved:
        return 'Approved';
      case RequestStatus.inactive:
        return 'Inactive';
    }
  }

  Color get minimalStatusColor {
    switch (this) {
      case RequestStatus.requested:
        return Color.fromRGBO(0, 98, 255, 0.27);
      case RequestStatus.referred:
        return Color.fromRGBO(0, 98, 255, 0.27);
      case RequestStatus.cancelled:
        return Color.fromRGBO(255, 0, 4, 0.4);
      case RequestStatus.parentApproved:
        return Color.fromRGBO(0, 98, 255, 0.27);
      case RequestStatus.parentDenied:
        return Color.fromRGBO(255, 0, 4, 0.4);
      case RequestStatus.rejected:
        return Color.fromRGBO(255, 0, 4, 0.4);
      case RequestStatus.approved:
        return Color.fromRGBO(47, 255, 0, 0.4);
      case RequestStatus.inactive:
        return Color.fromRGBO(255, 0, 4, 0.4);
    }
  }

  Color get statusColor {
    switch (this) {
      case RequestStatus.requested:
        return Colors.blue;
      case RequestStatus.referred:
        return Colors.orange;
      case RequestStatus.cancelled:
        return Colors.grey;
      case RequestStatus.parentApproved:
        return Colors.green;
      case RequestStatus.parentDenied:
        return Colors.redAccent;
      case RequestStatus.rejected:
        return Colors.red;
      case RequestStatus.approved:
        return Colors.green.shade700;
      default:
        return Colors.grey;
    }
  }
}
