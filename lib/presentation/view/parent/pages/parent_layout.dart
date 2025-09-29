import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hostel_mgmt/core/routes/app_route_constants.dart';
import 'package:hostel_mgmt/presentation/widgets/liquid_glass_morphism/glass_nav_bar.dart';

class ParentLayout extends StatelessWidget {
  final Widget child;
  const ParentLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final bottomInset = media.viewInsets.bottom;
    final bottomSafe = media.viewPadding.bottom;

    final bool isKeyboardOpen = bottomInset > 0;
    final bool showNavBar = !isKeyboardOpen;

    final double barBottomOffset = bottomSafe + 12;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTapDown: (_) => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xFFE9E9E9),
        resizeToAvoidBottomInset: true,
        extendBody: true,
        body: SafeArea(
          top: false,
          bottom: false,
          child: Stack(
            children: [
              child,
              Positioned(
                left: 0,
                right: 0,
                bottom: barBottomOffset,
                child: Center(
                  child: IgnorePointer(
                    ignoring: !showNavBar,
                    child: AnimatedSlide(
                      duration: const Duration(milliseconds: 180),
                      curve: Curves.easeOut,
                      offset: showNavBar ? Offset.zero : const Offset(0, 1),
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 120),
                        opacity: showNavBar ? 1 : 0,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 31 * media.size.width / 402,
                          ),
                          child: LiquidGlassNavBar(
                            onHomePressed: () =>
                                context.push(AppRoutes.parentHome),
                            onNewPressed: () =>
                                context.push(AppRoutes.parentHistory),
                            onProfilePressed: () =>
                                context.push(AppRoutes.parentProfile),

                            leftIcon: Image.asset(
                              'assets/home.png',
                              width: 36,
                              height: 36,
                            ),
                            rightIcon: Icons.person_outline_outlined,
                            middleIcon: Icons.history,
                            middleText: "HIST",
                          ),
                        ),
                      ),
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
