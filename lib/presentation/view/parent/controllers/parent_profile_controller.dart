import 'package:get/instance_manager.dart';
import 'package:hostel_mgmt/core/rumtime_state/login_session.dart';
import 'package:hostel_mgmt/presentation/view/parent/state/parent_profile_state.dart';
import 'package:hostel_mgmt/services/parent_service.dart';
import 'package:hostel_mgmt/services/profile_service.dart';
import 'package:hostel_mgmt/models/parent_model.dart';

class ParentProfileController {
  final ParentProfileState state;
  final ProfileService service;

  ParentProfileController({required this.state, required this.service});
  Future<void> initialize() async {
    state.setLoading(true);
    try {
      final token = Get.find<LoginSession>().token;
      if (token.isEmpty) {
        state.setErrored('Missing auth token');
        return;
      }

      ParentModel? parent;

      // Fetch parent (ignore failure for now; don't block student profile)
      final parentResult = await ParentService.getParentProfile(token: token);
      parentResult.fold((err) {
        // record error, but do not block student fetch
        state.setErrored(err);
      }, (p) => parent = p);

      // Fetch student's profile
      final studentResult = await ProfileService.getParentStudentProfile(
        token: token,
      );
      studentResult.fold(
        (err) {
          state.setErrored(err);
        },
        (apiResponse) {
          // Always set student; attach parent if available
          state.setProfile(studentProfile: apiResponse, parentProfile: parent);
        },
      );
    } catch (_) {
      state.setErrored('Failed to load profile data');
    } finally {
      state.setLoading(false);
    }
  }

  
}
