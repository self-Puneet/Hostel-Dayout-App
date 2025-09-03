import 'package:hostel_mgmt/core/enums/enum.dart';
import 'package:hostel_mgmt/core/enums/request_type.dart';
import 'package:hostel_mgmt/presentation/view/student/state/request_state.dart';
import 'package:hostel_mgmt/models/request_model.dart';
import 'package:hostel_mgmt/services/request_service.dart';

class RequestDetailController {
  final RequestState state;

  RequestDetailController(this.state);

  // Example method to fetch request details from API
  Future<void> fetchRequestDetail(String requestId) async {
    state.setLoading(true);
    final result = await RequestService.getRequestById(requestId: requestId);
    result.fold(
      (error) {
        state.setError(error);
      },
      (request) {
        state.setRequest(request);
      },
    );
    state.setLoading(false);
  }

  // Static method returning a demo RequestModel
  static RequestModel demoRequest() {
    return RequestModel(
      id: 'demo_id',
      requestId: 'REQ_DEMO',
      requestType: RequestType.leave,
      studentEnrollmentNumber: 'ENR_DEMO',
      appliedFrom: DateTime.now().subtract(Duration(days: 2)),
      appliedTo: DateTime.now().add(Duration(days: 2)),
      reason: 'Demo request for testing',
      status: RequestStatus.approved,
      active: true,
      createdBy: 'admin',
      appliedAt: DateTime.now().subtract(Duration(days: 2)),
      lastUpdatedAt: DateTime.now(),
    );
  }
}
