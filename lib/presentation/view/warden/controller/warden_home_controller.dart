import 'package:get/get.dart';
import 'package:hostel_mgmt/core/enums/request_status.dart';
import 'package:hostel_mgmt/core/enums/timeline_actor.dart';
import 'package:hostel_mgmt/core/rumtime_state/login_session.dart';
import 'package:hostel_mgmt/models/request_model.dart';
import 'package:hostel_mgmt/presentation/view/warden/controller/mock_data.dart';
import 'package:hostel_mgmt/presentation/view/warden/state/warden_home_state.dart';

class WardenHomeController {
  final WardenHomeState state;
  WardenHomeController(this.state);

  Future<void> fetchRequests() async {
    state.setIsLoading(true);
    try {
      state.setRequests(mockRequestApiResponse);
    } catch (e) {
      state.setError(true, 'Failed to load requests');
    } finally {
      state.setIsLoading(false);
    }
  }

  Future<void> acceptRequest() async {
    final session = Get.find<LoginSession>();
    final role = session.role;

    state.setIsActioning(true);
    try {
      // Simulate API call
      state.currentOnScreenRequests.map((RequestModel req) {
        req.copyWith(
          status: role == TimelineActor.assistentWarden
              ? RequestStatus.referred
              : RequestStatus.approved,
        );
      });
      await fetchRequests();
    } catch (e) {
      // CustomSnackbar.showError('Failed to reject request');
    } finally {
      state.setIsActioning(false);
    }
  }

  Future<void> rejectRequest() async {
    final session = Get.find<LoginSession>();
    final role = session.role;
    state.setIsActioning(true);
    try {
      state.currentOnScreenRequests.map((RequestModel req) {
        req.copyWith(
          status: role == TimelineActor.assistentWarden
              ? RequestStatus.cancelled
              : RequestStatus.rejected,
        );
      });
      await fetchRequests();
    } catch (e) {
      // CustomSnackbar.showError('Failed to reject request');
    } finally {
      state.setIsActioning(false);
    }
  }
}
