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

  static String toShortString(TimelineActor actor) {
    // reverse of fromString function
    switch (actor) {
      case TimelineActor.student:
        return 'student';
      case TimelineActor.parent:
        return 'parent';
      case TimelineActor.warden:
        return 'warden';
      case TimelineActor.seniorWarden:
        return 'senior_warden';
      case TimelineActor.security:
        return 'security';
      case TimelineActor.server:
        return 'server';
    }
  }
  static TimelineActor fromString(String role) {
    switch (role.toLowerCase()) {
      case 'student':
        return TimelineActor.student;
      case 'parent':
        return TimelineActor.parent;
      case 'warden':
        return TimelineActor.warden;
      case 'senior_warden':
        return TimelineActor.seniorWarden;
      case 'security':
        return TimelineActor.security;
      case 'server':
        return TimelineActor.server;
      default:
        throw ArgumentError('Invalid role string: $role');
    }
  }
}
