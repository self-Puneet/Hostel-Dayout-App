import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hostel_dayout_app/injection.dart';
import 'package:hostel_dayout_app/requests/presentation/bloc/bloc.dart';
import 'package:hostel_dayout_app/requests/presentation/pages/pages.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/home',
    routes: [
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
                child: ShadToaster(child: DashboardPage()),
              ),
            ),
          ),
          GoRoute(
            path: '/requests',
            name: 'requests',
            pageBuilder: (context, state) => MaterialPage(
              child: BlocProvider<RequestListBloc>(
                create: (_) => sl<RequestListBloc>(),
                child: ShadToaster(child: RequestsPage()),
              ),
            ),
          ),
          GoRoute(
            path: '/alerts',
            name: 'alerts',
            pageBuilder: (context, state) => MaterialPage(
              child: BlocProvider<RequestListBloc>(
                create: (_) => sl<RequestListBloc>(),
                child: DashboardPage(),
              ),
            ),
          ),
          GoRoute(
            path: '/settings',
            name: 'settings',
            pageBuilder: (context, state) => MaterialPage(
              child: BlocProvider<RequestListBloc>(
                create: (_) => sl<RequestListBloc>(),
                child: DashboardPage(),
              ),
            ),
          ),
        ],
      ),
    ],
  );
}
