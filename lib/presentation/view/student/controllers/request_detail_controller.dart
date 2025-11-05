// lib/presentation/view/student/controllers/request_detail_controller.dart
import 'package:hostel_mgmt/core/enums/actions.dart';
import 'package:hostel_mgmt/core/enums/enum.dart';
import 'package:hostel_mgmt/presentation/view/student/state/request_state.dart';
import 'package:hostel_mgmt/services/request_service.dart';

class RequestDetailController {
  final RequestState state;
  final String requestId;
  final TimelineActor actor;

  RequestDetailController({
    required this.state,
    required this.requestId,
    required this.actor,
  }) {
    fetchRequestDetail(requestId);
    if (actor == TimelineActor.assistentWarden ||
        actor == TimelineActor.seniorWarden) {
      // fetchStudentParentInfo();
    }
  }

  Future<void> fetchRequestDetail(String requestId) async {
    state.setLoading(true);
    state.clearError();
    final result = await RequestService.getRequestById(requestId: requestId);
    result.fold((error) => state.setError(error), (request) {
      state.setRequest(request);
      print("get the name from request detail controller");
      // print(request.request.studentAction!.studentProfileModel.name);
      print("get the name from request detail controller");
    });
    state.setLoading(false);
  }

  // Map RequestStatus -> API string (mirror your RequestModel._statusToString)
  String _statusToApi(RequestStatus status) {
    switch (status) {
      case RequestStatus.requested:
        return "requested";
      case RequestStatus.referred:
        return "referred_to_parent";
      case RequestStatus.cancelled:
        return "cancelled_assitent_warden"; // keep backend’s spelling
      case RequestStatus.parentApproved:
        return "accepted_by_parent";
      case RequestStatus.parentDenied:
        return "rejected_by_parent";
      case RequestStatus.approved:
        return "accepted_by_warden";
      case RequestStatus.rejected:
        return "rejected_by_warden";
      case RequestStatus.cancelledStudent:
        return "cancelled_by_student";
    }
  }

  // Perform action -> update status -> refresh page
  Future<void> performAction({
    required TimelineActor actor,
    required RequestAction action,
    String remark = '',
  }) async {
    // Block actions if not ready
    final detail = state.request;
    if (detail == null) return;

    // Compute target status from action + actor
    final nextStatusEnum = action.statusAfterAction(actor);
    final apiStatus = _statusToApi(nextStatusEnum);

    state.setActioning(true);

    final result = await RequestService.updateRequestStatus(
      requestId: detail.request.requestId,
      status: apiStatus,
      remark: remark,
    );

    result.fold(
      (err) {
        state.setActioning(false);
        state.setError(err);
      },
      (_) async {
        // Full-page refresh as requested
        await fetchRequestDetail(requestId);
        state.setActioning(false);
      },
    );
  }

  // Future<void> fetchStudentParentInfo() async {
  //   state.setLoadingStudentParentInfo(true);
  //   state.clearError();
  //   final result = await ProfileService.getStudentProfile();
  //   result.fold(
  //     (error) => state.setError(error),
  //     (info) => state.setStudentParentInfo(info),
  //   );
  //   state.setLoadingStudentParentInfo(false);
  // }
}
