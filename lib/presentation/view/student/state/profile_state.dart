import 'package:hostel_mgmt/models/branch_model.dart';
import 'package:hostel_mgmt/models/hostels_model.dart';
import 'package:hostel_mgmt/models/student_profile.dart';
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
  // UI state for editing profile
  String? selectedHostel;
  String? selectedBranch;
  int? selectedSemester;
  String? selectedRelation;
  TextEditingController roomNoController = TextEditingController();

  void setSelectedHostel(String? value) {
    selectedHostel = value;
    notifyListeners();
  }

  void setSelectedBranch(String? value) {
    selectedBranch = value;
    selectedSemester = null;
    notifyListeners();
  }

  void setSelectedSemester(String? value) {
    selectedSemester = int.tryParse(value ?? '');
    notifyListeners();
  }

  void setSelectedRelation(String? value) {
    selectedRelation = value;
    notifyListeners();
  }

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
