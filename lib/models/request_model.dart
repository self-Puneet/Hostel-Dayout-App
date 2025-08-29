import 'package:hostel_mgmt/core/enums/request_status.dart';
import 'package:hostel_mgmt/core/enums/request_type.dart';

class RequestModel {
  final String id;
  final String requestId;
  final RequestType requestType;
  final String studentEnrollmentNumber;
  final DateTime appliedFrom;
  final DateTime appliedTo;
  final String reason;
  final RequestStatus status;
  final bool active;
  final String createdBy;
  final DateTime appliedAt;
  final DateTime lastUpdatedAt;

  RequestModel({
    required this.id,
    required this.requestId,
    required this.requestType,
    required this.studentEnrollmentNumber,
    required this.appliedFrom,
    required this.appliedTo,
    required this.reason,
    required this.status,
    required this.active,
    required this.createdBy,
    required this.appliedAt,
    required this.lastUpdatedAt,
  });

  /// Map API string → Enum
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

  /// Map Enum → API string
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
      id: json['_id'] ?? '',
      requestId: json['request_id'] ?? '',
      requestType: json['request_type'] == 'leave'
          ? RequestType.leave
          : RequestType.dayout, // API uses "outing", treat as dayout
      studentEnrollmentNumber: json['student_enrollment_number'] ?? '',
      appliedFrom: DateTime.parse(json['applied_from']),
      appliedTo: DateTime.parse(json['applied_to']),
      reason: json['reason'] ?? '',
      status: _statusFromString(json['request_status']),
      active: json['active'] ?? false,
      createdBy: json['created_by'] ?? '',
      appliedAt: DateTime.parse(json['applied_at']),
      lastUpdatedAt: DateTime.parse(json['last_updated_at']),
    );
  }

  /// Serialize to JSON
  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "request_id": requestId,
      "request_type": requestType == RequestType.leave ? 'leave' : 'outing',
      "student_enrollment_number": studentEnrollmentNumber,
      "applied_from": appliedFrom.toIso8601String(),
      "applied_to": appliedTo.toIso8601String(),
      "reason": reason,
      "request_status": _statusToString(status),
      "active": active,
      "created_by": createdBy,
      "applied_at": appliedAt.toIso8601String(),
      "last_updated_at": lastUpdatedAt.toIso8601String(),
    };
  }
}

class RequestApiResponse {
  final String message;
  final List<RequestModel> requests;

  RequestApiResponse({required this.message, required this.requests});

  factory RequestApiResponse.fromJson(Map<String, dynamic> json) {
    return RequestApiResponse(
      message: json['message'] ?? '',
      requests: (json['requests'] as List<dynamic>)
          .map((e) => RequestModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "message": message,
      "requests": requests.map((e) => e.toJson()).toList(),
    };
  }
}
