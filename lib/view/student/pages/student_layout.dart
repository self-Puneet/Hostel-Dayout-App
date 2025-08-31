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
        top: true,
        bottom: true,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsetsGeometry.only(
                top: mediaQuery.size.height * 32 / 874,
              ),
              child: child,
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 26 / 874 * mediaQuery.size.height,
              child: SafeArea(
                bottom: true,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 31 * mediaQuery.size.width / 402,
                    ),
                    child: LiquidGlassNavBar(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
