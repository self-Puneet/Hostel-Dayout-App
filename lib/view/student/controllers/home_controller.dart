import '../state/home_state.dart';
import '../../../services/request_service.dart';
import '../../../services/profile_service.dart';
// import 'package:hostel_mgmt/models/student_profile.dart';

class HomeController {
  final HomeState state = HomeState(isLoading: true);

  HomeController() {
    fetchProfileAndRequests();
  }

  Future<void> fetchProfileAndRequests() async {
    state.setLoading(true);
    // Fetch profile
    final profileResult = await ProfileService.getStudentProfile();
    profileResult.fold(
      (error) {
        print('Profile error: $error');
      },
      (apiResponse) {
        state.setProfile(apiResponse.student);
      },
    );
    // Fetch requests
    final result = await RequestService.getAllRequests();
    result.fold(
      (error) {
        print(error);
      },
      (apiResponse) {
        state.setRequests(apiResponse.requests);
      },
    );
    state.setLoading(false);
  }
}
