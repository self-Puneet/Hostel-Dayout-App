import 'package:flutter/material.dart';
import 'models.dart';
import 'profile_service.dart';
import 'profile_state.dart';

class ProfileController {
  final ProfileState state;
  final ProfileService service;

  ProfileController({required this.state, required this.service});

  Future<void> initialize() async {
    state.setLoading(true);
    try {
      final hostels = await service.fetchHostels();
      final branches = await service.fetchBranches();
      final profile = await service.fetchProfile();
      state.setHostels(hostels);
      state.setBranches(branches);
      state.setProfile(profile);
      state.clearError();
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

  Future<void> confirmEdit(StudentProfileModel updatedProfile) async {
    final error = _validate(updatedProfile);
    if (error != ProfileValidationError.none) {
      state.setValidationError(error);
      return;
    }
    state.setLoading(true);
    try {
      await service.updateProfile(updatedProfile);
      state.setProfile(updatedProfile);
      state.setEditing(false);
      state.setValidationError(ProfileValidationError.none);
    } catch (e) {
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
    if (profile.parent.relation.isEmpty)
      return ProfileValidationError.emptyParentRelation;
    return ProfileValidationError.none;
  }
}
