import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hostel_mgmt/core/enums/ui_eums/snackbar_type.dart';
import 'package:hostel_mgmt/core/helpers/app_refreasher_widget.dart';
import 'package:hostel_mgmt/core/helpers/app_snackbar.dart';
import 'package:hostel_mgmt/core/theme/app_theme.dart';
import 'package:hostel_mgmt/core/theme/elevated_button_theme.dart';
import 'package:hostel_mgmt/login/login_controller.dart';
import 'package:hostel_mgmt/models/parent_model.dart';
import 'package:hostel_mgmt/models/student_profile.dart';
import 'package:hostel_mgmt/presentation/widgets/collapsing_header.dart';
import 'package:hostel_mgmt/presentation/widgets/shimmer_box.dart';
import 'package:hostel_mgmt/presentation/widgets/text_field.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../state/profile_state.dart';
import '../controllers/profile_controller.dart';
import 'package:hostel_mgmt/services/profile_service.dart';
import '../../../components/skeleton_loaders/profile_page_skeleton.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late final ProfileState state;
  late final ProfileController controller;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    state = ProfileState();
    controller = ProfileController(state: state, service: ProfileService());
    controller.initialize();
  }

  Future<void> _pickAndUpload(ImageSource source) async {
    final xfile = await _picker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 1024,
    );
    if (xfile == null) return;
    await controller.updateProfilePicture(File(xfile.path));
  }

  void _showPickSheet() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      useRootNavigator: true, // <-- key line
      isScrollControlled: true,
      builder: (ctx) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(ctx);
                _pickAndUpload(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(ctx);
                _pickAndUpload(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showResetPasswordGlassDialog(BuildContext providerCtx) {
    final textTheme = Theme.of(context).textTheme;
    showDialog(
      context: providerCtx,
      barrierDismissible: false, // do not close on outside tap
      barrierLabel: 'Dismiss',
      barrierColor: Colors.black26, // subtle dim
      // transitionDuration: const Duration(milliseconds: 250),
      useRootNavigator: false, // keep under same navigator/provider subtree
      builder: (dialogCtx) {
        final mq = MediaQuery.of(dialogCtx);
        final bottomInset = mq.viewInsets.bottom;

        // Provide state above the entire dialog so both content and actions can read it
        return ChangeNotifierProvider<ProfileState>.value(
          value: state,
          child: Padding(
            // Lift the dialog above the keyboard to avoid overflow
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
                  // Glass background layer (non-interactive)
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

                  // Foreground card with content
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
                            child: Consumer<ProfileState>(
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
                                      // icon: Icons.lock_outline,
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
                                      // icon: Icons.lock,
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
                                      // icon: Icons.check_circle_outline,
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
                                                    onPressed:
                                                        null, // fully untappable
                                                  )
                                                : ElevatedButton(
                                                    key: const ValueKey(
                                                      'enabled-reset',
                                                    ),
                                                    style:
                                                        ElevatedButton.styleFrom(
                                                          textStyle:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .h5
                                                                  .copyWith(
                                                                    height: 1.0,
                                                                  ),
                                                        ),

                                                    onPressed: () async {
                                                      final result =
                                                          await controller
                                                              .resetPassword();
                                                      result.fold(
                                                        (err) {
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
      child: Consumer<ProfileState>(
        builder: (context, state, _) {
          final p =
              state.profile ??
              StudentProfileModel(
                studentId: '',
                enrollmentNo: "",
                name: "",
                email: "",
                phoneNo: "",
                hostelName: "",
                roomNo: "",
                semester: 0,
                branch: "",
                parents: [
                  ParentModel(
                    parentId: "",
                    name: "",
                    relation: "",
                    phoneNo: "",
                  ),
                ],
              );
          final scheme = Theme.of(context).colorScheme;
          final mediaQuery = MediaQuery.of(context).size;
          final padding2 = EdgeInsets.symmetric(
            horizontal: 31 * mediaQuery.width / 402,
            vertical: 18,
          );

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
                    padding: EdgeInsets.only(
                      left: 25 * mediaQuery.width / 402,
                      right: 31 * mediaQuery.width / 402,
                      top: mediaQuery.height * 25 / 874,
                    ),
                    sliver: OneUiCollapsingHeader(
                      // overallBackgroundColor: const Color(0xFFE9E9E9),
                      title: 'Profile',
                      vsync: this, // NEW
                      onBack: () => Navigator.of(context).maybePop(),
                      actions: [/* ... */],
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
                  // Render the profile section ONCE using SliverToBoxAdapter.
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
                                    height: 272,
                                    borderRadius: 20,
                                  ),

                                  const SizedBox(height: 16),
                                  const Divider(),
                                  const SizedBox(height: 8),

                                  shimmerBox(
                                    width: double.infinity,
                                    height: 200,
                                    borderRadius: 20,
                                  ),
                                  // parentInfoSkeleton(),
                                ],
                              )
                            : Column(
                                children: [
                                  // Replace the original Stack with this widget.
                                  Stack(
                                    clipBehavior: Clip.none,
                                    alignment: Alignment.center,
                                    children: [
                                      // White ring + subtle shadow around the avatar
                                      Container(
                                        padding: const EdgeInsets.all(
                                          3,
                                        ), // ring thickness
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withAlpha(
                                                (0.06 * 225).toInt(),
                                              ),
                                              blurRadius: 8,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: CircleAvatar(
                                          radius: 48,
                                          backgroundImage:
                                              (p.profilePic != null &&
                                                  p.profilePic!.isNotEmpty)
                                              ? NetworkImage(p.profilePic!)
                                              : null,
                                          backgroundColor: Colors.blue.shade100,
                                          child:
                                              (p.profilePic == null ||
                                                  p.profilePic!.isEmpty)
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
                                      ),

                                      // Small blue camera FAB pinned to the bottom-right
                                      Positioned(
                                        bottom: -2,
                                        right: 2,
                                        child: Container(
                                          width: 30, // smaller width than FAB
                                          height: 30, // smaller height than FAB
                                          decoration: BoxDecoration(
                                            color: Colors.blue,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ), // circular shape
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(
                                                  0.2,
                                                ),
                                                blurRadius: 2,
                                                offset: Offset(0, 1),
                                              ),
                                            ],
                                          ),
                                          child: IconButton(
                                            icon: state.isUploadingPic
                                                ? const Icon(
                                                    Icons.cloud_upload,
                                                    size: 16,
                                                    color: Colors.white,
                                                  )
                                                : const Icon(
                                                    Icons.camera_alt_outlined,
                                                    size: 16,
                                                    color: Colors.white,
                                                  ),
                                            onPressed: state.isUploadingPic
                                                ? null
                                                : _showPickSheet,
                                            padding: EdgeInsets.zero,
                                            constraints: BoxConstraints(),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 12),

                                  // Name emphasized
                                  Text(
                                    p.name,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    p.email,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade700,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 16),

                                  // ...inside the non-loading Column, just before:
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
                                            iconColor: Colors.black,
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 12,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
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
                                  Padding(
                                    padding: EdgeInsetsGeometry.symmetric(),
                                    child: const Divider(),
                                  ),
                                  const SizedBox(height: 8),

                                  _section('Student Info', [
                                    _infoRow('Enrollment No', p.enrollmentNo),
                                    _infoRow('Phone No', p.phoneNo),
                                    _infoRow('Hostel', p.hostelName),
                                    _infoRow('Room No', p.roomNo),
                                    _infoRow('Branch', p.branch),
                                    _infoRow('Semester', p.semester.toString()),
                                  ]),

                                  const SizedBox(height: 16),
                                  const Divider(),
                                  const SizedBox(height: 8),

                                  _section('Parent Info', [
                                    _infoRow(
                                      'Name',
                                      p.parents.isNotEmpty
                                          ? p.parents[0].name
                                          : '',
                                    ),
                                    _infoRow(
                                      'Relation',
                                      p.parents.isNotEmpty
                                          ? p.parents[0].relation
                                          : '',
                                    ),
                                    _infoRow(
                                      'Phone No',
                                      p.parents.isNotEmpty
                                          ? p.parents[0].phoneNo
                                          : '',
                                    ),
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
