enum TimelineActor {
  student,
  parent,
  warden,
  security,
  server
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
      case TimelineActor.server:
        return 'Server';
    }
  }
}

