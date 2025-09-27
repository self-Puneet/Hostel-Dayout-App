// lib/services/request_service.dart
import 'dart:async';
import 'package:hostel_mgmt/core/enums/request_status.dart';
import 'package:hostel_mgmt/core/enums/request_type.dart';
import 'package:hostel_mgmt/models/request_model.dart';

class RequestService {
  Future<List<RequestModel>> fetchDemoRequests() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    DateTime dt(int y, int m, int d, [int hh = 10, int mm = 0]) => DateTime(y, m, d, hh, mm);

    final now = DateTime.now();
    final y = now.year;

    return <RequestModel>[
      // August 2025 (Approved/Rejected)
      RequestModel(
        id: '1',
        requestId: 'REQ-0001',
        requestType: RequestType.dayout,
        studentEnrollmentNumber: 'ENR001',
        appliedFrom: dt(y, 8, 29, 11, 0),
        appliedTo: dt(y, 8, 29, 18, 0),
        reason: 'Group project celebration at city mall.',
        status: RequestStatus.approved,
        active: false,
        createdBy: 'student',
        appliedAt: dt(y, 8, 27, 9, 0),
        lastUpdatedAt: dt(y, 8, 28, 12, 0),
      ),
      RequestModel(
        id: '2',
        requestId: 'REQ-0002',
        requestType: RequestType.dayout,
        studentEnrollmentNumber: 'ENR002',
        appliedFrom: dt(y, 8, 25, 10, 0),
        appliedTo: dt(y, 8, 25, 18, 0),
        reason: 'Buying essentials and grocery run.',
        status: RequestStatus.approved,
        active: false,
        createdBy: 'student',
        appliedAt: dt(y, 8, 24, 16, 0),
        lastUpdatedAt: dt(y, 8, 24, 17, 0),
      ),
      RequestModel(
        id: '3',
        requestId: 'REQ-0003',
        requestType: RequestType.leave,
        studentEnrollmentNumber: 'ENR003',
        appliedFrom: dt(y, 8, 10, 6, 0),
        appliedTo: dt(y, 8, 12, 22, 0),
        reason: 'Family function out of town.',
        status: RequestStatus.rejected,
        active: false,
        createdBy: 'student',
        appliedAt: dt(y, 8, 8, 14, 0),
        lastUpdatedAt: dt(y, 8, 9, 11, 0),
      ),

      // July 2025 (Cancelled/ParentDenied)
      RequestModel(
        id: '4',
        requestId: 'REQ-0004',
        requestType: RequestType.dayout,
        studentEnrollmentNumber: 'ENR004',
        appliedFrom: dt(y, 7, 20, 12, 0),
        appliedTo: dt(y, 7, 20, 19, 0),
        reason: 'Sports event participation.',
        status: RequestStatus.cancelledStudent,
        active: false,
        createdBy: 'student',
        appliedAt: dt(y, 7, 18, 10, 0),
        lastUpdatedAt: dt(y, 7, 19, 15, 0),
      ),
      RequestModel(
        id: '5',
        requestId: 'REQ-0005',
        requestType: RequestType.leave,
        studentEnrollmentNumber: 'ENR005',
        appliedFrom: dt(y, 7, 5, 8, 0),
        appliedTo: dt(y, 7, 8, 21, 0),
        reason: 'Medical appointment and rest.',
        status: RequestStatus.parentDenied,
        active: false,
        createdBy: 'student',
        appliedAt: dt(y, 7, 3, 12, 0),
        lastUpdatedAt: dt(y, 7, 4, 9, 0),
      ),

      // June 2025 (Approved/Requested)
      RequestModel(
        id: '6',
        requestId: 'REQ-0006',
        requestType: RequestType.dayout,
        studentEnrollmentNumber: 'ENR006',
        appliedFrom: dt(y, 6, 15, 9, 0),
        appliedTo: dt(y, 6, 15, 17, 0),
        reason: 'Book fair visit.',
        status: RequestStatus.approved,
        active: false,
        createdBy: 'student',
        appliedAt: dt(y, 6, 13, 8, 0),
        lastUpdatedAt: dt(y, 6, 14, 18, 0),
      ),
      RequestModel(
        id: '7',
        requestId: 'REQ-0007',
        requestType: RequestType.leave,
        studentEnrollmentNumber: 'ENR007',
        appliedFrom: dt(y, 6, 25, 6, 0),
        appliedTo: dt(y, 6, 27, 23, 0),
        reason: 'Cousin wedding in hometown.',
        status: RequestStatus.requested,
        active: true,
        createdBy: 'student',
        appliedAt: dt(y, 6, 22, 17, 0),
        lastUpdatedAt: dt(y, 6, 22, 17, 0),
      ),
    ];
  }
}
