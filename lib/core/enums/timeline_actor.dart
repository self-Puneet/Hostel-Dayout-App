// lib/core/enums/timeline_actor.dart
import 'package:hive/hive.dart';

part 'timeline_actor.g.dart';

@HiveType(typeId: 2)
enum TimelineActor {
  @HiveField(0)
  student,

  @HiveField(1)
  parent,

  @HiveField(2)
  warden,

  @HiveField(3)
  security,
}


extension TimelineActorX on TimelineActor {
  String get displayName {
    switch (this) {
      case TimelineActor.student:
        return 'Student';
      case TimelineActor.parent:
        return 'Parent';
      case TimelineActor.warden:
        return 'Warden';
      case TimelineActor.security:
        return 'Security';
    }
  }
}

