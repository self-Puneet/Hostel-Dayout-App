// lib/presentation/view/warden_profile/state/warden_profile_state.dart
import 'package:flutter/material.dart';
import 'package:hostel_mgmt/models/warden_model.dart';

class WardenProfileState extends ChangeNotifier {
  // Data
  WardenModel? profile;

  // Generic status
  bool isLoading = false;
  bool isErrored = false;
  String? errorMessage;

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

  // Reset password request loading
  bool isResetLoading = false;

  // Focus nodes
  final FocusNode oldPwFn = FocusNode();
  final FocusNode newPwFn = FocusNode();
  final FocusNode confirmPwFn = FocusNode();

  WardenProfileState() {
    oldPwC.addListener(_onAnyChanged);
    newPwC.addListener(_onAnyChanged);
    confirmPwC.addListener(_onAnyChanged);
    validateReset();
  }

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
    if (!oldTouched && oldPwC.text.isNotEmpty) oldTouched = true;
    if (!newTouched && newPwC.text.isNotEmpty) newTouched = true;
    if (!confirmTouched && confirmPwC.text.isNotEmpty) confirmTouched = true;
    validateReset();
  }

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

    notifyListeners();
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

  // Generic setters
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

  void setProfile(WardenModel p) {
    profile = p;
    notifyListeners();
  }

  void clear() {
    profile = null;
    isLoading = false;
    isErrored = false;
    errorMessage = null;
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
