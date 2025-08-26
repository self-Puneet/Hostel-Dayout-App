enum TimelineActor { student, parent, warden, security, server, seniorWarden }

extension TimelineActorX on TimelineActor {
  String get displayName {
    switch (this) {
      case TimelineActor.student:
        return 'Student';
      case TimelineActor.parent:
        return 'Parent';
      case TimelineActor.warden:
        return 'Warden';
      case TimelineActor.seniorWarden:
        return 'Senior Warden';
      case TimelineActor.security:
        return 'Security';
      case TimelineActor.server:
        return 'Server';
    }
  }
}
