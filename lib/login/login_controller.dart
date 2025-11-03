import 'package:flutter/material.dart';
import 'package:hostel_mgmt/core/helpers/app_snackbar.dart';
import 'package:hostel_mgmt/core/enums/ui_eums/snackbar_type.dart';
import 'package:hostel_mgmt/core/routes/app_route_constants.dart';
import 'package:hostel_mgmt/models/student_profile.dart';
import 'package:hostel_mgmt/services/auth_service.dart';
import 'package:hostel_mgmt/login/login_state.dart';
import 'package:hostel_mgmt/core/enums/timeline_actor.dart';
import 'package:get/get.dart';
import 'package:hostel_mgmt/core/rumtime_state/login_session.dart';
import 'package:go_router/go_router.dart';
import 'package:hostel_mgmt/services/profile_service.dart';

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

  Future<StudentProfileModel> fetchProfile() async {
    try {
      final profileResult = await ProfileService.getStudentProfile();
      return profileResult.fold(
        (error) {
          debugPrint('Profile error: $error');
          throw Exception(
            'Failed to load profile: $error',
          ); // propagate failure
        },
        (apiResponse) {
          return apiResponse.student; // properly return student here
        },
      );
    } catch (e) {
      debugPrint('Profile fetch exception: $e');
      throw Exception('Exception during profile fetch: $e');
    }
  }

  Future<void> login(BuildContext context, TimelineActor actor) async {
    state.setLoggingIn(true);

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
      switch (actor) {
        case TimelineActor.student:
          final result = await AuthService.loginStudent(
            enrollmentNo: identity,
            password: verification,
          );
          result.fold(
            (error) {
              state.setLoggingIn(false);
              AppSnackBar.show(
                context,
                message: error,
                type: AppSnackBarType.error,
                icon: LoginSnackBarType.loginFailed.icon,
              );
            },
            (session) async {
              final diSession = Get.find<LoginSession>();
              diSession.token = session.token;
              await diSession.saveToPrefs();
              final profile = await fetchProfile();
              print(profile.profilePic);
              print("--------------------");
              diSession.username = session.username;
              diSession.identityId = session.identityId;
              diSession.role = session.role;
              diSession.imageURL = profile.profilePic;
              diSession.roomNo = profile.roomNo;
              diSession.hostels = [
                HostelInfo(
                  hostelId: profile.hostelName,
                  hostelName: profile.hostelName,
                ),
              ];

              await diSession.saveToPrefs();
              print(diSession.roomNo);
              state.setLoggingIn(false);
              GoRouter.of(context).go(AppRoutes.studentHome);
              AppSnackBar.show(
                context,
                message: LoginSnackBarType.success.message,
                type: AppSnackBarType.success,
                icon: LoginSnackBarType.success.icon,
              );
            },
          );
          break;
        case TimelineActor.assistentWarden || TimelineActor.seniorWarden:
          {
            final fields = state.textFieldMap[TimelineActor.assistentWarden]!;
            final identity =
                (fields[FieldsType.identityField] as TextEditingController).text
                    .trim();
            final verification =
                (fields[FieldsType.verificationField] as TextEditingController)
                    .text
                    .trim();

            final role = state.selectedWardenRole; // assistant by default

            final result = await AuthService.loginWarden(
              empId: identity,
              password: verification,
              actor: role,
            );

            result.fold(
              (error) {
                state.setLoggingIn(false);
                AppSnackBar.show(
                  context,
                  message: error,
                  type: AppSnackBarType.error,
                  icon: LoginSnackBarType.loginFailed.icon,
                );
              },
              (session) async {
                state.setLoggingIn(false);
                // Prefer routing by 'role' (known) instead of relying on session.role
                GoRouter.of(context).go(
                  role == TimelineActor.assistentWarden
                      ? AppRoutes.wardenHome
                      : AppRoutes.wardenHome,
                );
                AppSnackBar.show(
                  context,
                  message: LoginSnackBarType.success.message,
                  type: AppSnackBarType.success,
                  icon: LoginSnackBarType.success.icon,
                );
              },
            );
            break;
          }

        case TimelineActor.parent:
          final result = await AuthService.loginParent(
            phoneNo: verification,
            enrollmentNo: identity,
          );

          result.fold(
            (error) {
              state.setLoggingIn(false);
              AppSnackBar.show(
                context,
                message: error,
                type: AppSnackBarType.error,
                icon: LoginSnackBarType.loginFailed.icon,
              );
            },
            (profile) async {
              state.setLoggingIn(false);

              GoRouter.of(context).go(AppRoutes.parentHome);

              AppSnackBar.show(
                context,
                message: LoginSnackBarType.success.message,
                type: AppSnackBarType.success,
                icon: LoginSnackBarType.success.icon,
              );
            },
          );
          break;

        default:
          state.setLoggingIn(false);
          AppSnackBar.show(
            context,
            message: "Login for this actor is not implemented yet.",
            type: AppSnackBarType.info,
            icon: Icons.info,
          );
          break;
      }
    } catch (e) {
      state.setLoggingIn(false);
      String errorMessage = e.toString();
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
    Get.find<LoginSession>().clearPrefs();
    // go navigation to login screen
    GoRouter.of(context).go(AppRoutes.login);
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

  static void doResetPassword(BuildContext context, TimelineActor actor) async {
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

    // Call the doResetPassword service method.
    final result = await AuthService.resetPassword(
      oldPassword: "MP8XS0GJRE",
      newPassword: "test",
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
