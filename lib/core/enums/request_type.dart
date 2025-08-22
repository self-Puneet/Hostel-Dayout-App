enum RequestType {
  dayout,
  leave,
}

extension RequestTypeX on RequestType {
  String get displayName {
    switch (this) {
      case RequestType.dayout:
        return 'Dayout';
      case RequestType.leave:
        return 'Leave';
    }
  }
}
