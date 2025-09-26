// lib/presentation/view/profile/state/profile_state.dart
import 'package:flutter/material.dart';
import 'package:hostel_mgmt/models/student_profile.dart';

class ProfileState extends ChangeNotifier {
  StudentProfileModel? profile;
  bool isLoading = false;
  bool isErrored = false;
  String? errorMessage;

  bool isUploadingPic = false;

  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void setUploadingPic(bool value) {
    isUploadingPic = value;
    notifyListeners();
  }

  void setErrored(String message) {
    isErrored = true;
    errorMessage = message;
    notifyListeners();
  }

  void clearError() {
    isErrored = false;
    errorMessage = null;
    notifyListeners();
  }

  void setProfile(StudentProfileModel p) {
    profile = p;
    notifyListeners();
  }

  void setProfilePic(String url) {
    if (profile != null) {
      profile = profile!.copyWith(profilePic: url);
      notifyListeners();
    }
  }
}
