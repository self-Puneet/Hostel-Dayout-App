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
import 'package:hostel_mgmt/presentation/view/warden/controller/warden_home_controller.dart';
import 'package:hostel_mgmt/presentation/view/warden/pages/warden_action_page.dart';
import 'package:hostel_mgmt/presentation/view/warden/pages/warden_history_page.dart';
import 'package:hostel_mgmt/presentation/view/warden/pages/warden_home_page.dart';
import 'package:hostel_mgmt/presentation/view/warden/pages/warden_layout.dart';
import 'package:hostel_mgmt/presentation/view/warden/state/warden_action_state.dart';
import 'package:hostel_mgmt/presentation/view/warden/state/warden_history_state.dart';
import 'package:hostel_mgmt/presentation/view/warden/state/warden_home_state.dart';
import 'package:hostel_mgmt/presentation/view/warden/state/warden_profile_state.dart';
import 'package:provider/provider.dart';
import '../../presentation/view/student/pages/pages.dart';

/// Helper for route guards
String? _requireAuthRedirect(BuildContext context, GoRouterState state) {
  final session = Get.find<LoginSession>();

  // Not logged in → go to login
  print(session.token);
  if (session.token.isEmpty || !session.isValid) {
    return AppRoutes.login;
  }

  final allowedRoutes = AppRoutes.routeAllowence[session.role] ?? [];
  if (allowedRoutes.any(
    (allowed) => state.matchedLocation.startsWith(allowed),
  )) {
    print("Allowed route, no redirect");
    return null;
  } else {
    print("Not allowed route, redirecting to home");
  }

  // Otherwise, redirect user to home based on role
  switch (session.role) {
    case TimelineActor.student:
      return AppRoutes.studentHome;
    case TimelineActor.assistentWarden:
      return AppRoutes.wardenHome;
    case TimelineActor.seniorWarden:
      return AppRoutes.wardenHome;
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
      return AppRoutes.studentHome;
    case TimelineActor.assistentWarden:
      return AppRoutes.wardenHome;
    case TimelineActor.seniorWarden:
      return AppRoutes.wardenHistory;
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

        // testing route
        GoRoute(
          path: '/test',
          name: 'test',
          pageBuilder: (context, state) => AppTransitionPage(
            key: state.pageKey,
            child: const Scaffold(body: Center(child: Text("Test Page"))),
          ),
        ),

        ShellRoute(
          builder: (context, state, child) => ChangeNotifierProvider(
            create: (_) => WardenProfileState(),
            child: WardenLayout(child: child),
          ),
          routes: [
            // warden action page route
            GoRoute(
              path: AppRoutes.wardenActionPage,
              name: AppRoutes.wardenActionPage,
              pageBuilder: (context, state) {
                final profile = context.read<WardenProfileState>();

                // Read ?tab=<enumName> from the URL, e.g., ?tab=approved
                final tabParam = state.uri.queryParameters['tab'];

                // Map name → enum safely
                final initialTab = WardenTab.values.firstWhere(
                  (t) => t.name == tabParam,
                  orElse: () => WardenTab.pendingApproval,
                );

                return AppTransitionPage(
                  key: state.pageKey,
                  child: ChangeNotifierProvider(
                    create: (_) => WardenActionState(),
                    child: WardenHomePage(
                      actor: profile.loginSession.role,
                      initialTab:
                          initialTab, // requires WardenHomePage(initialTab)
                    ),
                  ),
                );
              },
            ),

            // // warden home page route
            GoRoute(
              path: AppRoutes.wardenHome,
              name: AppRoutes.wardenHome,
              pageBuilder: (context, state) {
                // Instead of only providing state, provide both state and controller
                return AppTransitionPage(
                  key: state.pageKey,
                  child: MultiProvider(
                    providers: [
                      ChangeNotifierProvider(
                        create: (_) => WardenStatisticsState(),
                      ),
                      ProxyProvider<
                        WardenStatisticsState,
                        WardenStatisticsController
                      >(
                        // ProxyProvider injects the state into the controller
                        update: (_, wardenState, __) =>
                            WardenStatisticsController(wardenState),
                      ),
                    ],
                    child: HomeDashboardPage(),
                  ),
                );
              },
            ),

            // warden history page route
            GoRoute(
              path: AppRoutes.wardenHistory, // e.g., '/warden/history'
              name: AppRoutes.wardenHistory,
              pageBuilder: (context, state) {
                final profile = context.read<WardenProfileState>();
                return AppTransitionPage(
                  key: state.pageKey,
                  child: ChangeNotifierProvider(
                    create: (_) => WardenHistoryState(),
                    child: WardenHistoryPage(actor: profile.loginSession.role),
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
