// app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import 'package:hostel_mgmt/core/enums/enum.dart';
import 'package:hostel_mgmt/core/routes/app_route_constants.dart';
import 'package:hostel_mgmt/core/routes/app_transition_page.dart'; // 👈 import here
import 'package:hostel_mgmt/core/rumtime_state/login_session.dart';
import 'package:hostel_mgmt/login/login_layout.dart';
import 'package:hostel_mgmt/presentation/view/parent/pages/parent_home.dart';
import 'package:hostel_mgmt/presentation/view/parent/pages/parent_layout.dart';
import 'package:hostel_mgmt/presentation/view/parent/pages/parent_profile_page.dart';
import 'package:hostel_mgmt/presentation/view/parent/state/parent_state.dart';
import 'package:hostel_mgmt/presentation/view/student/pages/request_page.dart';
import 'package:hostel_mgmt/presentation/view/warden/pages/warden_home.dart';
import 'package:hostel_mgmt/presentation/view/warden/pages/warden_layout.dart';
import 'package:hostel_mgmt/presentation/view/warden/state/warden_home_state.dart';
import 'package:hostel_mgmt/presentation/view/warden/state/warden_profile_state.dart';
import 'package:provider/provider.dart';
import '../../presentation/view/student/pages/pages.dart';

/// Helper for route guards
String? _requireAuthRedirect(BuildContext context, GoRouterState state) {
  final session = Get.find<LoginSession>();

  // Not logged in → go to login
  if (session.token.isEmpty || !session.isValid) {
    return AppRoutes.login;
  }

  final allowedRoutes = AppRoutes.routeAllowence[session.role] ?? [];
  // print("aaah" * 90);
  // print(state.matchedLocation);
  // print(
  //   allowedRoutes.any((allowed) => state.matchedLocation.startsWith(allowed)),
  // );
  // Already on allowed route → no redirect
  if (allowedRoutes.any(
    (allowed) => state.matchedLocation.startsWith(allowed),
  )) {
    return null;
  }

  // Otherwise, redirect user to home based on role
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

String? _initialRoute() {
  final session = Get.find<LoginSession>();

  // Not logged in → go to login
  if (session.token.isEmpty || !session.isValid) {
    return AppRoutes.login;
  }

  final role = session.role;

  switch (role) {
    case TimelineActor.student:
      return AppRoutes.requestForm;
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
      initialLocation: _initialRoute(),
      // initialLocation: '/request-new',
      redirect: _requireAuthRedirect,
      routes: [
        /// Warden shell
        ShellRoute(
          builder: (context, state, child) => ChangeNotifierProvider(
            create: (_) => WardenProfileState(),
            child: WardenLayout(child: child),
          ),
          routes: [
            GoRoute(
              path: AppRoutes.seniorWardenHome,
              name: 'senior-warden-home',
              pageBuilder: (context, state) {
                final profile = context.read<WardenProfileState>();
                return AppTransitionPage(
                  key: state.pageKey,
                  child: ChangeNotifierProvider(
                    create: (_) => WardenHomeState(),
                    child: WardenHomePage(actor: profile.loginSession.role),
                  ),
                );
              },
            ),
            GoRoute(
              path: AppRoutes.wardenHome,
              name: 'warden-home',
              pageBuilder: (context, state) {
                final profile = context.read<WardenProfileState>();
                return AppTransitionPage(
                  key: state.pageKey,
                  child: ChangeNotifierProvider(
                    create: (_) => WardenHomeState(),
                    child: WardenHomePage(actor: profile.loginSession.role),
                  ),
                );
              },
            ),
          ],
        ),

        // parent shell
        ShellRoute(
          builder: (context, state, child) => ParentLayout(child: child),
          routes: [
            GoRoute(
              path: AppRoutes.parentHome,
              name: 'parent-home',
              pageBuilder: (context, state) => AppTransitionPage(
                key: state.pageKey,
                child: ChangeNotifierProvider(
                  create: (_) => ParentState(),
                  child: ParentHomePage(),
                ),
              ),
            ),
            GoRoute(
              path: AppRoutes.parentHistory,
              name: 'parent-history',
              pageBuilder: (context, state) => AppTransitionPage(
                key: state.pageKey,
                child: const HistoryPage(),
              ),
            ),
            GoRoute(
              path: AppRoutes.parentProfile,
              name: 'parent-profile',
              pageBuilder: (context, state) => AppTransitionPage(
                key: state.pageKey,
                child: ParentProfilePage(),
              ),
            ),
            GoRoute(
              // Make this absolute and not a child: keep it as a sibling
              path: AppRoutes
                  .parentRequestDetails, // e.g. '/student/create-request/:id'
              name: 'request-detail-parent',
              pageBuilder: (context, state) {
                final requestId = state.pathParameters['id'] ?? '';
                final role = Get.find<LoginSession>().role;
                return AppTransitionPage(
                  key: state.pageKey,
                  child: RequestPage(actor: role, requestId: requestId),
                );
              },
            ),
          ],
        ),

        /// Login
        GoRoute(
          path: AppRoutes.login,
          name: 'login',
          pageBuilder: (context, state) =>
              AppTransitionPage(key: state.pageKey, child: const LoginLayout()),
        ),

        /// Student shell
        ShellRoute(
          builder: (context, state, child) => StudentLayout(child: child),
          routes: [
            GoRoute(
              path: AppRoutes.studentHome,
              name: 'home',
              pageBuilder: (context, state) => AppTransitionPage(
                key: state.pageKey,
                child: const HomePage(),
              ),
            ),
            GoRoute(
              path: AppRoutes.history,
              name: 'history',
              pageBuilder: (context, state) => AppTransitionPage(
                key: state.pageKey,
                child: const HistoryPage(),
              ),
            ),
            GoRoute(
              // Make this absolute and not a child: keep it as a sibling
              path: AppRoutes
                  .requestDetails, // e.g. '/student/create-request/:id'
              name: 'request-detail',
              pageBuilder: (context, state) {
                final requestId = state.pathParameters['id'] ?? '';
                final role = Get.find<LoginSession>().role;
                return AppTransitionPage(
                  key: state.pageKey,
                  child: RequestPage(actor: role, requestId: requestId),
                );
              },
            ),
            GoRoute(
              path: AppRoutes.requestForm,
              name: 'request',
              pageBuilder: (context, state) => AppTransitionPage(
                key: state.pageKey,
                child: RequestFormPage(),
              ),
            ),
            GoRoute(
              path: AppRoutes.profile,
              name: 'profile',
              pageBuilder: (context, state) => AppTransitionPage(
                key: state.pageKey,
                child: const ProfilePage(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
