// lib/core/enums/request_activity_state.dart
import 'package:hive/hive.dart';

part 'request_state.g.dart';

@HiveType(typeId: 3)
enum RequestState {
  @HiveField(0)
  active,

  @HiveField(1)
  inactive,
}

extension RequestStateX on RequestState {
  String get displayName {
    switch (this) {
      case RequestState.active:
        return 'Active';
      case RequestState.inactive:
        return 'Inactive';
    }
  }
}
