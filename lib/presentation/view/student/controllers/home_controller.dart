import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/utils.dart';
import 'package:hostel_mgmt/core/enums/enum.dart';
import 'package:hostel_mgmt/core/rumtime_state/login_session.dart';
import 'package:hostel_mgmt/services/profile_service.dart';
import 'package:hostel_mgmt/services/request_service.dart';
import '../state/home_state.dart';

class HomeController {
  final HomeState state = HomeState(isLoading: true);

  HomeController() {
    // Keep existing behavior, but now also fetch real history (All) immediately.
    fetchProfileAndRequests();
    fetchHistoryRequests(); // new
  }

  Future<void> fetchProfileAndRequests() async {
    state.setLoading(true);

    // Profile
    final profileResult = await ProfileService.getStudentProfile();
    profileResult.fold(
      (error) {
        print('Profile error: $error');
      },
      (profileResponse) {
        final session = LoginSession(
          token: Get.find<LoginSession>().token,
          username: profileResponse.student.name,
          email: profileResponse.student.email,
          identityId: profileResponse.student.enrollmentNo,
          hostels: [
            HostelInfo(
              hostelId: profileResponse.student.hostelName,
              hostelName: profileResponse.student.hostelName,
            ),
          ],
          role: TimelineActor.student,
          imageURL: Get.find<LoginSession>().imageURL,
        );

        session.saveToPrefs();

        state.setProfile(profileResponse.student);
      },
    );

    // Active requests (unchanged, assuming your existing endpoint returns everything and you filter active)
    final result = await RequestService.getAllRequests();
    result.fold(
      (error) {
        print(error);
      },
      (apiResponse) {
        final active = apiResponse.requests.where((r) => r.active).toList();
        // final history = apiResponse.requests;
        state.setRequests(active);
        // state.setHistoryRequests(history);
      },
    );

    state.setLoading(false);
  }

  // New: Fetch history for the dropdown filter set (default "All" on page open).
  // If the UI filters locally, this ensures we always have the full set for accurate filtering.
  Future<void> fetchHistoryRequests({String filter = 'All'}) async {
    try {
      state.isLoadingHistory = true;
      final requests = await RequestService.getRequestsByStatusKey(filter);
      state.setHistoryRequests(requests);
    } catch (e) {
      print('History fetch error ($filter): $e');
    } finally {
      state.isLoadingHistory = false;
    }
  }
}
