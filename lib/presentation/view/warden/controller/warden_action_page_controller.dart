// lib/presentation/view/warden/controller/warden_action_page_controller.dart

import 'package:get/get.dart';
import 'package:hostel_mgmt/core/enums/request_status.dart';
import 'package:hostel_mgmt/core/enums/timeline_actor.dart';
import 'package:hostel_mgmt/core/enums/actions.dart';
import 'package:hostel_mgmt/core/rumtime_state/login_session.dart';
import 'package:hostel_mgmt/presentation/view/warden/state/warden_action_state.dart';
import 'package:hostel_mgmt/services/request_service.dart';
import 'package:hostel_mgmt/services/warden_service.dart';

class WardenActionPageController {
  final WardenActionState state;
  WardenActionPageController(this.state);

  // Initialize hostel list and default selection from session.
  void loadHostelsFromSession() {
    final session = Get.find<LoginSession>();
    final base = session.hostels ?? const <HostelInfo>[];
    final list = List<HostelInfo>.from(base);
    state.setHostelList(list);
  }

  Future<void> fetchRequestsFromApi({String? hostelId}) async {
    state.setIsLoading(true);
    state.setError(false, '');
    try {
      final session = Get.find<LoginSession>();
      final String? resolvedHostelId =
          hostelId ??
          state.selectedHostelId ??
          ((session.hostels?.isNotEmpty ?? false)
              ? session.hostels!.first.hostelId
              : null);

      if (resolvedHostelId == null) {
        state.setError(true, 'No hostel selected for fetching requests.');
        return;
      }

      // Active requests endpoint keeps the lists focused for the actioning flows.
      final result = await WardenService.getAllActiveRequestsForWarden(
        resolvedHostelId,
      );

      result.fold((error) => state.setError(true, error), (response) {
        state.setRequests(response);
        // print("fetch requests in warden action page controller");
        // response.map((response1) => {print(response1.$2)}).toList();
        // print(response[0].$2);
      });
    } catch (e) {
      state.setError(true, 'Failed to load requests: $e');
    } finally {
      state.setIsLoading(false);
    }
  }

  Future<void> actionRequestById({
    required String requestId,
    required RequestAction action,
  }) async {
    final session = Get.find<LoginSession>();
    final TimelineActor actor = session.role;

    state.setIsActioningbyId(requestId, true);
    state.setError(false, '');

    try {
      final targetStatus = action.statusAfterAction(actor);
      final String statusApi = targetStatus.statusToApiString;

      final result = await RequestService.updateRequestStatus(
        requestId: requestId,
        status: statusApi,
        remark: 'ok done',
      );

      await result.fold(
        (error) async {
          state.setError(true, error);
        },
        (updatedStatus) async {
          fetchRequestsFromApi();
          state.notifyListenerMethod();
        },
      );
    } catch (e) {
      state.setError(true, 'Action failed: $e');
    } finally {
      state.setIsActioningbyId(requestId, false);
    }
  }

  Future<void> bulkActionSelected({required RequestAction action}) async {
    // Collect selected requests from the Pending view (selection only valid there).
    final pending = getRequestsForPending(Get.find<LoginSession>().role);
    final ids = pending
        .where((w) => w.isSelected)
        .map((w) => w.request.requestId)
        .toList();
    print("here we goo !!");
    if (ids.isEmpty) return;

    state.setIsActioning(true);
    try {
      for (final id in ids) {
        await actionRequestById(requestId: id, action: action);
      }
      // Clear selection after bulk completion; lists auto-refresh from master.
      state.clearSelection();
    } finally {
      state.setIsActioning(false);
    }
  }

  // Build lists through state's on-demand filterers to avoid shared mutable lists.
  List<OnScreenRequest> getRequestsForPending(TimelineActor actor) {
    final statuses = state.allowedForTab(actor, WardenTab.pendingApproval);
    return state.buildListForStatuses(statuses);
  }

  List<OnScreenRequest> getRequestsForStatus(RequestStatus status) {
    return state.buildListForStatus(status);
  }

  List<OnScreenRequest> getRequestsForStatuses(Set<RequestStatus> statuses) {
    return state.buildListForStatuses(statuses);
  }
}
