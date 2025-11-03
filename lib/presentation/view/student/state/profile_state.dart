// lib/presentation/view/profile/state/profile_state.dart
import 'package:flutter/material.dart';
import 'package:hostel_mgmt/models/student_profile.dart';

class ProfileState extends ChangeNotifier {
  // Existing fields
  StudentProfileModel? profile;
  bool isLoading = false;
  bool isErrored = false;
  String? errorMessage;

  bool isUploadingPic = false;

  // Reset password form state
  final TextEditingController oldPwC = TextEditingController();
  final TextEditingController newPwC = TextEditingController();
  final TextEditingController confirmPwC = TextEditingController();

  bool oldTouched = false;
  bool newTouched = false;
  bool confirmTouched = false;

  String? oldError;
  String? newError;
  String? confirmError;

  // Network/request loading for reset API
  bool isResetLoading = false;

  // Persisted focus nodes to avoid IME flicker on rebuild
  final FocusNode oldPwFn = FocusNode();
  final FocusNode newPwFn = FocusNode();
  final FocusNode confirmPwFn = FocusNode();

  ProfileState() {
    // Real-time validation
    oldPwC.addListener(_onAnyChanged);
    newPwC.addListener(_onAnyChanged);
    confirmPwC.addListener(_onAnyChanged);
    validateReset();
  }

  // Computed submit availability (pure validation; no loading mixed in)
  bool get canSubmitReset {
    final old = oldPwC.text.trim();
    final nw = newPwC.text.trim();
    final cnf = confirmPwC.text.trim();
    return old.isNotEmpty &&
        nw.isNotEmpty &&
        cnf.isNotEmpty &&
        nw != old &&
        cnf == nw;
  }

  void _onAnyChanged() {
    // Mark touched on first input
    if (!oldTouched && oldPwC.text.isNotEmpty) oldTouched = true;
    if (!newTouched && newPwC.text.isNotEmpty) newTouched = true;
    if (!confirmTouched && confirmPwC.text.isNotEmpty) confirmTouched = true;
    validateReset();
  }

  // Public validation (kept explicit for controller/UI triggers)
  void validateReset() {
    final old = oldPwC.text.trim();
    final nw = newPwC.text.trim();
    final cnf = confirmPwC.text.trim();

    oldError = old.isEmpty ? 'Old password is required' : null;
    newError = nw.isEmpty
        ? 'New password is required'
        : (nw == old ? 'New password must be different' : null);
    confirmError = cnf.isEmpty
        ? 'Confirm password is required'
        : (cnf != nw ? 'Passwords do not match' : null);

    notifyListeners(); // Ensure UI rebuilds
  }

  void setResetLoading(bool value) {
    isResetLoading = value;
    notifyListeners();
  }

  void resetResetForm() {
    oldPwC.clear();
    newPwC.clear();
    confirmPwC.clear();
    oldTouched = false;
    newTouched = false;
    confirmTouched = false;
    validateReset();
  }

  // Existing setters
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

  void notifyListenersAbstraction() {
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

  void clear() {
    profile = null;
    isLoading = false;
    isErrored = false;
    errorMessage = null;
    isUploadingPic = false;
    resetResetForm();
    notifyListeners();
  }

  @override
  void dispose() {
    oldPwC.dispose();
    newPwC.dispose();
    confirmPwC.dispose();
    oldPwFn.dispose();
    newPwFn.dispose();
    confirmPwFn.dispose();
    super.dispose();
  }
}
