import 'package:hive/hive.dart';
import 'package:hostel_dayout_app/core/enums/request_state.dart';
import 'package:hostel_dayout_app/core/enums/request_status.dart';
import 'package:hostel_dayout_app/core/enums/request_type.dart';
import 'package:hostel_dayout_app/requests/data/models/timeline_event_model.dart';
import '../../domain/entities/request.dart';
import 'student_info_model.dart';
import 'parent_info_model.dart';

part 'request_model.g.dart';

@HiveType(typeId: 6)
class RequestModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final RequestType type;

  @HiveField(2)
  final RequestStatus status;

  @HiveField(3)
  final StudentInfoModel student;

  @HiveField(4)
  final ParentInfoModel parent;

  @HiveField(5)
  final DateTime outTime;

  @HiveField(6)
  final DateTime returnTime;

  @HiveField(7)
  final String reason;

  @HiveField(8)
  final DateTime requestedAt;

  @HiveField(9)
  final List<TimelineEventModel> timeline;

  @HiveField(10)
  final RequestState requestState;

  RequestModel({
    required this.id,
    required this.type,
    required this.status,
    required this.student,
    required this.parent,
    required this.outTime,
    required this.returnTime,
    required this.reason,
    required this.requestedAt,
    required this.timeline,
    required this.requestState,
  });

  String encrypt(String value) => value;
  String decrypt(String value) => value;

  factory RequestModel.fromJson(Map<String, dynamic> json) {
    return RequestModel(
      id: json['id'],
      type: RequestType.values[json['type']],
      status: RequestStatus.values[json['status']],
      student: StudentInfoModel.fromJson(json['student']),
      parent: ParentInfoModel.fromJson(json['parent']),
      outTime: DateTime.parse(json['outTime']),
      returnTime: DateTime.parse(json['returnTime']),
      reason: json['reason'],
      requestedAt: DateTime.parse(json['requestedAt']),
      timeline: (json['timeline'] as List)
          .map((e) => TimelineEventModel.fromJson(e))
          .toList(),
      requestState: RequestState.values[json['requestState']],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.index,
    'status': status.index,
    'student': student.toJson(),
    'parent': parent.toJson(),
    'outTime': outTime.toIso8601String(),
    'returnTime': returnTime.toIso8601String(),
    'reason': reason,
    'requestedAt': requestedAt.toIso8601String(),
    'timeline': timeline.map((e) => e.toJson()).toList(),
    'requestState': requestState.index,
  };

  factory RequestModel.fromEntity(Request entity) {
    return RequestModel(
      id: entity.id,
      type: entity.type,
      status: entity.status,
      student: StudentInfoModel.fromEntity(entity.student),
      parent: ParentInfoModel.fromEntity(entity.parent),
      outTime: entity.outTime,
      returnTime: entity.returnTime,
      reason: entity.reason,
      requestedAt: entity.requestedAt,
      timeline: entity.timeline
          .map((e) => TimelineEventModel.fromEntity(e))
          .toList(),
      requestState: entity.requestState,
    );
  }

  Request toEntity() {
    return Request(
      id: id,
      type: type,
      status: status,
      student: student.toEntity(),
      parent: parent.toEntity(),
      outTime: outTime,
      returnTime: returnTime,
      reason: reason,
      requestedAt: requestedAt,
      timeline: timeline.map((e) => e.toEntity()).toList(),
      requestState: requestState,
    );
  }
}
