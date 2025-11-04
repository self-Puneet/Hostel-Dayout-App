// // lib/core/routes/app_transition_page.dart
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';

// class AppTransitionPage<T> extends CustomTransitionPage<T> {
//   AppTransitionPage({
//     required Widget child,
//     LocalKey? key,
//     Duration duration = const Duration(milliseconds: 500),
//     double dimMaxOpacity = 0.5,
//   }) : super(
//          key: key,
//          child: child,
//          transitionDuration: duration,
//          reverseTransitionDuration: duration,
//          transitionsBuilder: (context, animation, secondaryAnimation, child) {
//            // Incoming page: slide from right → center
//            final slide = Tween<Offset>(
//              begin: const Offset(1.0, 0.0),
//              end: Offset.zero,
//            ).chain(CurveTween(curve: Curves.easeOutCubic)).animate(animation);

//            // Underlying page: dim while covered by a new route
//            final dim = Tween<double>(begin: 0.0, end: dimMaxOpacity)
//                .chain(CurveTween(curve: Curves.easeOutCubic))
//                .animate(secondaryAnimation);

//            // Apply a dimming overlay driven by secondaryAnimation
//            final dimmedChild = AnimatedBuilder(
//              animation: dim,
//              builder: (context, _) => Stack(
//                fit: StackFit.passthrough,
//                children: [
//                  child,
//                  if (dim.value > 0)
//                    IgnorePointer(
//                      ignoring: true,
//                      child: Opacity(
//                        opacity: dim.value,
//                        child: const ColoredBox(color: Colors.black),
//                      ),
//                    ),
//                ],
//              ),
//            );

//            // Slide the incoming page; on the underlying page this is a no-op (animation is 1.0)
//            return SlideTransition(position: slide, child: dimmedChild);
//          },
//        );
// }

// lib/core/routes/app_transition_page.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum SlideFrom { left, right, top, bottom }

class AppTransitionPage<T> extends CustomTransitionPage<T> {
  AppTransitionPage({
    required Widget child,
    LocalKey? key,
    Duration duration = const Duration(milliseconds: 450),
    double dimMaxOpacity = 0.5,
    SlideFrom slideFrom = SlideFrom.right,
    Curve curve = Curves.easeInOut,
  }) : super(
         key: key,
         child: child,
         transitionDuration: duration,
         reverseTransitionDuration: duration,
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           // Map slideFrom -> begin offset
           final Offset begin = switch (slideFrom) {
             SlideFrom.right => const Offset(1.0, 0.0),
             SlideFrom.left => const Offset(-1.0, 0.0),
             SlideFrom.top => const Offset(0.0, -1.0),
             SlideFrom.bottom => const Offset(0.0, 1.0),
           };

           final slide = Tween<Offset>(
             begin: begin,
             end: Offset.zero,
           ).chain(CurveTween(curve: curve)).animate(animation);

           final dim = Tween<double>(
             begin: 0.0,
             end: dimMaxOpacity,
           ).chain(CurveTween(curve: curve)).animate(secondaryAnimation);

           final dimmedChild = AnimatedBuilder(
             animation: dim,
             builder: (context, _) => Stack(
               fit: StackFit.passthrough,
               children: [
                 child,
                 if (dim.value > 0)
                   IgnorePointer(
                     ignoring: true,
                     child: Opacity(
                       opacity: dim.value,
                       child: const ColoredBox(color: Colors.black),
                     ),
                   ),
               ],
             ),
           );

           // On push: from `begin` -> zero; on pop: zero -> `begin`
           return SlideTransition(position: slide, child: dimmedChild);
         },
       );
}
