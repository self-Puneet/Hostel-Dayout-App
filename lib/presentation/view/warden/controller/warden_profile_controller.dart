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
    } catch (e) {
      state.setErrored('Failed to load profile data');
    } finally {
      state.setLoading(false);
    }
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
