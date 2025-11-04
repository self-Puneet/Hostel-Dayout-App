// presentation/view/student/controllers/request_form_controller.dart
import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
import 'package:hostel_mgmt/core/enums/enum.dart';
import 'package:hostel_mgmt/core/helpers/app_snackbar.dart';
// import 'package:hostel_mgmt/core/routes/app_route_constants.dart';
// import 'package:hostel_mgmt/core/routes/app_transition_page.dart';
// import 'package:hostel_mgmt/core/routes/go_router_extensions.dart';
import 'package:hostel_mgmt/login/login_controller.dart';
import 'package:hostel_mgmt/models/restriction_window.dart';
import 'package:hostel_mgmt/services/profile_service.dart';
import 'package:hostel_mgmt/services/request_service.dart';
import '../../../../core/enums/ui_eums/snackbar_type.dart';
import '../state/request_form_state.dart';
import 'package:timezone/timezone.dart' as tz;

class RequestFormController {
  final RequestFormState state;
  final BuildContext context;

  RequestFormController({required this.state, required this.context});
  bool _bootstrapped = false; // NEW

  // NEW: call this after first frame only
  void ensureBootstrapped() {
    if (_bootstrapped) return;
    _bootstrapped = true;
    loadRestriction();
  }

  Future<void> loadRestriction() async {
    // Silent bootstrap: if we’re at the initial state (already loading & no data),
    // skip notifying here to avoid “during build” notifies.
    final isInitialBootstrap =
        state.restrictionWindow == null && state.isLoadingRestriction == true;

    if (!isInitialBootstrap) {
      state.setRestrictionLoading(true); // this one can notify safely later
    }
    try {
      final result = await ProfileService.getHostelInfo();
      result.fold(
        (error) {
          state.setRestrictionWindow(
            RestrictionWindow(
              errroLoading: true,
              allowedToday: false,
              minTime: const TimeOfDay(hour: 0, minute: 0),
              maxTime: const TimeOfDay(hour: 0, minute: 0),
              timezone: "Asia/Kolkata",
              note: "Unable to load outing rules.",
            ),
          );
        },
        (hostelResponse) {
          state.setRestrictionWindow(
            hostelResponse.hostel.toRestrictionWindow(),
          );
        },
      );
    } catch (_) {
      state.setRestrictionWindow(
        RestrictionWindow(
          errroLoading: true,
          allowedToday: false,
          minTime: const TimeOfDay(hour: 0, minute: 0),
          maxTime: const TimeOfDay(hour: 0, minute: 0),
          timezone: "Asia/Kolkata",
          note: "Network error while loading rules.",
        ),
      );
    }
  }

  // Optional helper to bootstrap
  void bootstrapAfterFirstFrame() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Only run once
      if (state.restrictionWindow == null && state.isLoadingRestriction) {
        loadRestriction();
      }
    });
  }

  Future<void> submit() async {
    state.validateAndMarkSubmitted();
    if (!state.canSubmit) {
      _showSnackBar('Please fix the errors');
      return;
    }

    // Build payload using current selection
    final bool isDayout = state.isDayout;
    final DateTime from = isDayout
        ? DateTime(
            state.dayoutDate!.year,
            state.dayoutDate!.month,
            state.dayoutDate!.day,
            state.dayoutFromTime!.hour,
            state.dayoutFromTime!.minute,
          )
        : DateTime(
            state.leaveFromDate!.year,
            state.leaveFromDate!.month,
            state.leaveFromDate!.day,
            (state.leaveFromTime ?? const TimeOfDay(hour: 0, minute: 0)).hour,
            (state.leaveFromTime ?? const TimeOfDay(hour: 0, minute: 0)).minute,
          );

    final DateTime to = isDayout
        ? DateTime(
            state.dayoutDate!.year,
            state.dayoutDate!.month,
            state.dayoutDate!.day,
            state.dayoutToTime!.hour,
            state.dayoutToTime!.minute,
          )
        : DateTime(
            (state.leaveToDate ?? state.leaveFromDate!).year,
            (state.leaveToDate ?? state.leaveFromDate!).month,
            (state.leaveToDate ?? state.leaveFromDate!).day,
            (state.leaveToTime ?? const TimeOfDay(hour: 23, minute: 59)).hour,
            (state.leaveToTime ?? const TimeOfDay(hour: 23, minute: 59)).minute,
          );
    String isoInIST(DateTime dt) {
      final kolkata = tz.getLocation('Asia/Kolkata');
      final ist = tz.TZDateTime.from(dt, kolkata);
      final base = ist.toIso8601String().split('.').first; // local form
      final off = ist.timeZoneOffset; // +05:30 for IST
      final sign = off.isNegative ? '-' : '+';
      final hh = off.inHours.abs().toString().padLeft(2, '0');
      final mm = (off.inMinutes.abs() % 60).toString().padLeft(2, '0');
      return '$base$sign$hh:$mm';
    }

    final payload = <String, dynamic>{
      'request_type': _mapRequestType(state.requestType),
      // 'applied_from': from.toUtc().toIso8601String().split('.').first + 'Z',
      // 'applied_to': to.toUtc().toIso8601String().split('.').first + 'Z',
      'applied_from': isoInIST(from),
      'applied_to': isoInIST(to),

      'reason': state.reason.trim(),
    };

    state.setSubmitting(true);
    try {
      final result = await RequestService.createRequest(requestData: payload);
      result.fold((err) => _showSnackBar(err.toString()), (_) {
        _showSnackBar('Request submitted successfully!');
        AppSnackBar.show(
          context,
          message: "Request Submitted Successfully",
          type: AppSnackBarType.success,
          icon: LoginSnackBarType.success.icon,
        );
        // print("hereherehereherehereherehereherehere");
        // context.goIfNotCurrent(AppRoutes.studentHome, extra: SlideFrom.left);
      });
    } catch (_) {
      AppSnackBar.show(
        context,
        message: "Something went wrong.",
        type: AppSnackBarType.error,
        icon: LoginSnackBarType.loginFailed.icon,
      );
    } finally {
      state.setSubmitting(false);
    }
  }

  // RequestFormController.fetchProfile
  // Future<void> fetchProfile() async {
  //   state.setProfileLoading(true); // notifies start of load [OK]
  //   try {
  //     final profileResult = await ProfileService.getStudentProfile();
  //     profileResult.fold(
  //       (error) {
  //         debugPrint('Profile error: $error');
  //         state.setProfileError(); // notifies end of load (error)
  //       },
  //       (apiResponse) {
  //         state.setProfile(apiResponse.student); // notifies with data
  //       },
  //     );
  //   } catch (e) {
  //     debugPrint('Profile fetch exception: $e');
  //     state.setProfileError(); // notifies end of load (exception)
  //   } finally {
  //     // If profile already set above, this keeps idempotent; cheap re-notify is fine
  //     if (state.isProfileLoading) state.setProfileLoading(false);
  //   }
  // }

  void _showSnackBar(String message) {
    AppSnackBar.show(
      context,
      message: "Request Submitted Successfully",
      type: AppSnackBarType.success,
      icon: LoginSnackBarType.success.icon,
    );
  }

  String _mapRequestType(RequestType t) {
    // Map to API types as needed
    return t == RequestType.dayout ? 'outing' : 'leave';
  }
}
