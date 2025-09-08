// lib/core/routes/app_transition_page.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppTransitionPage<T> extends CustomTransitionPage<T> {
  AppTransitionPage({
    required Widget child,
    LocalKey? key,
    Duration transitionDuration = const Duration(milliseconds: 250),
  }) : super(
         key: key,
         child: child,
         transitionDuration: transitionDuration,
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           // First page disappears instantly, then new one fades in
           final curved = CurvedAnimation(
             parent: animation,
             curve: Curves.easeInOut,
           );

           return FadeTransition(opacity: curved, child: child);
         },
       );
}
