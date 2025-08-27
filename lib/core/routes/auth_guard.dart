import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hostel_mgmt/core/rumtime_state/login_session.dart';

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
}
