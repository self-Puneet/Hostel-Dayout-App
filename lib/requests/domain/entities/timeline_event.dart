import 'package:equatable/equatable.dart';
import 'package:hostel_dayout_app/core/enums/timeline_actor.dart';

class TimelineEvent extends Equatable {
  final String description;
  final DateTime timestamp;
  final TimelineActor actor;

  TimelineEvent({
    required this.description,
    required this.timestamp,
    required this.actor,
  });

  @override
  List<Object?> get props => [description, timestamp, actor];
}
