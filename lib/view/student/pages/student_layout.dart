import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hostel_mgmt/view/widgets/liquid_glass_morphism/glass_nav_bar.dart';

class StudentLayout extends StatelessWidget {
  final Widget child;

  const StudentLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {

    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFE9E9E9),
      body: SafeArea(
        bottom: true,
        child: Padding(
          padding: EdgeInsetsGeometry.symmetric(
            horizontal: 31 * mediaQuery.size.width / 402,
          ),
          child: Stack(
            children: [
              child,
              Positioned(
                left: 0,
                right: 0,
                bottom: 26 / 874 * mediaQuery.size.height,
                child: SafeArea(
                  bottom: true,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: LiquidGlassNavBar(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OverlappingThreeButtons extends StatelessWidget {
  const OverlappingThreeButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  context.go('/home'); // 👈 navigate to home
                },
                child: const Text("Home"),
              ),
            ),
            const SizedBox(width: 60), // space for middle button
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  context.go('/profile');
                  // 👈 navigate to profile
                },
                child: const Text("Profile"),
              ),
            ),
          ],
        ),

        ElevatedButton(
          onPressed: () => context.go('/request'),
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(25), // controls size
            elevation: 6,
            shadowColor: Colors.black54,
            backgroundColor: Colors.blue,
          ),
          child: const Icon(Icons.add, size: 28, color: Colors.white),
        ),
      ],
    );
  }
}
