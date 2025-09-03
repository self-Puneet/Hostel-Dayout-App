import 'package:hostel_mgmt/core/enums/actions.dart';
import 'package:hostel_mgmt/core/enums/request_status.dart';
import 'package:hostel_mgmt/core/enums/request_type.dart';
import 'package:hostel_mgmt/core/enums/security_status.dart';
import 'package:hostel_mgmt/models/assistant_w_model.dart';
import 'package:hostel_mgmt/models/parent_model.dart';
import 'package:hostel_mgmt/models/security_guard_model.dart';
import 'package:hostel_mgmt/models/student_profile.dart';

class ParentAction {
  final ParentModel parentModel;
  final DateTime actionAt;
  final RequestAction action;
  const ParentAction({
    required this.parentModel,
    required this.action,
    required this.actionAt,
  });
}

class StudentAction {
  final DateTime actionAt;
  final RequestAction action;
  final StudentProfileModel studentProfileModel;

  const StudentAction({
    required this.action,
    required this.actionAt,
    required this.studentProfileModel,
  });
}

class SecurityGuardAction {
  final SecurityGuardModel securityGuardModel;
  final DateTime actionAt;
  final RequestAction action;

  const SecurityGuardAction({
    required this.securityGuardModel,
    required this.action,
    required this.actionAt,
  });
}

class AssistantWardenAction {
  final WardenModel assistantWardenModel;
  final DateTime actionAt;
  final RequestAction action;

  const AssistantWardenAction({
    required this.assistantWardenModel,
    required this.action,
    required this.actionAt,
  });
}

class SeniorWardenAction {
  final StudentProfileModel seniorWardenModel;
  final DateTime actionAt;
  final RequestAction action;

  const SeniorWardenAction({
    required this.seniorWardenModel,
    required this.action,
    required this.actionAt,
  });
}

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
  final SecurityStatus? securityStatus;
  final String? parentRemark;
  final StudentAction? studentAction;
  final ParentAction? parentAction;
  final AssistantWardenAction? assistantWardenAction;
  final SeniorWardenAction? seniorWardenAction;
  final SecurityGuardAction? securityGuardAction;

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
    this.securityStatus,
    this.parentRemark,
    this.studentAction,
    this.parentAction,
    this.assistantWardenAction,
    this.seniorWardenAction,
    this.securityGuardAction,
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
      case "cancelled_by_student":
        return RequestStatus.cancelledStudent;
      default:
        return RequestStatus.requested;
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
      case RequestStatus.cancelledStudent:
        return "cancelled_by_student";
    }
  }

  /// Deserialize from JSON
  factory RequestModel.fromJson(Map<String, dynamic> json) {
    return RequestModel(
      id: json['_id'] ?? '',
      requestId: json['request_id'] ?? '',
      requestType: json['request_type'] == 'leave'
          ? RequestType.leave
          : RequestType.dayout,
      studentEnrollmentNumber: json['student_enrollment_number'] ?? '',
      appliedFrom: DateTime.parse(json['applied_from']),
      appliedTo: DateTime.parse(json['applied_to']),
      reason: json['reason'] ?? '',
      status: _statusFromString(json['request_status']),
      active: json['active'] ?? false,
      createdBy: json['created_by'] ?? '',
      appliedAt: DateTime.parse(json['applied_at']),
      lastUpdatedAt: DateTime.parse(json['last_updated_at']),
      securityStatus: json['security_status'] != null
          ? SecurityStatus.values.firstWhere(
              (e) => e.toString().split('.').last == json['security_status'],
              orElse: () => SecurityStatus.pending,
            )
          : null,
      parentRemark: json['parent_remark'],
      studentAction: json['student_action'] != null
          ? StudentAction(
              studentProfileModel: StudentProfileModel.fromJson(
                json['student_action']['action_by'],
              ),
              action: RequestAction.values.firstWhere(
                (e) =>
                    e.toString().split('.').last ==
                    json['student_action']['action'],
              ),
              actionAt: DateTime.parse(json['student_action']['action_at']),
            )
          : null,
      parentAction: json['parent_action'] != null
          ? ParentAction(
              parentModel: ParentModel.fromJson(
                json['parent_action']['action_by'],
              ),
              action: RequestAction.values.firstWhere(
                (e) =>
                    e.toString().split('.').last ==
                    json['parent_action']['action'],
              ),
              actionAt: DateTime.parse(json['parent_action']['action_at']),
            )
          : null,
      assistantWardenAction: json['assistant_warden_action'] != null
          ? AssistantWardenAction(
              assistantWardenModel: WardenModel.fromJson(
                json['assistant_warden_action']['action_by'],
              ),
              action: RequestAction.values.firstWhere(
                (e) =>
                    e.toString().split('.').last ==
                    json['assistant_warden_action']['action'],
              ),
              actionAt: DateTime.parse(
                json['assistant_warden_action']['action_at'],
              ),
            )
          : null,
      seniorWardenAction: json['senior_warden_action'] != null
          ? SeniorWardenAction(
              seniorWardenModel: StudentProfileModel.fromJson(
                json['senior_warden_action']['action_by'],
              ),
              action: RequestAction.values.firstWhere(
                (e) =>
                    e.toString().split('.').last ==
                    json['senior_warden_action']['action'],
              ),
              actionAt: DateTime.parse(
                json['senior_warden_action']['action_at'],
              ),
            )
          : null,
      securityGuardAction: json['security_guard_action'] != null
          ? SecurityGuardAction(
              securityGuardModel: SecurityGuardModel.fromJson(
                json['security_guard_action']['action_by'],
              ),
              action: RequestAction.values.firstWhere(
                (e) =>
                    e.toString().split('.').last ==
                    json['security_guard_action']['action'],
              ),
              actionAt: DateTime.parse(
                json['security_guard_action']['action_at'],
              ),
            )
          : null,
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
      "security_status": securityStatus?.toString().split('.').last,
      "parent_remark": parentRemark,
      "student_action": studentAction != null
          ? {
              "action_by": studentAction!.studentProfileModel.toJson(),
              "action": studentAction!.action.toString().split('.').last,
              "action_at": studentAction!.actionAt.toIso8601String(),
            }
          : null,
      "parent_action": parentAction != null
          ? {
              "parent_model": parentAction!.parentModel.toJson(),
              "action": parentAction!.action.toString().split('.').last,
              "action_at": parentAction!.actionAt.toIso8601String(),
            }
          : null,
      "assistant_warden_action": assistantWardenAction != null
          ? {
              "assistant_warden_model": assistantWardenAction!
                  .assistantWardenModel
                  .toJson(),
              "action": assistantWardenAction!.action
                  .toString()
                  .split('.')
                  .last,
              "action_at": assistantWardenAction!.actionAt.toIso8601String(),
            }
          : null,
      "senior_warden_action": seniorWardenAction != null
          ? {
              "senior_warden_model": seniorWardenAction!.seniorWardenModel
                  .toJson(),
              "action": seniorWardenAction!.action.toString().split('.').last,
              "action_at": seniorWardenAction!.actionAt.toIso8601String(),
            }
          : null,
      "security_guard_action": securityGuardAction != null
          ? {
              "security_guard_model": securityGuardAction!.securityGuardModel
                  .toJson(),
              "action": securityGuardAction!.action.toString().split('.').last,
              "action_at": securityGuardAction!.actionAt.toIso8601String(),
            }
          : null,
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

// seniorWarden, assistantWarden, studentId

class RequestDetailApiResponse {
  final String message;
  final RequestModel request;
  final WardenModel assistentWarden;
  final WardenModel seniorWarden;
  final StudentProfileModel studentId;

  RequestDetailApiResponse({
    required this.message,
    required this.request,
    required this.assistentWarden,
    required this.seniorWarden,
    required this.studentId,
  });

  factory RequestDetailApiResponse.fromJson(Map<String, dynamic> json) {
    return RequestDetailApiResponse(
      message: json['message'] ?? '',
      request: RequestModel.fromJson(json['request'] ?? {}),
      assistentWarden: WardenModel.fromJson(json['assistantWarden']),
      seniorWarden: WardenModel.fromJson(json['seniorWarden']),
      studentId: StudentProfileModel.fromJson(
        json['studentId']['student'] ?? {},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "message": message,
      "request": request.toJson(),
      "assistantWarden": assistentWarden.toJson(),
      "seniorWarden": seniorWarden.toJson(),
      "student_id": studentId.toJson(),
    };
  }
}
