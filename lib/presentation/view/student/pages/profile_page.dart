// lib/presentation/view/profile/pages/profile_page.dart
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hostel_mgmt/core/enums/ui_eums/snackbar_type.dart';
import 'package:hostel_mgmt/core/helpers/app_refreasher_widget.dart';
import 'package:hostel_mgmt/core/helpers/app_snackbar.dart';
import 'package:hostel_mgmt/core/theme/app_theme.dart';
import 'package:hostel_mgmt/models/parent_model.dart';
import 'package:hostel_mgmt/models/student_profile.dart';
import 'package:hostel_mgmt/presentation/widgets/collapsing_header.dart';
import 'package:hostel_mgmt/presentation/widgets/shimmer_box.dart';
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

  // // In ProfilePage (stateful), add this helper:
  // void _showResetPasswordSheet() {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     useRootNavigator: true,
  //     showDragHandle: true,
  //     builder: (sheetCtx) {
  //       return ChangeNotifierProvider<ProfileState>.value(
  //         value: state, // reuse the same instance
  //         child: Consumer<ProfileState>(
  //           builder: (c, s, _) {
  //             final viewInsets = MediaQuery.of(sheetCtx).viewInsets;
  //             final textTheme = Theme.of(sheetCtx).textTheme;

  //             return Padding(
  //               padding: EdgeInsets.only(
  //                 bottom: viewInsets.bottom,
  //                 left: 16,
  //                 right: 16,
  //                 top: 12,
  //               ),
  //               child: SafeArea(
  //                 top: false,
  //                 child: Consumer<ProfileState>(
  //                   builder: (context, s, _) {
  //                     Widget floatingPasswordField({
  //                       required String label,
  //                       required TextEditingController controller,
  //                       required bool touched,
  //                       required String? error,
  //                       FocusNode? focusNode,
  //                       VoidCallback? onEditingComplete,
  //                     }) {
  //                       return TextFormField(
  //                         controller: controller,
  //                         focusNode: focusNode,
  //                         obscureText: true,
  //                         obscuringCharacter: '•',
  //                         enableSuggestions: false,
  //                         autocorrect: false,
  //                         textInputAction: TextInputAction.next,
  //                         onEditingComplete: onEditingComplete,
  //                         decoration: InputDecoration(
  //                           labelText: label, // label sits inside initially
  //                           hintText: label, // optional: subtle hint text
  //                           floatingLabelBehavior: FloatingLabelBehavior
  //                               .auto, // floats on focus/text
  //                           filled: true,
  //                           fillColor: Colors.white,
  //                           isDense: true,
  //                           contentPadding: const EdgeInsets.symmetric(
  //                             horizontal: 12,
  //                             vertical: 14,
  //                           ),
  //                           border: OutlineInputBorder(
  //                             borderRadius: BorderRadius.circular(10),
  //                           ),
  //                           enabledBorder: OutlineInputBorder(
  //                             borderRadius: BorderRadius.circular(10),
  //                             borderSide: BorderSide(
  //                               color: Colors.grey.shade300,
  //                               width: 1.2,
  //                             ),
  //                           ),
  //                           errorText: touched
  //                               ? error
  //                               : null, // show error below when touched
  //                         ),
  //                       );
  //                     }

  //                     return Column(
  //                       mainAxisSize: MainAxisSize.min,
  //                       children: [
  //                         const SizedBox(height: 4),
  //                         Text('Reset Password', style: textTheme.titleLarge),
  //                         const SizedBox(height: 12),
  //                         floatingPasswordField(
  //                           label: 'Old password',
  //                           controller: s.oldPwC,
  //                           touched: s.oldTouched,
  //                           error: s.oldError,
  //                         ),
  //                         const SizedBox(height: 10),
  //                         floatingPasswordField(
  //                           label: 'New password',
  //                           controller: s.newPwC,
  //                           touched: s.newTouched,
  //                           error: s.newError,
  //                         ),
  //                         const SizedBox(height: 10),
  //                         floatingPasswordField(
  //                           label: 'Confirm password',
  //                           controller: s.confirmPwC,
  //                           touched: s.confirmTouched,
  //                           error: s.confirmError,
  //                         ),
  //                         const SizedBox(height: 16),
  //                         Row(
  //                           children: [
  //                             Expanded(
  //                               child: ElevatedButton(
  //                                 onPressed: s.isResetLoading
  //                                     ? null
  //                                     : () {
  //                                         Navigator.of(sheetCtx).maybePop();
  //                                       },
  //                                 child: const Text('Cancel'),
  //                               ),
  //                             ),
  //                             const SizedBox(width: 12),
  //                             Expanded(
  //                               child: ElevatedButton(
  //                                 onPressed: s.canSubmitReset
  //                                     ? () async {
  //                                         print("Resetting password...");
  //                                         final result = await controller
  //                                             .resetPassword();
  //                                         result.fold(
  //                                           (err) {
  //                                             // Keep sheet open, show error
  //                                             AppSnackBar.show(
  //                                               sheetCtx,
  //                                               message: err,
  //                                               type: AppSnackBarType.error,
  //                                               icon: Icons.error_outline,
  //                                             );
  //                                           },
  //                                           (ok) {
  //                                             // Success: close and show success
  //                                             Navigator.of(sheetCtx).pop();
  //                                             AppSnackBar.show(
  //                                               context, // parent scaffold context
  //                                               message:
  //                                                   'Password reset successfully',
  //                                               type: AppSnackBarType.success,
  //                                               icon:
  //                                                   Icons.check_circle_outline,
  //                                             );
  //                                             state.resetResetForm();
  //                                           },
  //                                         );
  //                                       }
  //                                     : null, // disabled until valid
  //                                 child: s.isResetLoading
  //                                     ? const SizedBox(
  //                                         width: 18,
  //                                         height: 18,
  //                                         child: CircularProgressIndicator(
  //                                           strokeWidth: 2,
  //                                         ),
  //                                       )
  //                                     : const Text('Reset'),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                         const SizedBox(height: 16),
  //                       ],
  //                     );
  //                   },
  //                 ),
  //               ),
  //             );
  //           },
  //         ),
  //       );
  //     },
  //   );
  // }
  // In your ProfilePage State class:
  // 1) Accept a context that is UNDER the provider
  // Call this with a provider-scoped BuildContext (e.g., inside Consumer builder)
  void _showResetPasswordGlassDialog(BuildContext providerCtx) {
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

        // In your dialog/widget code
        Widget floatingPasswordField({
          required String label,
          required TextEditingController controller,
          required FocusNode focusNode,
          required bool touched,
          required String? error,
          TextInputAction action = TextInputAction.next,
          VoidCallback? onSubmitted,
        }) {
          // Mirrors FloatingLabelBehavior.auto: floats on focus or when has text
          final bool isFloating =
              focusNode.hasFocus || controller.text.isNotEmpty;
          final Color fill = isFloating ? Colors.transparent : Colors.white;

          return TextFormField(
            key: ValueKey(label),
            controller: controller,
            focusNode: focusNode,
            obscureText: true,
            obscuringCharacter: '•',
            enableSuggestions: false,
            autocorrect: false,
            textInputAction: action,
            onFieldSubmitted: (_) => onSubmitted?.call(),
            decoration: InputDecoration(
              labelText: label, // label inside initially [web:60]
              hintText: label, // optional hint [web:60]
              floatingLabelBehavior:
                  FloatingLabelBehavior.auto, // float on focus/text [web:59]
              filled: true, // enable background fill [web:60]
              fillColor:
                  fill, // white when idle/empty, transparent when floating [web:122]
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.black),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade300, width: 1.2),
              ),
              errorText: touched
                  ? error
                  : null, // Material error handling [web:60]
            ),
          );
        }

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
                        color: Colors.white.withOpacity(0.15),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
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
                                      'Reset Password',
                                      style: Theme.of(
                                        dialogCtx,
                                      ).textTheme.titleLarge,
                                    ),
                                    const SizedBox(height: 12),

                                    floatingPasswordField(
                                      label: 'Old password',
                                      controller: s.oldPwC,
                                      focusNode: s.oldPwFn,
                                      touched: s.oldTouched,
                                      error: s.oldError,
                                      onSubmitted: () => FocusScope.of(
                                        dialogCtx,
                                      ).requestFocus(s.newPwFn),
                                    ),
                                    const SizedBox(height: 10),

                                    floatingPasswordField(
                                      label: 'New password',
                                      controller: s.newPwC,
                                      focusNode: s.newPwFn,
                                      touched: s.newTouched,
                                      error: s.newError,
                                      onSubmitted: () => FocusScope.of(
                                        dialogCtx,
                                      ).requestFocus(s.confirmPwFn),
                                    ),
                                    const SizedBox(height: 10),

                                    floatingPasswordField(
                                      label: 'Confirm password',
                                      controller: s.confirmPwC,
                                      focusNode: s.confirmPwFn,
                                      touched: s.confirmTouched,
                                      error: s.confirmError,
                                      action: TextInputAction.done,
                                      onSubmitted: () =>
                                          FocusScope.of(dialogCtx).unfocus(),
                                    ),

                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: OutlinedButton(
                                            onPressed: s.isResetLoading
                                                ? null
                                                : () => Navigator.of(
                                                    dialogCtx,
                                                  ).maybePop(),
                                            child: const Text('Cancel'),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: s.canSubmitReset
                                                ? () async {
                                                    final result = await controller
                                                        .resetPassword(); // token handled internally
                                                    result.fold(
                                                      (err) {
                                                        AppSnackBar.show(
                                                          providerCtx, // parent scaffold context
                                                          message: err,
                                                          type: AppSnackBarType
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
                                                          type: AppSnackBarType
                                                              .success,
                                                          icon: Icons
                                                              .check_circle_outline,
                                                        );
                                                        s.resetResetForm();
                                                      },
                                                    );
                                                  }
                                                : null,
                                            child: s.isResetLoading
                                                ? const SizedBox(
                                                    width: 18,
                                                    height: 18,
                                                    child:
                                                        CircularProgressIndicator(
                                                          strokeWidth: 2,
                                                        ),
                                                  )
                                                : const Text('Reset'),
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
                      left: 31 * mediaQuery.width / 402,
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
                                  const Divider(),
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
                                        right: -2,
                                        child: FloatingActionButton.small(
                                          heroTag: 'edit-avatar',
                                          backgroundColor: Colors.blue,
                                          foregroundColor: Colors.white,
                                          elevation: 1,
                                          onPressed: state.isUploadingPic
                                              ? null
                                              : _showPickSheet,
                                          child: state.isUploadingPic
                                              ? const SizedBox(
                                                  width: 16,
                                                  height: 16,
                                                  child:
                                                      CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                      ),
                                                )
                                              : const Icon(
                                                  Icons.camera_alt_outlined,
                                                  size: 18,
                                                ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  // const SizedBox(height: 16),

                                  // Name emphasized
                                  Text(
                                    p.name,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    p.email,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade700,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 8),

                                  // ...inside the non-loading Column, just before:
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton.icon(
                                          icon: const Icon(Icons.lock_reset),
                                          label: const Text('Reset pwd'),
                                          style: ButtonStyle(
                                            backgroundColor:
                                                WidgetStateProperty.all(
                                                  Colors.blue,
                                                ),
                                          ),
                                          onPressed: () {
                                            _showResetPasswordGlassDialog(
                                              context,
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: ElevatedButton.icon(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                WidgetStateProperty.all(
                                                  Colors.red,
                                                ),
                                          ),

                                          icon: const Icon(Icons.logout),
                                          label: const Text('Logout'),
                                          onPressed: () async {},
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 8),
                                  const Divider(),
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
