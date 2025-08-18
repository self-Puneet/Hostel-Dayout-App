// lib/core/router/app_router.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hostel_dayout_app/core/routes/auth_guard.dart';
import 'package:hostel_dayout_app/injection.dart';
import 'package:hostel_dayout_app/features/auth/presentation/pages/login_page.dart';
import 'package:hostel_dayout_app/features/requests/presentation/bloc/bloc.dart';
import 'package:hostel_dayout_app/features/requests/presentation/bloc/request_detail_bloc.dart';
import 'package:hostel_dayout_app/features/requests/presentation/bloc/request_detail_event.dart';
import 'package:hostel_dayout_app/features/requests/presentation/pages/pages.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class AppRouter {
  static GoRouter router = GoRouter(
    initialLocation: '/login',
    redirect: (context, state) => AuthGuard.redirect(context, state),
    routes: [
      /// Public route (no guard)
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),

      /// Protected routes inside Shell
      ShellRoute(
        builder: (context, state, child) {
          return AppLayout(location: state.uri.path, child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            name: 'home',
            pageBuilder: (context, state) => MaterialPage(
              child: BlocProvider<RequestListBloc>(
                create: (_) => sl<RequestListBloc>(),
                child: const ShadToaster(child: DashboardPage()),
              ),
            ),
          ),
          GoRoute(
            path: '/requests',
            name: 'requests',
            pageBuilder: (context, state) => MaterialPage(
              child: BlocProvider(
                create: (_) => sl<RequestListBloc>()..add(LoadRequestsEvent()),
                child: const ShadToaster(child: RequestsPage()),
              ),
            ),
          ),

          // ✅ Dynamic route
          GoRoute(
            path: '/requests/:id',
            name: 'requestDetails',
            pageBuilder: (context, state) {
              final id = state.pathParameters['id']!;
              return MaterialPage(
                child: BlocProvider(
                  create: (_) =>
                      sl<RequestDetailBloc>()..add(LoadRequestDetailEvent(id)),
                  child: ShadToaster(child: RequestDetailsPage(requestId: id)),
                ),
              );
            },
          ),
          GoRoute(
            path: '/alerts',
            name: 'alerts',
            pageBuilder: (context, state) => const MaterialPage(
              child: ShadToaster(child: DashboardPage()),
            ),
          ),
          GoRoute(
            path: '/settings',
            name: 'settings',
            pageBuilder: (context, state) => const MaterialPage(
              child: ShadToaster(child: DashboardPage()),
            ),
          ),
        ],
      ),
    ],
  );
}
