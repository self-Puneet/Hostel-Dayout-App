// lib/presentation/view/warden_profile/warden_profile_page.dart
import 'package:flutter/material.dart';
import 'package:hostel_mgmt/core/enums/ui_eums/snackbar_type.dart';
import 'package:hostel_mgmt/core/helpers/app_refreasher_widget.dart';
import 'package:hostel_mgmt/core/helpers/app_snackbar.dart';
import 'package:hostel_mgmt/core/theme/app_theme.dart';
import 'package:hostel_mgmt/core/theme/elevated_button_theme.dart';
import 'package:hostel_mgmt/login/login_controller.dart';
import 'package:hostel_mgmt/models/warden_model.dart';
import 'package:hostel_mgmt/presentation/components/skeleton_loaders/profile_page_skeleton.dart';
import 'package:hostel_mgmt/presentation/view/warden/controller/warden_profile_controller.dart';
import 'package:hostel_mgmt/presentation/view/warden/state/warden_profile_state.dart';
import 'package:hostel_mgmt/presentation/widgets/collapsing_header.dart';
import 'package:hostel_mgmt/presentation/widgets/shimmer_box.dart';
import 'package:hostel_mgmt/presentation/widgets/text_field.dart';
import 'package:provider/provider.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'dart:math';

class WardenProfilePage extends StatefulWidget {
  const WardenProfilePage({Key? key}) : super(key: key);

  @override
  State<WardenProfilePage> createState() => _WardenProfilePageState();
}

class _WardenProfilePageState extends State<WardenProfilePage>
    with SingleTickerProviderStateMixin {
  late final WardenProfileState state;
  late final WardenProfileController controller;

  @override
  void initState() {
    super.initState();
    state = WardenProfileState();
    controller = WardenProfileController(state: state);
    controller.initialize();
  }

  void _showResetPasswordGlassDialog(BuildContext providerCtx) {
    final textTheme = Theme.of(context).textTheme;
    showDialog(
      context: providerCtx,
      barrierDismissible: false,
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black26,
      useRootNavigator: false,
      builder: (dialogCtx) {
        final mq = MediaQuery.of(dialogCtx);
        final bottomInset = mq.viewInsets.bottom;

        return ChangeNotifierProvider<WardenProfileState>.value(
          value: state,
          child: Padding(
            padding: EdgeInsets.only(bottom: bottomInset),
            child: Dialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              insetPadding: EdgeInsets.symmetric(
                horizontal: (3 * 31 * mq.size.width) / (402 * 2),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned.fill(
                    child: IgnorePointer(
                      child: LiquidGlass(
                        shape: LiquidRoundedSuperellipse(
                          borderRadius: Radius.circular(20),
                        ),
                        settings: const LiquidGlassSettings(
                          thickness: 10,
                          blur: 20,
                          chromaticAberration: 0.01,
                          lightAngle: pi * 5 / 18,
                          lightIntensity: 0.5,
                          refractiveIndex: 10,
                          saturation: 1,
                          lightness: 1,
                        ),
                        child: const SizedBox.expand(),
                      ),
                    ),
                  ),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Material(
                        color: Colors.white.withAlpha((0.15 * 225).toInt()),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withAlpha(
                                (0.3 * 225).toInt(),
                              ),
                            ),
                          ),
                          child: SafeArea(
                            top: false,
                            child: Consumer<WardenProfileState>(
                              builder: (c, s, _) => SingleChildScrollView(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      'Reset\nPassword',
                                      style: textTheme.h2.copyWith(
                                        fontWeight: FontWeight.w600,
                                        height: 1.2,
                                      ),
                                    ),
                                    const SizedBox(height: 24),

                                    CustomLabelPasswordField(
                                      obscure: true,
                                      label: 'Old password',
                                      controller: s.oldPwC,
                                      focusNode: s.oldPwFn,
                                      touched: s.oldTouched,
                                      error: s.oldError,
                                      onSubmitted: () => FocusScope.of(
                                        dialogCtx,
                                      ).requestFocus(s.newPwFn),
                                      placeholder: '',
                                    ),
                                    const SizedBox(height: 15),

                                    CustomLabelPasswordField(
                                      obscure: true,
                                      label: 'New password',
                                      controller: s.newPwC,
                                      focusNode: s.newPwFn,
                                      touched: s.newTouched,
                                      error: s.newError,
                                      onSubmitted: () => FocusScope.of(
                                        dialogCtx,
                                      ).requestFocus(s.confirmPwFn),
                                      placeholder: '',
                                    ),
                                    const SizedBox(height: 15),
                                    CustomLabelPasswordField(
                                      obscure: true,
                                      label: 'Confirm password',
                                      controller: s.confirmPwC,
                                      focusNode: s.confirmPwFn,
                                      touched: s.confirmTouched,
                                      error: s.confirmError,
                                      action: TextInputAction.done,
                                      onSubmitted: () =>
                                          FocusScope.of(dialogCtx).unfocus(),
                                      placeholder: '',
                                    ),

                                    const SizedBox(height: 16),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Expanded(
                                          child: TextButton(
                                            onPressed: () => Navigator.of(
                                              dialogCtx,
                                            ).pop(), // close the dialog
                                            style: TextButton.styleFrom(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 12,
                                                  ),
                                              alignment: Alignment
                                                  .centerLeft, // keep text left like before
                                              tapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                            ),
                                            child: Text(
                                              'Cancel',
                                              style: textTheme.h5.copyWith(
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),

                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: AnimatedSwitcher(
                                            duration: const Duration(
                                              milliseconds: 200,
                                            ),
                                            switchInCurve: Curves.easeOut,
                                            switchOutCurve: Curves.easeIn,
                                            child:
                                                (s.isResetLoading ||
                                                    !s.canSubmitReset)
                                                ? DisabledElevatedButton(
                                                    key: const ValueKey(
                                                      'disabled-reset',
                                                    ),
                                                    text: 'Reset',
                                                    onPressed: null,
                                                  )
                                                : ElevatedButton(
                                                    key: const ValueKey(
                                                      'enabled-reset',
                                                    ),
                                                    onPressed: () async {
                                                      final result =
                                                          await controller
                                                              .resetPassword();
                                                      result.fold(
                                                        (err) {
                                                          // Use the parent/provider context (page's scaffold)
                                                          // instead of the dialog's context. Looking up
                                                          // ancestors on the dialog context can fail if
                                                          // the dialog is being disposed, causing the
                                                          // "deactivated widget's ancestor" error.
                                                          AppSnackBar.show(
                                                            providerCtx,
                                                            message: err,
                                                            type:
                                                                AppSnackBarType
                                                                    .error,
                                                            icon: Icons
                                                                .error_outline,
                                                          );
                                                        },
                                                        (ok) {
                                                          Navigator.of(
                                                            dialogCtx,
                                                          ).pop();
                                                          AppSnackBar.show(
                                                            providerCtx,
                                                            message:
                                                                'Password reset successfully',
                                                            type:
                                                                AppSnackBarType
                                                                    .success,
                                                            icon: Icons
                                                                .check_circle_outline,
                                                          );
                                                          s.resetResetForm();
                                                        },
                                                      );
                                                    },

                                                    // Inside onPressed -> result.fold(...)
                                                    //   (err) {
                                                    //     // Use a stable, scaffold-owned context, not dialogCtx.
                                                    //     AppSnackBar.show(
                                                    //       providerCtx,
                                                    //       message: err,
                                                    //       type:
                                                    //           AppSnackBarType
                                                    //               .error,
                                                    //       icon: Icons
                                                    //           .error_outline,
                                                    //     );
                                                    //   },

                                                    //   (ok) {
                                                    //     Navigator.of(
                                                    //       dialogCtx,
                                                    //     ).pop();
                                                    //     // Defer to the next frame to avoid ancestor lookup during route removal.
                                                    //     WidgetsBinding
                                                    //         .instance
                                                    //         .addPostFrameCallback((
                                                    //           _,
                                                    //         ) {
                                                    //           AppSnackBar.show(
                                                    //             providerCtx,
                                                    //             message:
                                                    //                 'Password reset successfully',
                                                    //             type: AppSnackBarType
                                                    //                 .success,
                                                    //             icon: Icons
                                                    //                 .check_circle_outline,
                                                    //           );
                                                    //         });
                                                    //     s.resetResetForm();
                                                    //   },
                                                    // );
                                                    // },
                                                    child: const Text('Reset'),
                                                  ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
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
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: state,
      child: Consumer<WardenProfileState>(
        builder: (context, state, _) {
          final p =
              state.profile ??
              WardenModel(
                wardenId: '',
                empId: '',
                name: '',
                phoneNo: '',
                hostelId: const [],
                wardenRole: WardenRole.assistantWarden,
                email: '',
                languagePreference: null,
                hostels: const [],
              );

          final scheme = Theme.of(context).colorScheme;
          final mediaQuery = MediaQuery.of(context).size;
          final padding2 = EdgeInsets.symmetric(
            horizontal: 31 * mediaQuery.width / 402,
            vertical: 18,
          );

          final hostelsText = (p.hostels != null && p.hostels!.isNotEmpty)
              ? p.hostels!.join(', ')
              : ((p.hostels != null && p.hostels!.isEmpty)
                    ? p.hostels!.join(', ')
                    : '');

          return Scaffold(
            backgroundColor: const Color(0xFFE9E9E9),
            body: AppRefreshWrapper(
              onRefresh: () async {
                Future.delayed(Durations.long4 * 20);
                controller.initialize();
                FocusScope.of(context).unfocus();
              },
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    // removed top padding here because the parent layout (WardenLayout)
                    // already offsets its child by a headerTop. Having both adds an
                    // extra gap above the content. Keep horizontal padding only.
                    padding: EdgeInsets.only(
                      left: 25 * mediaQuery.width / 402,
                      right: 31 * mediaQuery.width / 402,
                      top: mediaQuery.height * 25 / 874,
                    ),
                    sliver: OneUiCollapsingHeader(
                      title: 'Profile',
                      vsync: this,
                      onBack: () => Navigator.of(context).maybePop(),
                      actions: const [],
                      backgroundColor: const Color(0xFFE9E9E9),
                      foregroundColor: scheme.onSurface,
                      expandedHeight: 57,
                      toolbarHeight: kToolbarHeight,
                      largeTitleTextStyle: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(
                            fontWeight: FontWeight.w600,
                            letterSpacing: -0.2,
                          ),
                      smallTitleTextStyle: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: SingleChildScrollView(
                      child: Container(
                        margin: padding2,
                        child: (state.isLoading)
                            ? Column(
                                children: [
                                  profileTopSkeleton(),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: shimmerBox(
                                          width: double.infinity,
                                          height: 45,
                                          borderRadius: 10,
                                        ),
                                      ),
                                      const SizedBox(width: 12),

                                      Expanded(
                                        child: shimmerBox(
                                          width: double.infinity,
                                          height: 45,
                                          borderRadius: 10,
                                        ),
                                      ),
                                    ],
                                  ),

                                  SizedBox(height: 8),
                                  const Divider(),
                                  SizedBox(height: 8),
                                  shimmerBox(
                                    width: double.infinity,
                                    height: 250,
                                    borderRadius: 20,
                                  ),
                                ],
                              )
                            : Column(
                                children: [
                                  // Avatar (no edit actions on Warden page)
                                  CircleAvatar(
                                    radius: 48,
                                    backgroundImage:
                                        (p.profilePicUrl != null &&
                                            p.profilePicUrl!.isNotEmpty)
                                        ? NetworkImage(p.profilePicUrl!)
                                        : null,
                                    backgroundColor: Colors.blue.shade100,
                                    child:
                                        (p.profilePicUrl == null ||
                                            p.profilePicUrl!.isEmpty)
                                        ? Text(
                                            _initials(p.name),
                                            style: const TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue,
                                            ),
                                          )
                                        : null,
                                  ),

                                  const SizedBox(height: 12),

                                  // Name and email
                                  Text(
                                    p.name,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    p.email ?? '',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade700,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),

                                  const SizedBox(height: 16),

                                  // Action row: Change pwd + Logout
                                  Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton.icon(
                                          onPressed: () {
                                            _showResetPasswordGlassDialog(
                                              context,
                                            );
                                          },
                                          icon: const Icon(Icons.key),
                                          label: const Text(
                                            "Change pwd",
                                            style: TextStyle(
                                              color: Colors.black,
                                            ),
                                          ),

                                          style: OutlinedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 14,
                                              horizontal: 15,
                                            ),
                                            iconColor: Colors.black,

                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: ElevatedButton.icon(
                                          icon: const Icon(Icons.logout),
                                          label: const Text('Logout'),
                                          onPressed: () async {
                                            LoginController.logout(context);
                                          },
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 8),
                                  const Divider(),
                                  const SizedBox(height: 8),

                                  _section('Warden Info', [
                                    _infoRow('Employee ID', p.empId),
                                    _infoRow('Phone No', p.phoneNo),
                                    _infoRow('Email', p.email ?? ''),
                                    _infoRow('Hostels', hostelsText),
                                    _infoRow('Role', p.wardenRole.displayName),
                                  ]),

                                  const SizedBox(height: 24),
                                  Container(
                                    height:
                                        84 +
                                        MediaQuery.of(
                                          context,
                                        ).viewPadding.bottom,
                                  ),
                                ],
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

  Widget _section(String title, List<Widget> rows) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE0E0E0)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          const SizedBox(height: 8),
          ...rows,
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    ),
  );

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }
}
