import '../state/home_state.dart';
import '../../../services/request_service.dart';

class HomeController {
  final HomeState state = HomeState(isLoading: true);

  HomeController() {
    fetchRequests();
  }

  Future<void> fetchRequests() async {
    state.setLoading(true);
    final result = await RequestService.getAllRequests();
    result.fold(
      (error) {
        state.setRequests([]); // Optionally add error handling in state
        // You may want to add: state.setError(error);
      },
      (apiResponse) {
        state.setRequests(apiResponse.requests);
      },
    );
    state.setLoading(false);
  }
}
