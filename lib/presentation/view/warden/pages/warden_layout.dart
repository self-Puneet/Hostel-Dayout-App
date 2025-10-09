import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hostel_mgmt/core/routes/app_route_constants.dart';
import 'package:hostel_mgmt/presentation/view/warden/state/warden_profile_state.dart';
import 'package:hostel_mgmt/presentation/widgets/liquid_glass_morphism/glass_nav_bar.dart';
import 'package:hostel_mgmt/presentation/widgets/welcome_header.dart';
import 'package:provider/provider.dart';
import 'package:dartz/dartz.dart';

class WardenLayout extends StatelessWidget {
  final Widget child;
  const WardenLayout({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final bottomInset = media.viewInsets.bottom; // keyboard height if open
    final bottomSafe = media.viewPadding.bottom; // safe-area at bottom
    final isKeyboardOpen = bottomInset > 0;
    final showNavBar = !isKeyboardOpen;
    final double barBottomOffset =
        bottomSafe + 12; // lift bar above gesture area

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Consumer<WardenProfileState>(
        builder: (context, state, _) {
          final actor = state.loginSession.role;

          // Use the routed child for index 0 to keep Router integration,
          // fall back to local pages for others.
          final horizontalPad = EdgeInsets.symmetric(
            horizontal: 31 * media.size.width / 402,
          );
          final double headerTop = media.size.height * 50 / 874;

          return Scaffold(
            backgroundColor: const Color(0xFFE9E9E9),
            resizeToAvoidBottomInset: true,
            extendBody: true, // allow body under the floating bar
            body: SafeArea(
              top: false,
              bottom: false,
              child: Stack(
                children: [
                  // Main content (header + page)
                  Positioned.fill(
                    child: Padding(
                      padding: EdgeInsets.only(top: headerTop),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: horizontalPad,
                            child: WelcomeHeader(
                              enrollmentNumber: state.loginSession.identityId,
                              phoneNumber: state.loginSession.phone,
                              actor: actor,
                              hostelName: state.loginSession.hostelIds!.join(
                                '\n',
                              ),
                              name: state.loginSession.username,
                              avatarUrl: state.loginSession.imageURL,
                              greeting: 'Welcome back,',
                            ),
                          ),
                          const SizedBox(height: 20),
                          Expanded(child: child),
                        ],
                      ),
                    ),
                  ),

                  // Spacer under the bar so content can scroll past it
                  // Positioned(
                  //   left: 0,
                  //   right: 0,
                  //   bottom: barBottomOffset,
                  //   child: Padding(
                  //     padding: EdgeInsets.symmetric(
                  //       horizontal: 31 * media.size.width / 402,
                  //     ),
                  //     child: const SizedBox(height: 60),
                  //   ),
                  // ),

                  // Floating bottom bar (like StudentLayout), hides when keyboard opens
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
                                    context.push(AppRoutes.wardenHome),
                                onNewPressed: () =>
                                    context.push(AppRoutes.wardenActionPage),
                                onProfilePressed: () =>
                                    context.push(AppRoutes.profile),
                                rightIcon: Right(
                                  Icon(
                                    Icons.history,
                                    size: 34,
                                    color: Colors.black,
                                  ),
                                ),
                                leftIcon: Left(
                                  Image.asset(
                                    'assets/home.png',
                                    width: 34,
                                    height: 34,
                                  ),
                                ),
                                middleIcon: Right(
                                  Icon(
                                    Icons.playlist_add_check_outlined,
                                    size: 34,
                                    color: Colors.white,
                                  ),
                                ),
                                middleText: "REQ",
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
          );
        },
      ),
    );
  }
}
