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
