enum TimelineActor { student, parent, assistentWarden, security, seniorWarden }

extension TimelineActorX on TimelineActor {
  String get displayName {
    switch (this) {
      case TimelineActor.student:
        return 'Student';
      case TimelineActor.parent:
        return 'Parent';
      case TimelineActor.assistentWarden:
        return 'Assistant Warden';
      case TimelineActor.seniorWarden:
        return 'Senior Warden';
      case TimelineActor.security:
        return 'Security';
    }
  }

  static String toShortString(TimelineActor actor) {
    // reverse of fromString function
    switch (actor) {
      case TimelineActor.student:
        return 'student';
      case TimelineActor.parent:
        return 'parent';
      case TimelineActor.assistentWarden:
        return 'warden';
      case TimelineActor.seniorWarden:
        return 'senior_warden';
      case TimelineActor.security:
        return 'security';
    }
  }

  static TimelineActor fromString(String role) {
    switch (role.toLowerCase()) {
      case 'student':
        return TimelineActor.student;
      case 'parent':
        return TimelineActor.parent;
      case 'warden':
        return TimelineActor.assistentWarden;
      case 'senior_warden':
        return TimelineActor.seniorWarden;
      case 'security':
        return TimelineActor.security;
      default:
        throw ArgumentError('Invalid role string: $role');
    }
  }
}
