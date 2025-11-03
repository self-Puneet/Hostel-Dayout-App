import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:hostel_mgmt/services/auth_service.dart';
import 'package:hostel_mgmt/services/profile_service.dart';
import '../state/profile_state.dart';

class ProfileController {
  final ProfileState state;
  final ProfileService service;

  ProfileController({required this.state, required this.service});

  Future<void> initialize() async {
    state.setLoading(true);
    try {
      final profileResult = await ProfileService.getStudentProfile();
      profileResult.fold(
        (err) => state.setErrored(err),
        (apiResponse) => state.setProfile(apiResponse.student),
      );
    } catch (e) {
      state.setErrored('Failed to load profile data');
    } finally {
      state.setLoading(false);
    }
  }

  Future<void> updateProfilePicture(File file) async {
    final current = state.profile;
    if (current == null) return;
    state.setUploadingPic(true);
    try {
      final result = await ProfileService.updateProfilePic1(
        profileData: {"name": current.name},
        profilePic: file,
      );
      print("-----------------");
      print(result);
      result.fold(
        (err) => state.setErrored(err),
        (updated) => state.setProfile(updated),
      );
    } catch (e) {
      state.setErrored('Failed to update profile picture');
    } finally {
      state.setUploadingPic(false);
    }
  }

  Future<Either<String, bool>> resetPassword() async {
    // Ensure latest validation
    state.setResetLoading(true);
    try {
      final oldPassword = state.oldPwC.text.trim();
      final newPassword = state.newPwC.text.trim();

      // Guard: should already be enforced by disabled button, but safe to check
      if (!state.canSubmitReset) {
        state.setResetLoading(false);
        print("Validation errors present");
        return left('Please fix the validation errors to continue');
      }

      print("Inside resetPassword method");
      final res = await AuthService.resetPassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
      );

      state.setResetLoading(false);
      return res;
    } catch (e) {
      state.setResetLoading(false);
      return left('Unexpected error: $e');
    }
  }
}
