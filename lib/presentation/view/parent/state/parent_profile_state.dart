// lib/presentation/view/profile/state/profile_state.dart
import 'package:flutter/material.dart';
import 'package:hostel_mgmt/models/parent_model.dart';
import 'package:hostel_mgmt/models/student_profile.dart';

class ParentProfileState extends ChangeNotifier {
  List<StudentProfileModel> studentProfileModel = [];
  ParentModel? parentModel;

  bool isLoading = false;
  bool isErrored = false;
  String? errorMessage;

  bool isUploadingPic = false;

  // Loading
  void setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  // Uploading avatar
  void setUploadingPic(bool value) {
    isUploadingPic = value;
    notifyListeners();
  }

  // Error handling
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

  // Profile updates
  // lib/presentation/view/profile/state/parent_profile_state.dart
  void setProfile({
    required List<StudentProfileModel> studentProfile,
    ParentModel? parentProfile,
  }) {
    studentProfileModel = studentProfile; // set the student model
    parentModel =
        parentProfile ?? parentModel; // FIX: write to the field, not the param
    isErrored = false; // clear error on successful data
    errorMessage = null;
    notifyListeners(); // notify UI
  }

  // void setProfilePic(String url) {
  //   if (parentModel != null) {
  //     parentModel = parentModel!.copyWith(profilePic: url);
  //     notifyListeners();
  //   }
  // }
}
