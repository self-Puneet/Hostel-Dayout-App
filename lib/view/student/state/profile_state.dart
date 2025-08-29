import 'package:hostel_mgmt/models/branch_model.dart';
import 'package:hostel_mgmt/models/student_profile.dart';

import '../../../models/hostels_model.dart';
import 'package:flutter/material.dart';

enum ProfileValidationError {
  none,
  emptyHostel,
  emptyRoomNo,
  invalidRoomNo,
  emptySemester,
  emptyBranch,
  emptyParentRelation,
}

class ProfileState extends ChangeNotifier {
  StudentProfileModel? profile;
  List<HostelModel> hostels = [];
  List<BranchModel> branches = [];
  bool isEditing = false;
  bool isLoading = false;
  String? errorMessage;
  bool isErrored = false;
  ProfileValidationError validationError = ProfileValidationError.none;

  void setLoading(bool value) {
    isLoading = value;
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

  void setHostels(List<HostelModel> h) {
    hostels = h;
    notifyListeners();
  }

  void setBranches(List<BranchModel> b) {
    branches = b;
    notifyListeners();
  }

  void setEditing(bool value) {
    isEditing = value;
    notifyListeners();
  }

  void setValidationError(ProfileValidationError error) {
    validationError = error;
    notifyListeners();
  }
}
