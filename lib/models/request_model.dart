import 'package:hostel_mgmt/core/enums/request_status.dart';
import 'package:hostel_mgmt/core/enums/request_type.dart';

class RequestModel {
  final RequestType requestType;
  final DateTime appliedFrom;
  final DateTime appliedTo;
  final String reason;
  final RequestStatus status;

  RequestModel({
    required this.requestType,
    required this.appliedFrom,
    required this.appliedTo,
    required this.reason,
    required this.status,
  });

  /// Map API string status → Enum
  static RequestStatus _statusFromString(String status) {
    switch (status) {
      case "requested":
        return RequestStatus.requested;
      case "referred_to_parent":
        return RequestStatus.referred;
      case "cancelled_assitent_warden":
        return RequestStatus.cancelled;
      case "accepted_by_parent":
        return RequestStatus.parentApproved;
      case "rejected_by_parent":
        return RequestStatus.parentDenied;
      case "accepted_by_warden":
        return RequestStatus.approved;
      case "rejected_by_warden":
        return RequestStatus.rejected;
      default:
        return RequestStatus.inactive;
    }
  }

  /// Map Enum → API string status
  static String _statusToString(RequestStatus status) {
    switch (status) {
      case RequestStatus.requested:
        return "requested";
      case RequestStatus.referred:
        return "referred_to_parent";
      case RequestStatus.cancelled:
        return "cancelled_assitent_warden";
      case RequestStatus.parentApproved:
        return "accepted_by_parent";
      case RequestStatus.parentDenied:
        return "rejected_by_parent";
      case RequestStatus.approved:
        return "accepted_by_warden";
      case RequestStatus.rejected:
        return "rejected_by_warden";
      case RequestStatus.inactive:
        return "inactive";
    }
  }

  /// Deserialize from JSON
  factory RequestModel.fromJson(Map<String, dynamic> json) {
    return RequestModel(
      requestType: json['request_type'] == 'leave'
          ? RequestType.leave
          : RequestType.dayout,
      appliedFrom: DateTime.parse(json['applied_from']),
      appliedTo: DateTime.parse(json['applied_to']),
      reason: json['reason'] ?? '',
      status: _statusFromString(json['request_status']),
    );
  }

  /// Serialize to JSON
  Map<String, dynamic> toJson() {
    return {
      "request_type": requestType == RequestType.leave ? 'leave' : 'dayout',
      "applied_from": appliedFrom.toIso8601String(),
      "applied_to": appliedTo.toIso8601String(),
      "reason": reason,
      "request_status": _statusToString(status),
    };
  }
}
