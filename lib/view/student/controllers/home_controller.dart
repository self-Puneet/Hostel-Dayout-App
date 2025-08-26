import '../state/home_state.dart';
import '../../../services/request_service.dart';

class HomeController {
  final HomeState state = HomeState(isLoading: true);

  HomeController() {
    fetchRequests();
  }

  Future<void> fetchRequests() async {
    state.setLoading(true);
    final requests = await RequestService().fetchRequests();
    state.setRequests(requests);
    state.setLoading(false);
  }
}
