import 'package:get/get.dart';
import 'package:hostel_mgmt/core/enums/request_status.dart';
import 'package:hostel_mgmt/core/enums/timeline_actor.dart';
import 'package:hostel_mgmt/core/rumtime_state/login_session.dart';
import 'package:hostel_mgmt/presentation/view/warden/controller/mock_data.dart';
import 'package:hostel_mgmt/presentation/view/warden/state/warden_home_state.dart';

class WardenHomeController {
  final WardenHomeState state;
  WardenHomeController(this.state);

  Future<void> fetchRequests() async {
    state.setIsLoading(true);
    try {
      // simulate 1 second delay
      await Future.delayed(const Duration(seconds: 1));
      state.setRequests(mockRequestApiResponse);
    } catch (e) {
      state.setError(true, 'Failed to load requests');
      // CustomSnackbar.showError('Failed to load requests');
    } finally {
      state.setIsLoading(false);
    }
  }

  Future<void> acceptRequest(String requestId) async {
    final session = Get.find<LoginSession>();
    final role = session.role;

    state.setIsActioning(true);
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      mockRequestApiResponse.requests
          .firstWhere((req) => req.requestId == requestId)
          .status = role == TimelineActor.assistentWarden
          ? RequestStatus.referred
          : RequestStatus.approved;
      await fetchRequests();
    } catch (e) {
      // CustomSnackbar.showError('Failed to accept request');
    } finally {
      state.setIsActioning(false);
    }
  }

  Future<void> rejectRequest(String requestId) async {
    final session = Get.find<LoginSession>();
    final role = session.role;
    state.setIsActioning(true);
    try {
      await Future.delayed(const Duration(seconds: 1));
      mockRequestApiResponse.requests
          .firstWhere((req) => req.requestId == requestId)
          .status = role == TimelineActor.assistentWarden
          ? RequestStatus.cancelled
          : RequestStatus.rejected;
      await fetchRequests();
    } catch (e) {
      // CustomSnackbar.showError('Failed to reject request');
    } finally {
      state.setIsActioning(false);
    }
  }
}
