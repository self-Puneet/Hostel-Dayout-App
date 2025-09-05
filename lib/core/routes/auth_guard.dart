import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hostel_mgmt/core/rumtime_state/login_session.dart';
import 'package:hostel_mgmt/core/enums/timeline_actor.dart';

class LoginGuard extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final session = Get.find<LoginSession>();
    if (session.token.isEmpty || !session.isValid) {
      // Not logged in, redirect to login
      return const RouteSettings(name: '/login');
    }
    // Logged in, allow navigation
    return null;
  }

  /// Route to the first page based on the actor in the login session
  static void routeToHomeByActor() {
    final session = Get.find<LoginSession>();
    switch (session.role) {
      case TimelineActor.student:
        Get.offAllNamed('/home');
        break;
      case TimelineActor.assistentWarden:
        Get.offAllNamed('/warden/home');
        break;
      case TimelineActor.seniorWarden:
        Get.offAllNamed('/senior-warden/home');
        break;
      case TimelineActor.parent:
        Get.offAllNamed('/parent/home');
        break;
      case TimelineActor.security:
        Get.offAllNamed('/security/home');
        break;
    }
  }
}
