// app_router.dart
import 'package:go_router/go_router.dart';
import 'package:hostel_mgmt/core/routes/auth_guard.dart';
import 'package:hostel_mgmt/login/login_layout.dart';
import 'package:hostel_mgmt/view/student/pages/home.dart';
import 'package:hostel_mgmt/view/student/pages/request_form_page.dart';
import 'package:hostel_mgmt/view/student/pages/student_layout.dart';

class AppRouter {
  static GoRouter build() {
    return GoRouter(
      initialLocation: '/home',

      // refreshListenable: auth,

      // redirect: (context, state) {
      //   final bool isLoggedIn = auth.isLoggedIn;
      //   final bool isLoading = auth.isLoading;
      //   final bool goingToLogin = state.matchedLocation == '/login';

      //   if (isLoading) return null;

      //   if (!isLoggedIn) {
      //     return goingToLogin ? null : '/login';
      //   }

      //   if (isLoggedIn && goingToLogin) return '/home';

      //   return null;
      // },
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
            ),

            /// Request page as a sub-route of shell
            GoRoute(
              path: '/request',
              name: 'request',
              builder: (context, state) =>
                  const RequestFormPage(), // <-- You can create this
            ),
          ],
        ),
      ],
    );
  }
}
