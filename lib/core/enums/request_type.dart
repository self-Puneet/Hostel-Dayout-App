// lib/core/enums/request_type.dart
import 'package:hive/hive.dart';

part 'request_type.g.dart';

@HiveType(typeId: 1)
enum RequestType {
  @HiveField(0)
  dayout,

  @HiveField(1)
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
