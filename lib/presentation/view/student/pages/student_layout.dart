import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hostel_mgmt/core/helpers/app_refreasher_widget.dart';
import 'package:hostel_mgmt/core/routes/app_route_constants.dart';
import 'package:hostel_mgmt/presentation/view/student/state/home_state.dart';
import 'package:hostel_mgmt/presentation/widgets/liquid_glass_morphism/glass_nav_bar.dart';
import 'package:provider/provider.dart';

class StudentLayout extends StatelessWidget {
  final Widget child;

  const StudentLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFE9E9E9),
      body: SafeArea(
          top: false,
          bottom: true,
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
                      padding: EdgeInsets.symmetric(
                        horizontal: 31 * mediaQuery.size.width / 402,
                      ),
                      child: LiquidGlassNavBar(
                        onHomePressed: () {
                          // Navigate to home using go route
                          context.go(AppRoutes.studentHome);
                        },
                        onNewPressed: () {
                          // Navigate to new using go route
                          context.go(AppRoutes.requestForm);
                        },
                        onProfilePressed: () {
                          // Navigate to profile using go route
                          context.go(AppRoutes.profile);
                        },
                      ),
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
