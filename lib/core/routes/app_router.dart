import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hostel_dayout_app/injection.dart';
import 'package:hostel_dayout_app/requests/presentation/bloc/request_bloc.dart';
import 'package:hostel_dayout_app/requests/presentation/pages/dashboard_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/dashboard',
    routes: [
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        pageBuilder: (context, state) => MaterialPage(
          child: BlocProvider<RequestListBloc>(
            create: (_) => sl<RequestListBloc>(),
            child: DashboardPage(),
          ),
        ),
      ),
    ],
  );
}
