// app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hostel_mgmt/core/routes/auth_guard.dart';
import 'package:hostel_mgmt/login/login_form.dart';
import 'package:hostel_mgmt/login/login_layout.dart';
import 'package:hostel_mgmt/view/student/pages/student_layout.dart';
import 'package:provider/provider.dart';

class AppRouter {
  static GoRouter build(LoginState auth) {
    return GoRouter(
      initialLocation: '/request',
      // Rebuild/reevaluate redirects when auth state changes
      refreshListenable: auth,
      // Global auth guard
      redirect: (context, state) {
        final bool isLoggedIn = auth.isLoggedIn;
        final bool isLoading = auth.isLoading;
        final bool goingToLogin = state.matchedLocation == '/login';

        // Don’t redirect during auth loading (e.g., splash/progress)
        if (isLoading) return null;

        // Not logged in: only allow /login
        if (!isLoggedIn) return goingToLogin ? null : '/login';

        // Logged in: avoid staying on /login
        if (isLoggedIn && goingToLogin) return '/request';

        // No redirect
        return null;
      },
      routes: [
        GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) => const LoginLayout(),
        ),
        GoRoute(
          path: '/request',
          name: 'request',
          builder: (context, state) => const StudentLayout(),
        ),
      ],
    );
  }
}
