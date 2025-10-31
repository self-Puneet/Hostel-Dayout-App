import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hostel_mgmt/core/enums/actions.dart';
import 'package:hostel_mgmt/core/enums/timeline_actor.dart';
import 'package:hostel_mgmt/core/routes/app_route_constants.dart';
import 'package:hostel_mgmt/core/theme/app_theme.dart';
import 'package:hostel_mgmt/presentation/animation/layout_navbar_action_animation.dart';
import 'package:hostel_mgmt/presentation/view/warden/state/warden_action_state.dart';
import 'package:hostel_mgmt/presentation/view/warden/state/warden_layout_state.dart';
import 'package:hostel_mgmt/presentation/widgets/liquid_glass_morphism/glass_nav_bar.dart';
import 'package:hostel_mgmt/presentation/widgets/welcome_header.dart';
import 'package:provider/provider.dart';
import 'package:dartz/dartz.dart';
import '../../../components/glass_shell.dart';

class WardenLayout extends StatelessWidget {
  final Widget child;
  const WardenLayout({Key? key, required this.child}) : super(key: key);

  static const BorderRadius _barRadius = BorderRadius.all(Radius.circular(999));
  static const double _barAspect = 340 / 65;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final bottomInset = media.viewInsets.bottom;
    final bottomSafe = media.viewPadding.bottom;
    final isKeyboardOpen = bottomInset > 0;
    final showBarArea = !isKeyboardOpen;
    final double barBottomOffset = bottomSafe + 12;

    final horizontalPad = EdgeInsets.symmetric(
      horizontal: 31 * media.size.width / 402,
    );
    final double headerTop = media.size.height * 50 / 874;

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Consumer<WardenLayoutState>(
        builder: (context, state, _) {
          final actor = state.loginSession.role;

          return Scaffold(
            backgroundColor: const Color(0xFFE9E9E9),
            resizeToAvoidBottomInset: true,
            extendBody: true,
            body: SafeArea(
              top: false,
              bottom: false,
              child: Stack(
                children: [
                  // Content
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
                              hostelName: state.loginSession.hostels!
                                  .map((h) => h.hostelName)
                                  .toList()
                                  .join('\n'),
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

                  // Floating bar area (nav bar or actions overlay)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: barBottomOffset,
                    child: Center(
                      child: IgnorePointer(
                        ignoring: !showBarArea,
                        child: AnimatedSlide(
                          duration: const Duration(milliseconds: 180),
                          curve: Curves.easeOut,
                          offset: showBarArea
                              ? Offset.zero
                              : const Offset(0, 1),
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 120),
                            opacity: showBarArea ? 1 : 0,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 31 * media.size.width / 402,
                              ),
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 180),
                                switchInCurve: Curves.easeOut,
                                switchOutCurve: Curves.easeIn,
                                layoutBuilder:
                                    (currentChild, previousChildren) {
                                      return Stack(
                                        alignment: Alignment.center,
                                        children: <Widget>[
                                          ...previousChildren,
                                          if (currentChild != null)
                                            currentChild,
                                        ],
                                      );
                                    },
                                // child: state.showActionOverlay
                                //     ? Consumer<WardenActionState>(
                                //         builder: (context, actionState, _) {
                                //           return BulkActionsBar(
                                //             key: const ValueKey('bulk-actions'),
                                //             actor: actor,
                                //             isActioning:
                                //                 actionState.isActioning,
                                //             hasSelection:
                                //                 actionState.hasSelection,
                                //             onLeftPressed: () async {
                                //               final action =
                                //                   actor ==
                                //                       TimelineActor
                                //                           .assistentWarden
                                //                   ? RequestAction.cancel
                                //                   : RequestAction.reject;
                                //               await actionState
                                //                   .triggerBulkAction(
                                //                     action: action,
                                //                   );
                                //             },
                                //             onRightPressed: () async {
                                //               final action =
                                //                   actor ==
                                //                       TimelineActor
                                //                           .assistentWarden
                                //                   ? RequestAction.refer
                                //                   : RequestAction.approve;
                                //               await actionState
                                //                   .triggerBulkAction(
                                //                     action: action,
                                //                   );
                                //             },
                                //             borderRadius: _barRadius,
                                //             aspectRatio: _barAspect,
                                //           );
                                //         },
                                //       )
                                //     : LiquidGlassNavBar(
                                //   onHomePressed: () => context.goNamed(
                                //     (actor == TimelineActor.seniorWarden)
                                //         ? AppRoutes.wardenHome
                                //         : AppRoutes.wardenHome,
                                //   ),
                                //   onNewPressed: () => context.goNamed(
                                //     AppRoutes.wardenActionPage,
                                //   ),
                                //   onProfilePressed: () => context.goNamed(
                                //     AppRoutes.wardenHistory,
                                //   ),
                                //   rightIcon: Right(
                                //     Icon(
                                //       Icons.history,
                                //       size: 34,
                                //       color: Colors.black,
                                //     ),
                                //   ),
                                //   leftIcon: Left(
                                //     Image.asset(
                                //       'assets/home.png',
                                //       width: 34,
                                //       height: 34,
                                //     ),
                                //   ),
                                //   middleIcon: Right(
                                //     Icon(
                                //       Icons.playlist_add_check_outlined,
                                //       size: 34,
                                //       color: Colors.white,
                                //     ),
                                //   ),
                                //   middleText: "REQ",
                                // ),
                                child: SequencedBarSwitcher(
                                  showBulk: state.showActionOverlay,
                                  slideDuration: const Duration(
                                    milliseconds: 180,
                                    seconds: 0,
                                  ),
                                  opacityDuration: const Duration(
                                    milliseconds: 180,
                                    seconds: 0,
                                  ),
                                  inCurve: Curves.easeOut, // come in
                                  outCurve: Curves.easeIn, // go out
                                  buildNavBar: (_) => LiquidGlassNavBar(
                                    onHomePressed: () => context.goNamed(
                                      (actor == TimelineActor.seniorWarden)
                                          ? AppRoutes.wardenHome
                                          : AppRoutes.wardenHome,
                                    ),
                                    onNewPressed: () => context.goNamed(
                                      AppRoutes.wardenActionPage,
                                    ),
                                    onProfilePressed: () => context.goNamed(
                                      AppRoutes.wardenHistory,
                                    ),
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
                                  buildBulkBar: (_) =>
                                      Consumer<WardenActionState>(
                                        builder: (context, actionState, __) {
                                          return BulkActionsBar(
                                            key: const ValueKey('bulk-actions'),
                                            actor: actor,
                                            isActioning:
                                                actionState.isActioning,
                                            hasSelection:
                                                actionState.hasSelection,
                                            onLeftPressed: () async {
                                              final action =
                                                  actor ==
                                                      TimelineActor
                                                          .assistentWarden
                                                  ? RequestAction.cancel
                                                  : RequestAction.reject;
                                              await actionState
                                                  .triggerBulkAction(
                                                    action: action,
                                                  );
                                            },
                                            onRightPressed: () async {
                                              final action =
                                                  actor ==
                                                      TimelineActor
                                                          .assistentWarden
                                                  ? RequestAction.refer
                                                  : RequestAction.approve;
                                              await actionState
                                                  .triggerBulkAction(
                                                    action: action,
                                                  );
                                            },
                                            borderRadius: _barRadius,
                                            aspectRatio: _barAspect,
                                          );
                                        },
                                      ),
                                ),
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

class BulkActionsBar extends StatelessWidget {
  final TimelineActor actor;
  final bool isActioning;
  final bool hasSelection;

  final VoidCallback? onLeftPressed;
  final VoidCallback? onRightPressed;

  final String? leftTextOverride;
  final String? rightTextOverride;

  final BorderRadius borderRadius;
  final double aspectRatio;

  const BulkActionsBar({
    super.key,
    required this.actor,
    required this.isActioning,
    required this.hasSelection,
    required this.onLeftPressed,
    required this.onRightPressed,
    this.leftTextOverride,
    this.rightTextOverride,
    this.borderRadius = const BorderRadius.all(Radius.circular(40)),
    this.aspectRatio = 340 / 65,
  });

  @override
  Widget build(BuildContext context) {
    // final bool disabled = isActioning || !hasSelection;
    final bool disabled = isActioning;
    final bool isAssistant = actor == TimelineActor.assistentWarden;

    final String leftText =
        leftTextOverride ?? (isAssistant ? 'Cancel' : 'Reject');
    final String rightText =
        rightTextOverride ?? (isAssistant ? 'Refer' : 'Approve');
    final textTheme = Theme.of(context).textTheme;

    return GlassShell(
      borderRadius: borderRadius,
      aspectRatio: aspectRatio,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: disabled ? Colors.grey : Colors.red,
                  foregroundColor: disabled ? Colors.black : Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(999)),
                  ),
                ),
                onPressed: disabled ? null : onLeftPressed,
                child: Text(
                  leftText,
                  style: textTheme.h4.copyWith(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: disabled ? Colors.grey : Colors.green,
                  foregroundColor: disabled ? Colors.black : Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(999)),
                  ),
                ),
                onPressed: disabled ? null : onRightPressed,
                child: Text(
                  rightText,
                  style: textTheme.h4.copyWith(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}