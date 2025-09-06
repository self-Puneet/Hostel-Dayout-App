import 'package:hostel_mgmt/models/request_model.dart';
import 'package:hostel_mgmt/models/student_profile.dart';
import 'package:hostel_mgmt/models/parent_model.dart';
import 'package:hostel_mgmt/core/enums/request_status.dart';
import 'package:hostel_mgmt/core/enums/request_type.dart';
import 'package:hostel_mgmt/core/enums/security_status.dart';
import 'package:hostel_mgmt/core/enums/actions.dart';

RequestApiResponse mockRequestApiResponse = RequestApiResponse(
  message: 'Mock data loaded',
  requests: [
    RequestModel(
      id: '1',
      requestId: 'REQ001',
      requestType: RequestType.leave,
      studentEnrollmentNumber: 'ENR123',
      appliedFrom: DateTime.now().subtract(const Duration(days: 2)),
      appliedTo: DateTime.now().add(const Duration(days: 2)),
      reason: 'Family function',
      status: RequestStatus.requested,
      active: true,
      createdBy: 'student',
      appliedAt: DateTime.now().subtract(const Duration(days: 2)),
      lastUpdatedAt: DateTime.now(),
      securityStatus: SecurityStatus.pending,
      parentRemark: 'Approved',
      studentAction: StudentAction(
        action: RequestAction.cancel,
        actionAt: DateTime.now().subtract(const Duration(days: 2)),
        studentProfileModel: StudentProfileModel(
          studentId: 'S1',
          enrollmentNo: 'ENR123',
          name: 'John Doe',
          email: 'john@example.com',
          phoneNo: '1234567890',
          profilePic: null,
          hostelName: 'A',
          roomNo: '101',
          semester: 5,
          branch: 'CSE',
          parents: [
            ParentModel(
              parentId: 'P1',
              name: 'Jane Doe',
              relation: 'Mother',
              phoneNo: '9876543210',
              email: 'jane@example.com',
              languagePreference: 'English',
            ),
          ],
        ),
      ),
      parentAction: null,
      assistantWardenAction: null,
      seniorWardenAction: null,
      securityGuardAction: null,
    ),
    RequestModel(
      id: '2',
      requestId: 'REQ002',
      requestType: RequestType.dayout,
      studentEnrollmentNumber: 'ENR456',
      appliedFrom: DateTime.now().subtract(const Duration(days: 1)),
      appliedTo: DateTime.now().add(const Duration(days: 1)),
      reason: 'Medical appointment',
      status: RequestStatus.parentApproved,
      active: false,
      createdBy: 'student',
      appliedAt: DateTime.now().subtract(const Duration(days: 1)),
      lastUpdatedAt: DateTime.now(),
      securityStatus: SecurityStatus.outCampus,
      parentRemark: 'Take care',
      studentAction: StudentAction(
        action: RequestAction.cancel,
        actionAt: DateTime.now().subtract(const Duration(days: 1)),
        studentProfileModel: StudentProfileModel(
          studentId: 'S2',
          enrollmentNo: 'ENR456',
          name: 'Alice Smith',
          email: 'alice@example.com',
          phoneNo: '5555555555',
          profilePic: null,
          hostelName: 'B',
          roomNo: '202',
          semester: 3,
          branch: 'ECE',
          parents: [
            ParentModel(
              parentId: 'P2',
              name: 'Bob Smith',
              relation: 'Father',
              phoneNo: '8888888888',
              email: 'bob@example.com',
              languagePreference: 'Hindi',
            ),
          ],
        ),
      ),
      parentAction: null,
      assistantWardenAction: null,
      seniorWardenAction: null,
      securityGuardAction: null,
    ),
  ],
);
