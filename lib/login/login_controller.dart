import 'package:flutter/material.dart';
import 'package:hostel_mgmt/core/helpers/app_snackbar.dart';
import 'package:hostel_mgmt/core/enums/ui_eums/snackbar_type.dart';
import 'package:hostel_mgmt/services/auth_service.dart';
import 'package:hostel_mgmt/login/login_state.dart';
import 'package:hostel_mgmt/core/enums/timeline_actor.dart';

enum LoginSnackBarType {
  emptyFields,
  loginFailed,
  incorrectCredentials,
  success,
}

extension LoginSnackBarTypeExtension on LoginSnackBarType {
  String get message {
    switch (this) {
      case LoginSnackBarType.emptyFields:
        return "Please fill in all fields.";
      case LoginSnackBarType.loginFailed:
        return "Login failed. Please try again.";
      case LoginSnackBarType.incorrectCredentials:
        return "Incorrect credentials. Please check your details.";
      case LoginSnackBarType.success:
        return "Login successful!";
    }
  }

  IconData get icon {
    switch (this) {
      case LoginSnackBarType.emptyFields:
        return Icons.warning;
      case LoginSnackBarType.loginFailed:
        return Icons.error;
      case LoginSnackBarType.incorrectCredentials:
        return Icons.error;
      case LoginSnackBarType.success:
        return Icons.check;
    }
  }
}

class LoginController {
  final LoginState state;

  LoginController(this.state);

  Future<void> login(BuildContext context, TimelineActor actor) async {
    state.setLoggingIn(true);
    await Future.delayed(const Duration(milliseconds: 500));

    final identity =
        state.textFieldMap[actor]?[FieldsType.identityField]?.text.trim() ?? "";
    final verification =
        state.textFieldMap[actor]?[FieldsType.verificationField]?.text.trim() ?? "";

    if (identity.isEmpty || verification.isEmpty) {
      state.setLoggingIn(false);
      AppSnackBar.show(
        context,
        message: LoginSnackBarType.emptyFields.message,
        type: AppSnackBarType.alert,
        icon: LoginSnackBarType.emptyFields.icon,
      );
      return;
    }

    try {
      // ✅ AuthService now returns & saves LoginSession internally
      await AuthService.login(identity, verification, actor);

      state.setLoggingIn(false);
      AppSnackBar.show(
        context,
        message: LoginSnackBarType.success.message,
        type: AppSnackBarType.success,
        icon: LoginSnackBarType.success.icon,
      );

      // TODO: Navigate to home page (based on actor)
    } catch (e) {
      state.setLoggingIn(false);
      AppSnackBar.show(
        context,
        message: LoginSnackBarType.loginFailed.message,
        type: AppSnackBarType.error,
        icon: LoginSnackBarType.loginFailed.icon,
      );
    }
  }

  void forgotPassword(BuildContext context, TimelineActor actor) {
    AppSnackBar.show(
      context,
      message: "Forgot Password pressed for ${actor.name}",
      type: AppSnackBarType.info,
      icon: Icons.info,
    );
  }

  void resetPassword(BuildContext context, TimelineActor actor) {
    AppSnackBar.show(
      context,
      message: "Reset Password pressed for ${actor.name}",
      type: AppSnackBarType.info,
      icon: Icons.info,
    );
  }
}
