// app_router.dart
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import 'package:hostel_mgmt/core/rumtime_state/login_session.dart';
import 'package:hostel_mgmt/login/login_layout.dart';
import 'package:hostel_mgmt/view/student/pages/home.dart';
import 'package:hostel_mgmt/view/student/pages/request_form_page.dart';
import 'package:hostel_mgmt/view/student/pages/student_layout.dart';
import 'package:hostel_mgmt/view/student/pages/profile_page.dart';

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
        /// Login route (outside shell)
        GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) => const LoginLayout(),
        ),

        /// Shell route provides layout for authenticated area
        ShellRoute(
          builder: (context, state, child) {
            return StudentLayout(child: child);
            // 👆 StudentLayout should take a `child` widget
            // and wrap it with shared layout (AppBar, Drawer, BottomNav, etc.)
          },
          routes: [
            /// Home is the first route after login
            GoRoute(
              path: '/home',
              name: 'home',
              builder: (context, state) => const HomePage(),
              // Add LoginGuard middleware
              redirect: (context, state) {
                final session = Get.find<LoginSession>();
                if (session.token.isEmpty || !session.isValid) {
                  return '/login';
                }
                return null;
              },
            ),

            GoRoute(
              path: '/request',
              name: 'request',
              builder: (context, state) => const RequestFormPage(),
              redirect: (context, state) {
                final session = Get.find<LoginSession>();
                if (session.token.isEmpty || !session.isValid) {
                  return '/login';
                }
                return null;
              },
            ),
            GoRoute(
              path: '/profile',
              name: 'profile',
              builder: (context, state) => const ProfilePage(),
              redirect: (context, state) {
                final session = Get.find<LoginSession>();
                if (session.token.isEmpty || !session.isValid) {
                  return '/login';
                }
                return null;
              },
            ),
          ],
        ),
      ],
    );
  }
}
