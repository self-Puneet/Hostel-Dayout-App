// lib/core/enums/request_status.dart
import 'package:hive/hive.dart';

part 'request_status.g.dart';

@HiveType(typeId: 0)
enum RequestStatus {
  /// Student submitted the request
  @HiveField(0)
  requested,

  /// Sent to parent for approval
  @HiveField(1)
  referred,

  /// Cancelled before parent review
  @HiveField(2)
  cancelled,

  /// Parent approved
  @HiveField(3)
  parentApproved,

  /// Parent denied
  @HiveField(4)
  parentDenied,

  /// Rejected after parent approval
  @HiveField(5)
  rejected,

  /// Approved after parent approval
  @HiveField(6)
  approved,
}

extension RequestStatusX on RequestStatus {
  String get displayName {
    switch (this) {
      case RequestStatus.requested:
        return 'Requested';
      case RequestStatus.referred:
        return 'Referred';
      case RequestStatus.cancelled:
        return 'Cancelled';
      case RequestStatus.parentApproved:
        return 'Parent Approved';
      case RequestStatus.parentDenied:
        return 'Parent Denied';
      case RequestStatus.rejected:
        return 'Rejected';
      case RequestStatus.approved:
        return 'Approved';
    }
  }
}
