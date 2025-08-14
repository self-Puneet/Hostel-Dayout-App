import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hostel_dayout_app/core/enums/enum.dart';
import 'package:hostel_dayout_app/requests/domain/entities/timeline_event.dart';
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
  final List<TimelineEvent> timeline;

  @HiveField(10)
  final bool? priority;

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
    this.priority = false,
  });

  String encrypt(String value) => value;
  String decrypt(String value) => value;

  static TimelineEvent getMappedTimelineEvent(String type, DateTime timestamp) {
    switch (type) {
      case 'requested':
        return TimelineEvent(
          type: type,
          description: 'Request Created',
          actor: TimelineActor.student,
          timestamp: timestamp,
          icon: Icon(Icons.radio_button_checked),
        );
      case 'referred':
        return TimelineEvent(
          type: type,
          description: 'Referred to Parents',
          actor: TimelineActor.warden,
          timestamp: timestamp,
          icon: Icon(Icons.phone_in_talk_outlined),
        );
      case 'parent_approved':
        return TimelineEvent(
          type: type,
          description: 'Parent Approved Request',
          actor: TimelineActor.parent,
          timestamp: timestamp,
          icon: Icon(Icons.verified_outlined),
        );
      case 'parent_denied':
        return TimelineEvent(
          type: type,
          description: 'Request Denied',
          actor: TimelineActor.parent,
          timestamp: timestamp,
          icon: Icon(Icons.cancel_outlined),
        );
      case 'cancelled':
        return TimelineEvent(
          type: type,
          description: 'Request Cancelled',
          actor: TimelineActor.warden,
          timestamp: timestamp,
          icon: Icon(Icons.cancel_outlined),
        );
      case 'rejected':
        return TimelineEvent(
          type: type,
          description: 'Request Rejected',
          actor: TimelineActor.warden,
          timestamp: timestamp,
          icon: Icon(Icons.cancel_outlined),
        );
      case 'accepted':
        return TimelineEvent(
          type: type,
          description: 'Request Accepted',
          actor: TimelineActor.warden,
          timestamp: timestamp,
          icon: Icon(Icons.check),
        );
      case 'closed':
        return TimelineEvent(
          type: type,
          description: 'Request Closed',
          actor: TimelineActor.server,
          timestamp: timestamp,
          icon: Icon(Icons.remove_circle_outline),
        );
      default:
        throw ArgumentError('Invalid type: $type');
    }
  }

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
      // In fromJson
      timeline: (json['timeline'] as List).map((timelineEvent) {
        final type = timelineEvent['type'] as String;
        final time = DateTime.parse(timelineEvent['timestamp']);

        return getMappedTimelineEvent(type, time); // ✅ Return
      }).toList(),

      priority: json['priority'],
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
    'timeline': timeline
        .map(
          (e) => {'type': e.type, 'timestamp': e.timestamp.toIso8601String()},
        )
        .toList(),
    'priority': priority,
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
      timeline: entity.timeline,
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
      timeline: timeline,
    );
  }
}
