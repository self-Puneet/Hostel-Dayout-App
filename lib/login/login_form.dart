import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hostel_mgmt/core/helpers/unfocus.dart';
import 'package:hostel_mgmt/core/theme/elevated_button_theme.dart';

import 'package:hostel_mgmt/login/login_state.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

import 'package:provider/provider.dart';
import 'login_controller.dart';
import 'package:hostel_mgmt/core/enums/timeline_actor.dart';

// glass_warden_role_bar.dart
import 'dart:math' show pi;
import 'package:animated_segmented_tab_control/animated_segmented_tab_control.dart';

class LoginPage extends StatelessWidget {
  final TimelineActor actor; // 👈 decides which login config to use
  const LoginPage({super.key, required this.actor});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<LoginState>();
    final controller = LoginController(state);

    // pull the correct model + controllers for this actor
    final loginModel = state.textFieldMap[actor]?[FieldsType.model];
    final identityController =
        state.textFieldMap[actor]?[FieldsType.identityField];
    final verificationController =
        state.textFieldMap[actor]?[FieldsType.verificationField];

    // final otherFunctionalities = Row(
    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //   children: [
    //     loginModel.showForgotPassword
    //         ? TextButton(
    //             onPressed: () => controller.forgotPassword(context, actor),
    //             child: const Text("Forgot Password?"),
    //           )
    //         : const SizedBox.shrink(),
    //     loginModel.showResetPassword
    //         ? TextButton(
    //             onPressed: () =>
    //                 LoginController.doResetPassword(context, actor),
    //             child: const Text("Reset Password"),
    //           )
    //         : const SizedBox.shrink(),
    //   ],
    // );

    final identityField = TextField(
      controller: identityController,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        labelText: loginModel.identityFieldName,
        // Always black; normal when not floating
        labelStyle: const TextStyle(color: Colors.black),
        // Bold when label floats (on focus or when not empty)
        floatingLabelStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w700,
        ),
        prefixIcon: Icon(loginModel.identityFieldIconData),
        // Always black icon
        prefixIconColor: Colors.black,
        // Borders: same color, thicker on focus
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black, width: 2),
        ),
      ),
      // Input text color
      style: const TextStyle(color: Colors.black),
    );

    final varificationField = TextField(
      controller: verificationController,
      obscureText: loginModel.verificationFieldName.toLowerCase().contains(
        "password",
      ),
      cursorColor: Colors.black,
      decoration: InputDecoration(
        labelText: loginModel.verificationFieldName,
        labelStyle: const TextStyle(color: Colors.black),
        floatingLabelStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.w700,
        ),
        prefixIcon: Icon(loginModel.verificationFieldIconData),
        prefixIconColor: Colors.black,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black, width: 2),
        ),
      ),
      style: const TextStyle(color: Colors.black),
    );

    final formTitle = Text(
      loginModel.loginTitle,
      style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
    );

    // inside LoginPage.build, replace wardenTypeSelector with:
    final int initialIndex =
        state.selectedWardenRole == TimelineActor.assistentWarden ? 0 : 1;

    final wardenTypeSelector = actor == TimelineActor.assistentWarden
        // ? (!state.isKeyboardOpen)
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: GlassWardenRoleBar(
              initialIndex: initialIndex,
              onIndexChanged: (i) {
                state.setSelectedWardenRole(
                  i == 0
                      ? TimelineActor.assistentWarden
                      : TimelineActor.seniorWarden,
                );
              },
            ),
          )
        : const SizedBox.shrink();
    // : const SizedBox.shrink();

    // Warden type selector row (only for assistentWarden)
    // final wardenTypeSelector = actor == TimelineActor.assistentWarden
    //     ? (!state.isKeyboardOpen)
    //           ? Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceAround,
    //               children: [
    //                 Row(
    //                   children: [
    //                     Radio<String>(
    //                       value: 'warden', // was 'warden'
    //                       groupValue:
    //                           state.wardenType, // default should be 'assistant'
    //                       onChanged: (val) {
    //                         if (val != null) state.setWardenType(val);
    //                       },
    //                     ),
    //                     const Text('Assistant\nWarden'),
    //                   ],
    //                 ),
    //                 Row(
    //                   children: [
    //                     Radio<String>(
    //                       value: 'senior_warden', // was 'senior_warden'
    //                       groupValue: state.wardenType,
    //                       onChanged: (val) {
    //                         if (val != null) state.setWardenType(val);
    //                       },
    //                     ),
    //                     const Text('Senior\nWarden'),
    //                   ],
    //                 ),
    //               ],
    //             )
    //           : const SizedBox.shrink()
    //     : const SizedBox.shrink();

    final loginButton = !state.isLoggingIn
        ? SizedBox(
            width: double.infinity, // take all available horizontal space
            child: ElevatedButton(
              onPressed: () => controller.login(context, actor),
              child: Text(
                loginModel.elevatedButtonText,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          )
        : DisabledElevatedButton(text: loginModel.disabledButtonText);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(0),
          child: KeyboardDismissOnTap(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: LiquidGlass(
                // Same shape as GlassSegmentedTabs
                shape: LiquidRoundedSuperellipse(
                  borderRadius: BorderRadius.circular(40).topLeft,
                ),
                // Same settings as GlassSegmentedTabs
                settings: const LiquidGlassSettings(
                  thickness: 10,
                  blur: 20, // increased from 8 for stronger frost
                  chromaticAberration: 0.01,
                  lightAngle: pi * 5 / 18,
                  lightIntensity: 0.5,
                  refractiveIndex: 1.4,
                  saturation: 1,
                  lightness: 1,
                ),
                // Glass body + your content
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    // ~5% white tint over the glass to match your tabs component
                    color: Colors.white.withAlpha((0.05 * 225).toInt()),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        formTitle,
                        const SizedBox(height: 16),
                        wardenTypeSelector,
                        const SizedBox(height: 16),
                        identityField,
                        const SizedBox(height: 16),
                        varificationField,
                        const SizedBox(height: 24),
                        loginButton,
                        // const SizedBox(height: 16),
                        // otherFunctionalities,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GlassWardenRoleBar extends StatefulWidget {
  final int initialIndex; // 0 = Assistant, 1 = Senior
  final ValueChanged<int>? onIndexChanged;

  const GlassWardenRoleBar({
    super.key,
    required this.initialIndex,
    this.onIndexChanged,
  });

  @override
  State<GlassWardenRoleBar> createState() => _GlassWardenRoleBarState();
}

class _GlassWardenRoleBarState extends State<GlassWardenRoleBar>
    with SingleTickerProviderStateMixin {
  late final TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialIndex,
    );
    _controller.addListener(() {
      if (!_controller.indexIsChanging) {
        widget.onIndexChanged?.call(_controller.index);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Stack(
        children: [
          // Glass background
          Positioned.fill(
            child: LiquidGlass(
              shape: LiquidRoundedSuperellipse(
                borderRadius: BorderRadius.circular(40).topLeft,
              ),
              settings: const LiquidGlassSettings(
                thickness: 10,
                blur: 0,
                chromaticAberration: 0.01,
                lightAngle: pi * 5 / 18,
                lightIntensity: 0.5,
                refractiveIndex: 1.4,
                saturation: 1,
                lightness: 1,
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: Colors.white.withOpacity(0.14),
                ),
              ),
            ),
          ),

          // Segmented control only (no TabBarView)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: SegmentedTabControl(
              controller: _controller,
              indicatorPadding: const EdgeInsets.symmetric(vertical: 4),
              barDecoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(999),
              ),
              indicatorDecoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(999),
              ),
              textStyle: const TextStyle(fontSize: 12),
              selectedTextStyle: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
              tabTextColor: Colors.black,
              selectedTabTextColor: Colors.white,
              squeezeIntensity: 2,
              tabs: const [
                SegmentTab(
                  label: 'Assistant Warden',
                  splashColor: Colors.transparent,
                  splashHighlightColor: Colors.transparent,
                ),
                SegmentTab(
                  label: 'Senior Warden',
                  splashColor: Colors.transparent,
                  splashHighlightColor: Colors.transparent,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}