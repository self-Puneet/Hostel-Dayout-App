import 'package:flutter/material.dart';
import 'package:hostel_mgmt/core/enums/timeline_actor.dart';
import 'package:hostel_mgmt/login/login_page_model.dart';

enum FieldsType { identityField, verificationField, model }

class LoginState extends ChangeNotifier with WidgetsBindingObserver {
  // Warden type selection state
  String _wardenType = 'assistant'; // 'assistant' or 'senior'
  String get wardenType => _wardenType;
  void setWardenType(String value) {
    if (_wardenType != value) {
      _wardenType = value;
      print(_wardenType);
      notifyListeners();
    }
  }

  LoginState() {
    WidgetsBinding.instance.addObserver(this);
  }
  final Map<TimelineActor, Map<FieldsType, dynamic>> textFieldMap = {
    TimelineActor.parent: {
      FieldsType.model: LoginPageModel(
        loginTitle: "Parent Login",
        identityFieldName: "Enrollment Number",
        verificationFieldName: "Phone Number",
        elevatedButtonText: "Login as Student",
        disabledButtonText: "Logging in ...",
        identityFieldIconData: Icons.school,
        verificationFieldIconData: Icons.phone,
        showForgotPassword: false,
        showResetPassword: false,
      ),
      FieldsType.identityField: TextEditingController(),
      FieldsType.verificationField: TextEditingController(),
    },
    TimelineActor.student: {
      FieldsType.model: LoginPageModel(
        loginTitle: "Login as Student",
        identityFieldName: "Enrollment Number",
        verificationFieldName: "Password",
        elevatedButtonText: "Login as Student",
        disabledButtonText: "Logging in ...",
        identityFieldIconData: Icons.school,
        verificationFieldIconData: Icons.lock_outline,
      ),
      FieldsType.identityField: TextEditingController(),
      FieldsType.verificationField: TextEditingController(),
    },
    TimelineActor.assistentWarden: {
      FieldsType.model: LoginPageModel(
        loginTitle: "Warden Login",
        identityFieldName: "Employee ID",
        verificationFieldName: "Password",
        elevatedButtonText: "Login as Warden",
        disabledButtonText: "Logging in ...",
        identityFieldIconData: Icons.badge,
        verificationFieldIconData: Icons.lock_outline,
      ),
      FieldsType.identityField: TextEditingController(),
      FieldsType.verificationField: TextEditingController(),
    },
  };

  bool _isLoggingIn = false;
  bool _isKeyboardOpen = false;

  bool get isLoggingIn => _isLoggingIn;
  bool get isKeyboardOpen => _isKeyboardOpen;
  dynamic get model => textFieldMap;

  void setLoggingIn(bool value) {
    _isLoggingIn = value;
    notifyListeners();
  }

  void setKeyboardOpen(bool value) {
    _isKeyboardOpen = value;
    notifyListeners();
  }

  @override
  void dispose() {
    for (final fieldMap in textFieldMap.values) {
      for (final controller in fieldMap.values) {
        controller.dispose();
      }
    }
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    final isOpen = bottomInset > 0;
    if (isOpen != _isKeyboardOpen) {
      _isKeyboardOpen = isOpen;
      notifyListeners();
    }
  }
}
