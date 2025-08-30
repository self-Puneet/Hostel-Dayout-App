import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hostel_mgmt/models/student_profile.dart';
import '../../../services/profile_service.dart';
import 'package:hostel_mgmt/models/parent_model.dart';
import '../state/profile_state.dart';

class ProfileController {
  // Expose UI state from ProfileState
  String? get selectedHostel => state.selectedHostel;
  String? get selectedBranch => state.selectedBranch;
  int? get selectedSemester => state.selectedSemester;
  String? get selectedRelation => state.selectedRelation;
  TextEditingController get roomNoController => state.roomNoController;

  // Called when edit mode is entered
  void enterEditMode() {
    final profile = state.profile;
    print("jjjjjjjjjjjjjjj");
    print(
      state.branches.map((branch) {
        // Print branch names
        return branch.name;
      }),
    );
    if (profile != null) {
      state.roomNoController.text = profile.roomNo;
      state.selectedHostel = profile.hostelName;
      // Always set selectedBranch to branch name
      final branchName = profile.branch;
      state.selectedBranch = branchName;
      state.selectedSemester = profile.semester;
      if (profile.parents.isNotEmpty) {
        state.selectedRelation = profile.parents[0].relation;
      }
    }
    toggleEdit();
  }

  void setHostel(String? value) => state.setSelectedHostel(value);
  // value is always branch name from dropdown
  void setBranch(String? value) => state.setSelectedBranch(value);
  void setSemester(String? value) => state.setSelectedSemester(value);
  void setRelation(String? value) => state.setSelectedRelation(value);

  void onConfirm() {
    final profile = state.profile;
    if (profile == null) return;
    List<ParentModel> updatedParents = profile.parents.isNotEmpty
        ? [
            ParentModel(
              parentId: profile.parents[0].parentId,
              name: profile.parents[0].name,
              relation: state.selectedRelation ?? profile.parents[0].relation,
              phoneNo: profile.parents[0].phoneNo,
              email: profile.parents[0].email,
              languagePreference: profile.parents[0].languagePreference,
            ),
          ]
        : [];
    // selectedBranch is branch name, but StudentProfileModel expects branch name
    final updated = StudentProfileModel(
      studentId: profile.studentId,
      enrollmentNo: profile.enrollmentNo,
      name: profile.name,
      email: profile.email,
      phoneNo: profile.phoneNo,
      profilePic: profile.profilePic,
      hostelName: state.selectedHostel ?? '',
      roomNo: state.roomNoController.text,
      semester: state.selectedSemester ?? 0,
      branch: state.selectedBranch ?? '',
      parents: updatedParents,
    );
    confirmEdit(updated);
  }

  final ProfileState state;
  final ProfileService service;

  ProfileController({required this.state, required this.service});

  Future<void> initialize() async {
    state.setLoading(true);
    try {
      final hostels = await ProfileService.getAllHostelInfo();
      final branches = await ProfileService.getAllBranches();
      final profileResult = await ProfileService.getStudentProfile();

      // Handle Either for StudentApiResponse
      profileResult.fold(
        (errorMsg) {
          state.setErrored(errorMsg);
          print(errorMsg);
        },
        (apiResponse) {
          state.setProfile(apiResponse.student);
          // print(state.profile.);
        },
      );

      branches.fold(
        (errorMsg) {
          state.setErrored(errorMsg);
          print("left side of either - $errorMsg");
        },
        (apiResponse) {
          state.setBranches(
            apiResponse.branches.map((e) {
              print("Branch ID: ${e.branchId}, Name: ${e.name}");
              return e;
            }).toList(),
          );
        },
      );

      // for hostels
      hostels.fold(
        (errorMsg) {
          state.setErrored(errorMsg);
        },
        (apiResponse) {
          state.setHostels(
            apiResponse.hostels.map((e) {
              return e;
            }).toList(),
          );
        },
      );
    } catch (e) {
      state.setErrored('Failed to load profile data');
    } finally {
      state.setLoading(false);
    }
  }

  void toggleEdit() {
    state.setEditing(!state.isEditing);
    state.setValidationError(ProfileValidationError.none);
  }

  void cancelEdit(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Cancel Edit?'),
        content: Text('Your edited data will be lost.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('No'),
          ),
          TextButton(
            onPressed: () {
              state.setEditing(false);
              state.setValidationError(ProfileValidationError.none);
              Navigator.of(ctx).pop();
            },
            child: Text('Yes'),
          ),
        ],
      ),
    );
  }

  Future<void> confirmEdit(
    StudentProfileModel updatedProfile, {
    File? profilePic,
  }) async {
    final error = _validate(updatedProfile);
    if (error != ProfileValidationError.none) {
      state.setValidationError(error);
      return;
    }

    state.setLoading(true);

    try {
      final result = await ProfileService.updateProfile(
        profileData: updatedProfile.toJson(),
        profilePic: profilePic,
      );

      result.fold(
        (errorMsg) {
          print("❌ Update failed: $errorMsg");
          state.setErrored(errorMsg);
        },
        (newProfile) {
          print("✅ Profile successfully updated!");
          state.setProfile(newProfile); // use updated server response
          state.setEditing(false);
          state.setValidationError(ProfileValidationError.none);
        },
      );
    } catch (e) {
      print("❌ Exception in confirmEdit: $e");
      state.setErrored('Failed to update profile');
    } finally {
      state.setLoading(false);
    }
  }

  ProfileValidationError _validate(StudentProfileModel profile) {
    if (profile.hostelName.isEmpty) return ProfileValidationError.emptyHostel;
    if (profile.roomNo.isEmpty) return ProfileValidationError.emptyRoomNo;
    if (int.tryParse(profile.roomNo) == null ||
        int.parse(profile.roomNo) <= 0) {
      return ProfileValidationError.invalidRoomNo;
    }
    if (profile.semester <= 0) return ProfileValidationError.emptySemester;
    if (profile.branch.isEmpty) return ProfileValidationError.emptyBranch;
    if (profile.parents.isEmpty || profile.parents[0].relation.isEmpty)
      return ProfileValidationError.emptyParentRelation;
    return ProfileValidationError.none;
  }
}
