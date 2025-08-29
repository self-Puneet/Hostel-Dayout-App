import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hostel_mgmt/models/student_profile.dart';
// import '../../../models/hostels_model.dart';
import '../../../services/profile_service.dart';
import '../state/profile_state.dart';

class ProfileController {
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
        },
        (apiResponse) {
          state.setProfile(apiResponse.student);
          state.clearError();
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
