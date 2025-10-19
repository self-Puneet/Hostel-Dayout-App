import 'package:get/get.dart';
import 'package:hostel_mgmt/core/rumtime_state/login_session.dart';
import 'package:hostel_mgmt/presentation/view/warden/state/warden_history_state.dart';
import 'package:hostel_mgmt/services/warden_service.dart';

class WardenHistoryPageController {
  final WardenHistoryState state;
  WardenHistoryPageController(this.state);

  // Load available hostels from the current session
  void loadHostelsFromSession() {
    final session = Get.find<LoginSession>();
    final hostels = session.hostels ?? [];
    state.setHostelList(hostels);
  }

  // Fetch requests from API based on hostel and month-year
  Future<void> fetchRequestsFromApi({
    String? hostelId,
    DateTime? monthYear,
  }) async {
    print(hostelId);
    print(monthYear);
    state.setIsLoading(true);
    state.setError(false, '');
    try {
      final session = Get.find<LoginSession>();
      final resolvedHostelId =
          hostelId ??
          state.selectedHostelId ??
          ((session.hostels?.isNotEmpty ?? false)
              ? session.hostels!.first.hostelId
              : null);

      if (resolvedHostelId == null) {
        state.setError(true, 'No hostel selected for fetching history.');
        return;
      }

      final date =
          monthYear ?? DateTime(state.selectedYear, state.selectedMonth);
      final yearMonth = '${date.year}-${date.month.toString().padLeft(2, '0')}';

      final result = await WardenService.getRequestsForMonth(
        hostelId: resolvedHostelId,
        yearMonth: yearMonth,
      );

      result.fold(
        (err) => state.setError(true, err),
        (list) => state.setRequests(list.map((r) => (r.$1, r.$2)).toList()),
      );
    } catch (e) {
      state.setError(true, 'Failed to load history: $e');
    } finally {
      state.setIsLoading(false);
    }
  }
}
