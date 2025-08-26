import 'package:flutter/material.dart';

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
  IconData get icon {
    switch (this) {
      case RequestType.dayout:
        return Icons.directions_walk; // Outing/Dayout
      case RequestType.leave:
        return Icons.airplane_ticket; // Leave/Travel
    }
  }

  Color get color {
    switch (this) {
      case RequestType.dayout:
        return Colors.orange;
      case RequestType.leave:
        return Colors.blue;
    }
  }
}
