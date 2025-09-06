// app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import 'package:hostel_mgmt/core/enums/enum.dart';
import 'package:hostel_mgmt/core/routes/app_route_constants.dart';
import 'package:hostel_mgmt/core/rumtime_state/login_session.dart';
import 'package:hostel_mgmt/login/login_layout.dart';
import 'package:hostel_mgmt/presentation/view/student/pages/request_page.dart';
import '../../presentation/view/student/pages/pages.dart';

// Helper for route guards
String? _requireAuthRedirect(BuildContext context, GoRouterState state) {
  final session = Get.find<LoginSession>();
  if (session.token.isEmpty || !session.isValid) {
    return AppRoutes.login;
  }
  switch (session.role) {
    case TimelineActor.student:
      return AppRoutes.studentHome;
    case TimelineActor.assistentWarden:
      return AppRoutes.wardenHome;
    case TimelineActor.seniorWarden:
      return AppRoutes.seniorWardenHome;
    case TimelineActor.parent:
      return AppRoutes.parentHome;
    default:
      return AppRoutes.login;
  }
}

class AppRouter {
  static GoRouter build() {
    return GoRouter(
      initialLocation: AppRoutes.studentHome,
      redirect: (context, state) {
        return _requireAuthRedirect(context, state);
      },
      routes: [
        GoRoute(
          path: AppRoutes.login,
          name: 'login',
          builder: (context, state) => const LoginLayout(),
        ),
        ShellRoute(
          builder: (context, state, child) {
            return StudentLayout(child: child);
          },
          routes: [
            GoRoute(
              path: AppRoutes.studentHome,
              name: 'home',
              builder: (context, state) => const HomePage(),
              redirect: _requireAuthRedirect,
            ),
            GoRoute(
              path: AppRoutes.history,
              name: 'history',
              builder: (context, state) => const HistoryPage(),
              redirect: _requireAuthRedirect,
            ),
            GoRoute(
              path: AppRoutes.requestForm,
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
              path: AppRoutes.profile,
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
