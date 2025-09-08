import 'package:get/get.dart';
import 'package:hostel_mgmt/core/enums/request_status.dart';
import 'package:hostel_mgmt/core/enums/timeline_actor.dart';
import 'package:hostel_mgmt/core/rumtime_state/login_session.dart';
import 'package:hostel_mgmt/presentation/view/warden/controller/mock_data.dart';
import 'package:hostel_mgmt/presentation/view/warden/state/warden_home_state.dart';
import 'package:hostel_mgmt/services/warden_service.dart';

class WardenHomeController {
  Future<void> fetchRequestsFromApi() async {
    state.setIsLoading(true);
    state.setError(false, '');
    try {
      final result = await WardenService.getAllRequestsForWarden();
      result.fold(
        (error) {
          state.setError(true, error);
        },
        (response) {
          state.setRequests(response);
        },
      );
    } catch (e) {
      state.setError(true, 'Failed to load requests: $e');
    } finally {
      state.setIsLoading(false);
    }
  }

  final WardenHomeState state;
  WardenHomeController(this.state);

  Future<void> fetchRequests() async {
    state.setIsLoading(true);
    try {
      state.setRequests(mockRequestApiResponse);
    } catch (e) {
      print(e);
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
      state.currentOnScreenRequests.map((onScreenRequest req) {
        req.copyWith(
          request: req.request.copyWith(
            status: role == TimelineActor.assistentWarden
                ? RequestStatus.referred
                : RequestStatus.approved,
          ),
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
      state.currentOnScreenRequests.map((onScreenRequest req) {
        req.copyWith(
          request: req.request.copyWith(
            status: role == TimelineActor.assistentWarden
                ? RequestStatus.cancelled
                : RequestStatus.rejected,
          ),
        );
      });
      await fetchRequests();
    } catch (e) {
      // CustomSnackbar.showError('Failed to reject request');
    } finally {
      state.setIsActioning(false);
    }
  }

  Future<void> acceptRequestbyId(String id) async {
    final session = Get.find<LoginSession>();
    final role = session.role;

    state.setIsActioningbyId(id, true);
    try {
      // simulate API call by updating the specific request
      state.currentOnScreenRequests = state.currentOnScreenRequests.map((
        onScreenRequest req,
      ) {
        if (req.request.id == id) {
          return req.copyWith(
            request: req.request.copyWith(
              status: role == TimelineActor.assistentWarden
                  ? RequestStatus.referred
                  : RequestStatus.approved,
            ),
          );
        }
        return req;
      }).toList();
      await fetchRequests();
    } catch (e) {
      // CustomSnackbar.showError('Failed to reject request');
    } finally {
      state.setIsActioningbyId(id, false);
    }
  }

  // a controller for getting the request by id - only for info
  Future<void> getRequestbyId(String id) async {
    state.currentOnScreenRequests.removeWhere(
      (req) => req.request.requestId == id,
    );
  }

  Future<void> rejectRequestbyId(String id) async {
    final session = Get.find<LoginSession>();
    final role = session.role;
    state.setIsActioningbyId(id, true);
    try {
      state.currentOnScreenRequests = state.currentOnScreenRequests.map((
        onScreenRequest req,
      ) {
        if (req.request.id == id) {
          return req.copyWith(
            request: req.request.copyWith(
              status: role == TimelineActor.assistentWarden
                  ? RequestStatus.cancelled
                  : RequestStatus.rejected,
            ),
          );
        }
        return req;
      }).toList();
      await fetchRequests();
    } catch (e) {
      // CustomSnackbar.showError('Failed to reject request');
    } finally {
      state.setIsActioningbyId(id, false);
    }
  }
}
