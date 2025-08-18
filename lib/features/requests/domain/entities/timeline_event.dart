import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:hostel_dayout_app/core/enums/timeline_actor.dart';

class TimelineEvent extends Equatable {
  final String type;
  final String description;
  final DateTime timestamp;
  final TimelineActor actor;
  final Icon icon;

  TimelineEvent({
    required this.type,
    required this.description,
    required this.timestamp,
    required this.actor,
    required this.icon,
  });

  @override
  List<Object?> get props => [type, description, timestamp, actor, icon];

  TimelineEvent copyWith({
    String? type,
    String? description,
    DateTime? timestamp,
    TimelineActor? actor,
    Icon? icon,
  }) {
    return TimelineEvent(
      type: type ?? this.type,
      description: description ?? this.description,
      timestamp: timestamp ?? this.timestamp,
      actor: actor ?? this.actor,
      icon: icon ?? this.icon,
    );
  }
}
