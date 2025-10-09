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

  // NEW: Initialize hostel list and default selection from session.
  void loadHostelsFromSession() {
    final session = Get.find<LoginSession>();
    final ids = session.hostelIds ?? <String>[];
    state.setHostelList(ids);
  }

  Future<void> fetchRequestsFromApi({String? hostelId}) async {
    state.setIsLoading(true);
    state.setError(false, '');
    try {
      final session = Get.find<LoginSession>();
      final String? resolvedHostelId =
          hostelId ??
          state.selectedHostelId ??
          ((session.hostelIds?.isNotEmpty ?? false)
              ? session.hostelIds!.first
              : null);

      if (resolvedHostelId == null) {
        state.setError(true, 'No hostel selected for fetching requests.');
        return;
      }
      final result = await WardenService.getAllActiveRequestsForWarden(
        resolvedHostelId,
      );

      // final result = await WardenService.getAllRequestsForWarden(
      //   resolvedHostelId,
      // );
      result.fold((error) => state.setError(true, error), (response) {
        print(response.length);
        state.setRequests(response);
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
      // print(jsonDecode(result))

      await result.fold(
        (error) async {
          state.setError(true, error);
        },
        (updatedRequestModel) async {
          final keep = WardenActionState.belongsToActorQueue(
            updatedRequestModel.status,
            actor,
          );

          if (!keep) {
            state.currentOnScreenRequests.removeWhere(
              (w) => w.request.requestId == requestId,
            );
            state.notifyListenerMethod();
          } else {
            state.currentOnScreenRequests = state.currentOnScreenRequests.map((
              w,
            ) {
              if (w.request.requestId == requestId) {
                return w.copyWith(request: updatedRequestModel);
              }
              return w;
            }).toList();
            state.notifyListenerMethod();
          }
        },
      );
    } catch (e) {
      state.setError(true, 'Action failed: $e');
    } finally {
      state.setIsActioningbyId(requestId, false);
    }
  }

  Future<void> bulkActionSelected({required RequestAction action}) async {
    if (!state.hasSelection) return;
    state.setIsActioning(true);
    try {
      final ids = state.selectedRequests.map((r) => r.requestId).toList();
      for (final id in ids) {
        await actionRequestById(requestId: id, action: action);
      }
    } finally {
      state.setIsActioning(false);
    }
  }

  List<OnScreenRequest> getRequestByStatus({required RequestStatus status_}) {
    final requests = state.allRequests;
    final List<OnScreenRequest> onScreenRequest = [];
    for (int i = 0; i < requests.length; i++) {
      if (requests[i].$1.status == status_) {
        onScreenRequest.add(OnScreenRequest.fromRequest(requests[i]));
      }
    }
    if (status_ == RequestStatus.referred) {
      print(onScreenRequest.length);
    }
    return onScreenRequest.toList();
  }
}
