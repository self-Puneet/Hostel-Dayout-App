import '../models/request_model.dart';
import 'package:hostel_mgmt/core/enums/request_type.dart';
import 'package:hostel_mgmt/core/enums/request_status.dart';
import 'dart:async';

class RequestService {
  Future<List<RequestModel>> fetchRequests() async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate network delay
    return [
      RequestModel(
        requestType: RequestType.leave,
        appliedFrom: DateTime(2025, 8, 26, 8, 0),
        appliedTo: DateTime(2025, 8, 28, 20, 0),
        reason: 'Family Function',
        status: RequestStatus.parentApproved,
      ),
    ];
  }
}
