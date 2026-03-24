// parent_home_controller.dart
import 'package:hostel_mgmt/core/enums/actions.dart';
import 'package:hostel_mgmt/core/enums/enum.dart';
import 'package:hostel_mgmt/presentation/view/parent/state/parent_state.dart';
import 'package:hostel_mgmt/services/parent_service.dart';
import 'package:hostel_mgmt/services/request_service.dart';

class ParentHomeController {
  final ParentState state;
  ParentHomeController(this.state);

  Future<void> fetchActiveRequests() async {
    state.setLoading(true);
    state.isLoadingHistory = true;
    state.clearError();
    final result = await ParentService.getAllRequests();
    result.fold((err) => state.setError(err), (resp) {
      state.setRequests(resp);
    });
    state.setLoading(false);
    await fetchHistoryRequests();
  }

  // Generic action by id for parent: approve or reject
  Future<void> actionById({
    required String requestId,
    required RequestAction action,
  }) async {
    // Map the action to status via extension with parent actor
    final targetStatus = action.statusAfterAction(TimelineActor.parent);
    final statusApi =
        targetStatus.statusToApiString; // your extension on RequestStatus

    state.setActioning(true);
    try {
      final result = await RequestService.updateRequestStatus(
        requestId: requestId,
        status: statusApi,
        remark: 'ok done',
      );
      result.fold(
        (err) {
          state.setLoading(true);
          fetchActiveRequests();
          state.setLoading(false);
        },
        (updated) {
          state.setLoading(true);
          fetchActiveRequests();
          state.setLoading(false);
        },
      );
      // Optionally refresh full list to be safe:
      // await fetchActiveRequests();
    } finally {
      state.setActioning(false);
    }
  }

  Future<void> approveById(String requestId) =>
      actionById(requestId: requestId, action: RequestAction.approve);

  Future<void> rejectById(String requestId) =>
      actionById(requestId: requestId, action: RequestAction.reject);

  Future<void> fetchHistoryRequests({String filter = 'All'}) async {
    try {
      state.isLoadingHistory = true;
      final requests = await RequestService.getRequestsByStatusKey(filter);
      state.setHistoryRequests(requests);
      state.isLoadingHistory = false;
    } catch (e) {
      state.errorMessage = e.toString();
    } finally {
      state.setLoading(false);
    }
  }
}
