import 'package:equatable/equatable.dart';
import 'package:hostel_dayout_app/core/enums/request_status.dart';
import 'package:hostel_dayout_app/core/enums/request_type.dart';

import 'student_info.dart';
import 'parent_info.dart';
import 'timeline_event.dart';

class Request extends Equatable {
  final String id;
  final RequestType type;
  final RequestStatus status;
  final StudentInfo student;
  final ParentInfo parent;
  final DateTime outTime;
  final DateTime returnTime;
  final String reason;
  final DateTime requestedAt;
  final List<TimelineEvent> timeline;

  Request({
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
  });

  @override
  List<Object?> get props => [
    id,
    type,
    status,
    student,
    parent,
    outTime,
    returnTime,
    reason,
    requestedAt,
    timeline,
  ];
}
