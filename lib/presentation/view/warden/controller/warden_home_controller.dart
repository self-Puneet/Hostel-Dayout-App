// warden_home_controller.dart

import 'package:get/get.dart';
import 'package:hostel_mgmt/core/enums/request_status.dart';
import 'package:hostel_mgmt/core/enums/timeline_actor.dart';
import 'package:hostel_mgmt/core/enums/actions.dart'; // your RequestAction enum
import 'package:hostel_mgmt/core/rumtime_state/login_session.dart';
import 'package:hostel_mgmt/presentation/view/warden/state/warden_home_state.dart';
import 'package:hostel_mgmt/services/request_service.dart';
import 'package:hostel_mgmt/services/warden_service.dart'; // expose updateStatus here that wraps RequestService
// If you call RequestService directly, import that instead.

class WardenHomeController {
  final WardenHomeState state;
  WardenHomeController(this.state);

  Future<void> fetchRequestsFromApi() async {
    state.setIsLoading(true);
    state.setError(false, '');
    try {
      final result = await WardenService.getAllRequestsForWarden();
      result.fold(
        (error) => state.setError(true, error),
        (response) => state.setRequests(response),
      );
    } catch (e) {
      state.setError(true, 'Failed to load requests: $e');
    } finally {
      state.setIsLoading(false);
    }
  }

  // NEW: single per-item action method
  Future<void> actionRequestById({
    required String requestId,
    required RequestAction action,
  }) async {
    final session = Get.find<LoginSession>();
    final TimelineActor actor = session.role;

    state.setIsActioningbyId(requestId, true);

    try {
      // 1) Compute target status via your enum extension
      final RequestStatus targetStatus = action.statusAfterAction(
        actor,
      ); // extension on RequestAction
      final String statusApi =
          targetStatus.statusToApiString; // extension on RequestStatus

      // 2) Call API (via WardenService or RequestService)
      final result = await RequestService.updateRequestStatus(
        requestId: requestId,
        status: statusApi,
        remark: 'ok done',
      );

      // 3) Handle response and update local state
      result.fold(
        (error) {
          state.setError(true, error);
        },
        (updatedRequestModel) {
          // Update the specific item locally
          state.currentOnScreenRequests = state.currentOnScreenRequests.map((
            w,
          ) {
            if (w.request.requestId == requestId) {
              return w.copyWith(request: updatedRequestModel);
            }
            return w;
          }).toList();
        },
      );

      // 4) Optionally refresh from server to stay in sync
      await fetchRequestsFromApi();
    } catch (e) {
      state.setError(true, 'Action failed: $e');
    } finally {
      state.setIsActioningbyId(requestId, false);
    }
  }

  // OPTIONAL: bulk variants can reuse the same method
  Future<void> bulkActionSelected({required RequestAction action}) async {
    if (!state.hasSelection) return;
    // Mark global actioning to show spinner if desired
    state.setIsActioning(true);
    try {
      final ids = state.selectedRequests.map((r) => r.requestId).toList();
      for (final id in ids) {
        await actionRequestById(requestId: id, action: action);
      }
      state.clearSelection();
      await fetchRequestsFromApi();
    } finally {
      state.setIsActioning(false);
    }
  }
}
