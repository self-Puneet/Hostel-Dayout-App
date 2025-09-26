import 'package:hostel_mgmt/core/enums/enum.dart';
import 'package:hostel_mgmt/models/request_model.dart';
import 'package:hostel_mgmt/services/profile_service.dart';
import 'package:hostel_mgmt/services/request_service.dart';

import '../state/home_state.dart';

class HomeController {
  final HomeState state = HomeState(isLoading: true);

  HomeController() {
    fetchProfileAndRequests();
  }

  Future<void> fetchProfileAndRequests() async {
    state.setLoading(true);
    // Fetch profile
    final profileResult = await ProfileService.getStudentProfile();
    profileResult.fold(
      (error) {
        print('Profile error: $error');
      },
      (apiResponse) {
        
        state.setProfile(apiResponse.student);
      },
    );
    // Fetch active requests
    final result = await RequestService.getAllRequests();
    result.fold(
      (error) {
        print(error);
      },
      (apiResponse) {
        // Separate active and history requests
        print(
          "All Requests status from controller: ${apiResponse.requests.map((e) => e.status).toList()}",
        );
        final active = apiResponse.requests.where((r) => r.active).toList();
        final history = apiResponse.requests;
        state.setRequests(active);
        state.setHistoryRequests(history);
      },
    );
    // set history requests
    state.setHistoryRequests([
      RequestModel(
        id: '1',
        requestId: 'REQ1',
        requestType: RequestType.leave,
        studentEnrollmentNumber: 'ENR001',
        appliedFrom: DateTime.now().subtract(Duration(days: 2)),
        appliedTo: DateTime.now().subtract(Duration(days: 1)),
        reason: 'Approved request',
        status: RequestStatus.approved,
        active: true,
        createdBy: 'admin',
        appliedAt: DateTime.now().subtract(Duration(days: 1)),
        lastUpdatedAt: DateTime.now(),
      ),
      RequestModel(
        id: '2',
        requestId: 'REQ2',
        requestType: RequestType.leave,
        studentEnrollmentNumber: 'ENR002',
        appliedFrom: DateTime.now().subtract(Duration(days: 3)),
        appliedTo: DateTime.now().subtract(Duration(days: 2)),
        reason: 'Rejected request',
        status: RequestStatus.rejected,
        active: false,
        createdBy: 'admin',
        appliedAt: DateTime.now().subtract(Duration(days: 2)),
        lastUpdatedAt: DateTime.now(),
      ),
    ]);
    state.setLoading(false);
  }
}
