// lib/presentation/view/student/controllers/history_controller.dart
import 'package:hostel_mgmt/models/request_model.dart';
import 'package:hostel_mgmt/presentation/view/student/state/history_state.dart';
import 'package:hostel_mgmt/services/history_service.dart';

class HistoryController {
  final HistoryState state;
  HistoryController(this.state);

  Future<void> loadInactive() async {
    state.updateLoadingState(true);
    state.updateErrorState(false, '');
    final result = await StudentHistoryService.getInactiveRequests();
    print(result);
    print('-' * 90);
    result.fold(
      (err) {
        state.setAllRequests(const <RequestModel>[]);
        state.updateErrorState(true, err);
      },
      (data) {
        state.setAllRequests(data.requests);
        state.updateErrorState(false, '');
      },
    );
    state.updateLoadingState(false);
  }

  Future<void> refresh() => loadInactive();
}
