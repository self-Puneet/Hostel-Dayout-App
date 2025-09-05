// app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import 'package:hostel_mgmt/core/rumtime_state/login_session.dart';
import 'package:hostel_mgmt/login/login_layout.dart';
import 'package:hostel_mgmt/presentation/view/student/pages/request_page.dart';
import '../../presentation/view/student/pages/pages.dart';

// Helper for route guards
String? _requireAuthRedirect(BuildContext context, GoRouterState state) {
  final session = Get.find<LoginSession>();
  if (session.token.isEmpty || !session.isValid) {
    return '/login';
  }
  return null;
}

class AppRouter {
  static GoRouter build() {
    return GoRouter(
      initialLocation: '/home',
      redirect: (context, state) {
        final session = Get.find<LoginSession>();
        final isLoggedIn = session.token.isNotEmpty && session.isValid;
        final goingToLogin = state.matchedLocation == '/login';

        if (!isLoggedIn && !goingToLogin) {
          return '/login';
        }
        if (isLoggedIn && goingToLogin) {
          return '/home';
        }
        return null;
      },
      routes: [

        GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) => const LoginLayout(),
        ),

        ShellRoute(
          builder: (context, state, child) {
            return StudentLayout(child: child);
          },
          routes: [
            GoRoute(
              path: '/home',
              name: 'home',
              builder: (context, state) => const HomePage(),
              redirect: _requireAuthRedirect,
            ),
            GoRoute(
              path: '/history',
              name: 'history',
              builder: (context, state) => const HistoryPage(),
              redirect: _requireAuthRedirect,
            ),

            GoRoute(
              path: '/request',
              name: 'request',
              builder: (context, state) => const RequestFormPage(),
              redirect: _requireAuthRedirect,
              routes: [
                GoRoute(
                  path: ':id',
                  name: 'request-detail',
                  builder: (context, state) {
                    final requestId = state.pathParameters['id'] ?? '';
                    final role = Get.find<LoginSession>().role;
                    return RequestPage(actor: role, requestId: requestId);
                  },
                  redirect: _requireAuthRedirect,
                ),
              ],
            ),
            GoRoute(
              path: '/profile',
              name: 'profile',
              builder: (context, state) => const ProfilePage(),
              redirect: _requireAuthRedirect,
            ),
          ],
        ),
      ],
    );
  }
}
