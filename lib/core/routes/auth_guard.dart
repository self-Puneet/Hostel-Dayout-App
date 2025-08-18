// lib/core/router/auth_guard.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hostel_dayout_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:hostel_dayout_app/features/auth/presentation/bloc/auth_state.dart';

class AuthGuard {
  static String? redirect(BuildContext context, GoRouterState state) {
    final authState = context.read<LoginBloc>().state;

    // Already authenticated → allow
    if (authState is LoginSuccess) {
      return null;
    }

    // Not authenticated → redirect to login
    if (authState is LoginSuccess) {
      return '/login';
    }

    // For loading/unknown states, stay put
    return null;
  }
}
