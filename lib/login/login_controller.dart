import 'package:flutter/material.dart';
import 'package:hostel_mgmt/core/helpers/app_snackbar.dart';
import 'package:hostel_mgmt/core/enums/ui_eums/snackbar_type.dart';
import 'package:hostel_mgmt/services/auth_service.dart';
import 'package:hostel_mgmt/login/login_state.dart';
import 'package:hostel_mgmt/core/enums/timeline_actor.dart';
import 'package:get/get.dart';
import 'package:hostel_mgmt/core/rumtime_state/login_session.dart';
import 'package:go_router/go_router.dart';

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
        state.textFieldMap[actor]?[FieldsType.verificationField]?.text.trim() ??
        "";

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
      Map<String, dynamic>? result;
      if (actor == TimelineActor.student) {
        print(identity);
        print(verification);
        result = await StudentAuthService.loginStudent(
          enrollmentNo: identity,
          password: verification,
        );
      } else {
        // TODO: Implement other actor logins
        throw Exception("Unsupported actor type");
      }

      // Handle null or missing token
      if (result == null || (result['token'] ?? '').toString().isEmpty) {
        state.setLoggingIn(false);
        final backendMsg = result?['message'] ?? result?['error'];
        AppSnackBar.show(
          context,
          message: backendMsg ?? LoginSnackBarType.loginFailed.message,
          type: AppSnackBarType.error,
          icon: LoginSnackBarType.loginFailed.icon,
        );
        return;
      }

      // ✅ Update DI LoginSession
      final session = Get.find<LoginSession>();
      session.token = result['token'] ?? '';
      session.username = result['name'] ?? '';
      session.identityId = result['enrollment_no'] ?? '';
      session.role = actor;
      session.imageURL = result['imageURL'];
      await session.saveToPrefs();

      state.setLoggingIn(false);

      GoRouter.of(context).go('/home');
      AppSnackBar.show(
        context,
        message: result['message'] ?? LoginSnackBarType.success.message,
        type: AppSnackBarType.success,
        icon: LoginSnackBarType.success.icon,
      );

      // TODO: Navigate to home page (based on actor)
    } catch (e) {
      state.setLoggingIn(false);

      String errorMessage = e.toString();
      // try to extract backend error if StudentAuthService throws response body
      if (errorMessage.contains("Exception:")) {
        errorMessage = errorMessage.replaceFirst("Exception:", "").trim();
      }

      AppSnackBar.show(
        context,
        message: errorMessage.isNotEmpty
            ? errorMessage
            : LoginSnackBarType.loginFailed.message,
        type: AppSnackBarType.error,
        icon: LoginSnackBarType.loginFailed.icon,
      );
    }
  }

  /// Logout service
  static Future<void> logout(BuildContext context) async {
    LoginSession.clearPrefs();
    // go navigation to login screen
    GoRouter.of(context).go('/login');
    AppSnackBar.show(
      context,
      message: "Logged out successfully.",
      type: AppSnackBarType.success,
    );
  }

  void forgotPassword(BuildContext context, TimelineActor actor) {
    AppSnackBar.show(
      context,
      message: "Forgot Password pressed for ${actor.name}",
      type: AppSnackBarType.info,
      icon: Icons.info,
    );
  }

  static void resetPassword(BuildContext context, TimelineActor actor) async {
    // Retrieve the old and new passwords from text fields.
    // Adjust the field keys as appropriate for your UI.
    // final oldPassword = state.textFieldMap[actor]?[FieldsType.identityField]?.text.trim() ?? "";
    // final newPassword = state.textFieldMap[actor]?[FieldsType.verificationField]?.text.trim() ?? "";

    // if (oldPassword.isEmpty || newPassword.isEmpty) {
    //   AppSnackBar.show(
    //     context,
    //     message: "Please enter both your old and new passwords.",
    //     type: AppSnackBarType.alert,
    //     icon: Icons.warning,
    //   );
    //   return;
    // }

    // Get the current session token
    final session = Get.find<LoginSession>();
    final token = session.token;
    if (token.isEmpty) {
      AppSnackBar.show(
        context,
        message: "User is not authenticated.",
        type: AppSnackBarType.error,
        icon: Icons.error,
      );
      return;
    }

    // Call the resetPassword service method.
    final result = await StudentAuthService.resetPassword(
      oldPassword: "MP8XS0GJRE",
      newPassword: "test",
      token: token,
    );

    // Handle the result using functional Either style.
    result.fold(
      (error) {
        AppSnackBar.show(
          context,
          message: error,
          type: AppSnackBarType.error,
          icon: Icons.error,
        );
      },
      (success) {
        if (success) {
          AppSnackBar.show(
            context,
            message: "Password reset successful.",
            type: AppSnackBarType.success,
            icon: Icons.check,
          );
        } else {
          AppSnackBar.show(
            context,
            message: "Password reset failed.",
            type: AppSnackBarType.error,
            icon: Icons.error,
          );
        }
      },
    );
  }
}
