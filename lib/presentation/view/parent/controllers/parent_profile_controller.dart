import 'dart:io';
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
}
