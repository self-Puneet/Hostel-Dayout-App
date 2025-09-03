import 'package:hostel_mgmt/presentation/view/student/state/request_state.dart';
import 'package:hostel_mgmt/services/request_service.dart';

class RequestDetailController {
  final RequestState state;
  final String requestId;

  RequestDetailController({required this.state, required this.requestId}) {
    fetchRequestDetail(requestId);
  }

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
}
