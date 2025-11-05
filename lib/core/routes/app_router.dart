// app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import 'package:hostel_mgmt/core/enums/enum.dart';
import 'package:hostel_mgmt/core/routes/app_route_constants.dart';
import 'package:hostel_mgmt/core/routes/app_transition_page.dart'; // 👈 import here
import 'package:hostel_mgmt/core/rumtime_state/login_session.dart';
import 'package:hostel_mgmt/login/login_layout.dart';
import 'package:hostel_mgmt/models/student_profile.dart';
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
import 'package:hostel_mgmt/presentation/view/warden/pages/warden_profile_page.dart';
import 'package:hostel_mgmt/presentation/view/warden/state/warden_action_state.dart';
import 'package:hostel_mgmt/presentation/view/warden/state/warden_history_state.dart';
import 'package:hostel_mgmt/presentation/view/warden/state/warden_home_state.dart';
import 'package:hostel_mgmt/presentation/view/warden/state/warden_layout_state.dart';
import 'package:hostel_mgmt/presentation/view/warden/state/warden_profile_state.dart';
import 'package:hostel_mgmt/presentation/widgets/back_selection.dart';
import 'package:provider/provider.dart';
import '../../presentation/view/student/pages/pages.dart';

/// Helper for route guards
String? _requireAuthRedirect(BuildContext context, GoRouterState state) {
  final session = Get.find<LoginSession>();

  // Not logged in → go to login
  debugPrint(session.token);
  if (session.token.isEmpty || !session.isValid) {
    return AppRoutes.login;
  }

  final allowedRoutes = AppRoutes.routeAllowence[session.role] ?? [];
  if (allowedRoutes.any(
    (allowed) => state.matchedLocation.startsWith(allowed),
  )) {
    debugPrint("Allowed route, no redirect -------------- ");
    return null;
  } else {
    debugPrint("Not allowed route, redirecting to home");
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

// Helper: normalize and compare paths (ignores query/fragment and trailing slash)
// Normalize and compare paths (ignores trailing slash)
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
      return AppRoutes.wardenActionPage;
    case TimelineActor.seniorWarden:
      return AppRoutes.wardenActionPage;
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

        // warden shell route
        ShellRoute(
          builder: (context, state, child) {
            final layoutState = WardenLayoutState();
            final profileState = WardenProfileState();

            return MultiProvider(
              providers: [
                ChangeNotifierProvider.value(value: layoutState),
                ChangeNotifierProvider.value(value: profileState),
                ChangeNotifierProvider(
                  create: (_) => WardenActionState(layoutState),
                ),
              ],
              child: WardenLayout(child: child),
            );
          },
          routes: [
            // warden action page route
            GoRoute(
              path: AppRoutes.wardenActionPage,
              name: AppRoutes.wardenActionPage,
              pageBuilder: (context, state) {
                final layoutState = context.read<WardenLayoutState>();
                final tabParam = state.uri.queryParameters['tab'];
                final initialTab = WardenTab.values.firstWhere(
                  (t) => t.name == tabParam,
                  orElse: () => WardenTab.pendingApproval,
                );
                return AppTransitionPage(
                  key: state.pageKey,
                  child: WardenActionSelectionGuard(
                    child: WardenHomePage(
                      actor: layoutState.loginSession.role,
                      initialTab: initialTab,
                    ),
                  ),
                  slideFrom: (state.extra is SlideFrom)
                      ? state.extra as SlideFrom
                      : SlideFrom.right,
                );
              },
            ),

            // warden home route
            GoRoute(
              path: AppRoutes.wardenHome,
              name: AppRoutes.wardenHome,
              pageBuilder: (context, state) => AppTransitionPage(
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
                      update: (_, wardenState, __) =>
                          WardenStatisticsController(wardenState),
                    ),
                  ],
                  child: HomeDashboardPage(),
                ),
                slideFrom: (state.extra is SlideFrom)
                    ? state.extra as SlideFrom
                    : SlideFrom.right,
              ),
            ),

            // warden profile route
            GoRoute(
              path: AppRoutes.wardenProfile,
              name: AppRoutes.wardenProfile,
              pageBuilder: (context, state) => AppTransitionPage(
                key: state.pageKey,
                child: ChangeNotifierProvider(
                  create: (_) => WardenProfileState(),
                  child: WardenProfilePage(),
                ),
                slideFrom: (state.extra is SlideFrom)
                    ? state.extra as SlideFrom
                    : SlideFrom.right,
              ),
            ),

            // warden history route
            GoRoute(
              path: AppRoutes.wardenHistory,
              name: AppRoutes.wardenHistory,
              pageBuilder: (context, state) {
                final loginSession = Get.find<LoginSession>();
                return AppTransitionPage(
                  key: state.pageKey,
                  child: ChangeNotifierProvider(
                    create: (_) => WardenHistoryState(),
                    child: WardenHistoryPage(actor: loginSession.role),
                  ),
                  slideFrom: (state.extra is SlideFrom)
                      ? state.extra as SlideFrom
                      : SlideFrom.right,
                );
              },
            ),

            // warden request detail route (nested, dynamic)
            GoRoute(
              // keep as child if you want the warden shell visible above details
              path: AppRoutes.wardenRequestDetails, // '/warden/request/:id'
              name: 'request-detail-warden',
              pageBuilder: (context, state) {
                final requestId = state.pathParameters['id'] ?? '';
                final role = Get.find<LoginSession>().role;
                // If route was pushed with a Map extra, forward it to the page as routeArgs
                final StudentProfileModel? routeArgs =
                    (state.extra is StudentProfileModel)
                    ? state.extra as StudentProfileModel
                    : null;

                return AppTransitionPage(
                  key: state.pageKey,
                  child: RequestPage(
                    actor: role,
                    requestId: requestId,
                    routeArgs: routeArgs,
                  ),
                  slideFrom: (state.extra is SlideFrom)
                      ? state.extra as SlideFrom
                      : SlideFrom.right,
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
                slideFrom: (state.extra is SlideFrom)
                    ? state.extra as SlideFrom
                    : SlideFrom.right,
              ),
            ),
            GoRoute(
              path: AppRoutes.parentHistory,
              name: 'parent-history',
              pageBuilder: (context, state) => AppTransitionPage(
                key: state.pageKey,
                child: const HistoryPage(),
                slideFrom: (state.extra is SlideFrom)
                    ? state.extra as SlideFrom
                    : SlideFrom.right,
              ),
            ),
            GoRoute(
              path: AppRoutes.parentProfile,
              name: 'parent-profile',
              pageBuilder: (context, state) => AppTransitionPage(
                key: state.pageKey,
                child: ParentProfilePage(),
                slideFrom: (state.extra is SlideFrom)
                    ? state.extra as SlideFrom
                    : SlideFrom.right,
              ),
            ),
            GoRoute(
              // keep as child if you want the parent shell visible above details
              path: AppRoutes.parentRequestDetails, // '/parent/request/:id'
              name: 'request-detail-parent',
              pageBuilder: (context, state) {
                final requestId = state.pathParameters['id'] ?? '';
                final role = Get.find<LoginSession>().role;
                return AppTransitionPage(
                  key: state.pageKey,
                  child: RequestPage(actor: role, requestId: requestId),
                  slideFrom: (state.extra is SlideFrom)
                      ? state.extra as SlideFrom
                      : SlideFrom.right,
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

        ShellRoute(
          builder: (context, state, child) => StudentLayout(child: child),
          routes: [
            GoRoute(
              path: AppRoutes.studentHome,
              name: 'home',
              pageBuilder: (context, state) => AppTransitionPage(
                key: state.pageKey,
                child: const HomePage(),
                // Use extra direction if provided, else default.
                slideFrom: (state.extra is SlideFrom)
                    ? state.extra as SlideFrom
                    : SlideFrom.right,
              ),
            ),
            GoRoute(
              path: AppRoutes.history,
              name: 'history',
              pageBuilder: (context, state) => AppTransitionPage(
                key: state.pageKey,
                child: const HistoryPage(),
                slideFrom: (state.extra is SlideFrom)
                    ? state.extra as SlideFrom
                    : SlideFrom.right,
              ),
            ),
            GoRoute(
              path: AppRoutes.requestForm,
              name: 'request',
              pageBuilder: (context, state) => AppTransitionPage(
                key: state.pageKey,
                child: RequestFormPage(),
                slideFrom: (state.extra is SlideFrom)
                    ? state.extra as SlideFrom
                    : SlideFrom.right,
              ),
            ),
            GoRoute(
              path: AppRoutes.profile,
              name: 'profile',
              pageBuilder: (context, state) => AppTransitionPage(
                key: state.pageKey,
                child: const ProfilePage(),
                slideFrom: (state.extra is SlideFrom)
                    ? state.extra as SlideFrom
                    : SlideFrom.right,
              ),
            ),
            GoRoute(
              path: AppRoutes.requestDetails,
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
          ],
        ),
      ],
    );
  }
}
