import 'package:flutter/material.dart';
import 'package:hostel_mgmt/core/helpers/app_refreasher_widget.dart';
import 'package:hostel_mgmt/presentation/view/parent/controllers/parent_profile_controller.dart';
import 'package:hostel_mgmt/presentation/view/parent/state/parent_profile_state.dart';
import 'package:hostel_mgmt/presentation/widgets/collapsing_header.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:hostel_mgmt/services/profile_service.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ParentProfilePage extends StatefulWidget {
  const ParentProfilePage({Key? key}) : super(key: key);

  @override
  State<ParentProfilePage> createState() => _ParentProfilePageState();
}

class _ParentProfilePageState extends State<ParentProfilePage>
    with SingleTickerProviderStateMixin {
  late final ParentProfileState state;
  late final ParentProfileController controller;
  final ImagePicker _picker = ImagePicker();

  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    state = ParentProfileState();
    controller = ParentProfileController(
      state: state,
      service: ProfileService(),
    );
    _pageController = PageController();
    controller.initialize();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: state,
      child: Consumer<ParentProfileState>(
        builder: (context, state, _) {
          // Loading
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error
          if (state.isErrored) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(state.errorMessage ?? 'Failed to load profile'),
              ),
            );
          }

          // Empty
          final students = state.studentProfileModel;
          if (students.isEmpty) {
            return const Center(child: Text('No profile found'));
          }

          // Data
          final p = state.parentModel;
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
                await Future.delayed(const Duration(milliseconds: 300));
                FocusScope.of(context).unfocus();
                await controller.initialize();
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

                  // IMPORTANT: No SingleChildScrollView here; SliverToBoxAdapter is enough
                  SliverToBoxAdapter(
                    child: Container(
                      margin: padding2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Avatar + camera button
                          Center(
                            child: Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withAlpha(
                                          (0.06 * 255).toInt(),
                                        ),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    radius: 48,
                                    backgroundImage: null, // add when available
                                    backgroundColor: Colors.blue.shade100,
                                    child: Text(
                                      _initials(p?.name ?? students.first.name),
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 12),
                          Center(
                            child: Text(
                              p?.name ?? 'Parent',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          if (p?.phoneNo != null) ...[
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.phone,
                                  size: 16,
                                  color: Colors.grey.shade700,
                                ),
                                const SizedBox(width: 6),
                                Center(
                                  child: Text(
                                    p!.phoneNo,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey.shade700,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),
                          ],

                          const Divider(),
                          const SizedBox(height: 8),

                          if (p != null)
                            _section('Parent Info', [
                              _infoRow('Name', p.name),
                              _infoRow('Relation', p.relation),
                              _infoRow('Phone No', p.phoneNo),
                            ]),

                          if (students.length > 1) const SizedBox(height: 12),
                          if (students.length > 1)
                            Center(
                              child: SmoothPageIndicator(
                                controller: _pageController,
                                count: students.length,
                                effect: JumpingDotEffect(
                                  dotHeight: 9,
                                  dotWidth: 9,
                                  activeDotColor: Colors.black,
                                  dotColor: Colors.grey[300]!,
                                  jumpScale: 1,
                                ),
                              ),
                            ),

                          const SizedBox(height: 16),
                          const Divider(),
                          const SizedBox(height: 8),

                          // Constrained PageView for multiple children
                          SizedBox(
                            height:
                                260, // give a fixed height to bound PageView
                            child: PageView.builder(
                              controller: _pageController,
                              itemCount: students.length,
                              itemBuilder: (context, index) {
                                final s = students[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  child: _section('Student Info', [
                                    _infoRow('Enrollment No', s.enrollmentNo),
                                    _infoRow('Phone No', s.phoneNo),
                                    _infoRow('Hostel', s.hostelName),
                                    _infoRow('Room No', s.roomNo),
                                    _infoRow('Branch', s.branch),
                                    _infoRow('Semester', s.semester.toString()),
                                  ]),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            height:
                                84 + MediaQuery.of(context).viewPadding.bottom,
                          ),
                        ],
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
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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
