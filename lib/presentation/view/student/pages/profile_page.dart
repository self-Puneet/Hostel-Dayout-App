// lib/presentation/view/profile/pages/profile_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hostel_mgmt/core/helpers/app_refreasher_widget.dart';
import 'package:hostel_mgmt/presentation/widgets/collapsing_header.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../state/profile_state.dart';
import '../controllers/profile_controller.dart';
import 'package:hostel_mgmt/services/profile_service.dart';

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

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: state,
      child: Consumer<ProfileState>(
        builder: (context, state, _) {
          if (state.isLoading || state.profile == null) {
            return const Center(child: CircularProgressIndicator());
          }
          final p = state.profile!;
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
                await Future.delayed(const Duration(seconds: 1)); // await!
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
                        child: Column(
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
                                        color: Colors.black.withOpacity(0.06),
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
                                            child: CircularProgressIndicator(
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

                            const SizedBox(height: 16),
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
                                p.parents.isNotEmpty ? p.parents[0].name : '',
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
                                  MediaQuery.of(context).viewPadding.bottom,
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
