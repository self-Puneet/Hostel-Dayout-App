import 'package:hive/hive.dart';
import 'package:hostel_dayout_app/core/enums/timeline_actor.dart';
import '../../domain/entities/timeline_event.dart';

part 'timeline_event_model.g.dart';

@HiveType(typeId: 3)
class TimelineEventModel extends HiveObject {
  @HiveField(0)
  final String description;

  @HiveField(1)
  final DateTime timestamp;

  @HiveField(2)
  final TimelineActor actor;

  TimelineEventModel({
    required this.description,
    required this.timestamp,
    required this.actor,
  });

  // Encryption example (placeholder)
  String encrypt(String value) => value; // implement real encryption
  String decrypt(String value) => value; // implement real decryption

  factory TimelineEventModel.fromJson(Map<String, dynamic> json) {
    return TimelineEventModel(
      description: json['description'],
      timestamp: DateTime.parse(json['timestamp']),
      actor: TimelineActor.values[json['actor']],
    );
  }

  Map<String, dynamic> toJson() => {
    'description': description,
    'timestamp': timestamp.toIso8601String(),
    'actor': actor.index,
  };

  factory TimelineEventModel.fromEntity(TimelineEvent entity) {
    return TimelineEventModel(
      description: entity.description,
      timestamp: entity.timestamp,
      actor: entity.actor,
    );
  }

  TimelineEvent toEntity() {
    return TimelineEvent(
      description: description,
      timestamp: timestamp,
      actor: actor,
    );
  }
}
