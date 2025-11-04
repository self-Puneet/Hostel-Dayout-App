// lib/presentation/view/warden_profile/controllers/warden_profile_controller.dart
import 'package:dartz/dartz.dart';
import 'package:hostel_mgmt/services/auth_service.dart';
import 'package:hostel_mgmt/services/profile_service.dart';
import '../state/warden_profile_state.dart';

class WardenProfileController {
  final WardenProfileState state;

  WardenProfileController({required this.state});

  Future<void> initialize() async {
    state.setLoading(true);
    try {
      final result = await ProfileService.getWardenProfile();
      result.fold(
        (err) => state.setErrored(err),
        (warden) => state.setProfile(warden),
      );

      final hostelNames = await getHostelNamesFromProfile();

      // IMPORTANT: assign the copy back into state so listeners are notified
      if (state.profile != null) {
        state.setProfile(state.profile!.copyWith(hostels: hostelNames));
      }
    } catch (e) {
      state.setErrored('Failed to load profile data');
    } finally {
      state.setLoading(false);
    }
  }

  // for getting all hostel info from a service then getting those hostels name whose ids are present in warden profile and returning those names as list of strings
  Future<List<String>> getHostelNamesFromProfile() async {
    final warden = state.profile;
    if (warden == null) return [];

    // Fetch once
    final hostelResult = await ProfileService.getAllHostelInfo();

    return hostelResult.fold<List<String>>((err) => [], (hostels) {
      final byId = {for (final h in hostels) h.hostelId: h.hostelName};
      final names = <String>[];
      for (final id in warden.hostelId) {
        final name = byId[id];
        if (name != null) names.add(name);
      }
      return names;
    });
  }

  Future<Either<String, bool>> resetPassword() async {
    state.validateReset();

    if (!state.canSubmitReset) {
      return left('Please fix the validation errors to continue');
    }

    state.setResetLoading(true);
    try {
      final oldPassword = state.oldPwC.text.trim();
      final newPassword = state.newPwC.text.trim();

      final res = await AuthService.resetPassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
      );

      return res;
    } catch (e) {
      return left('Unexpected error: $e');
    } finally {
      state.setResetLoading(false);
    }
  }
}
