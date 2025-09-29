// lib/presentation/view/student/pages/home.dart
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:go_router/go_router.dart';
import 'package:hostel_mgmt/core/enums/enum.dart';
import 'package:hostel_mgmt/core/routes/app_route_constants.dart';
import 'package:hostel_mgmt/core/rumtime_state/login_session.dart';
import 'package:hostel_mgmt/presentation/components/active_request_card.dart';
import 'package:hostel_mgmt/presentation/components/simple_request_card.dart';
import 'package:hostel_mgmt/presentation/view/student/controllers/home_controller.dart';
import 'package:hostel_mgmt/presentation/view/student/state/home_state.dart';
import 'package:hostel_mgmt/presentation/widgets/clickable_text.dart';
import 'package:hostel_mgmt/presentation/widgets/dropdown.dart';
import 'package:hostel_mgmt/presentation/widgets/welcome_header.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

// Only the structural changes are shown; business logic and widgets untouched.
class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final padding = EdgeInsets.symmetric(
      horizontal: 31 * mediaQuery.size.width / 402,
    );

    // Keep exactly the same top spacing as before.
    final topGap = mediaQuery.size.height * 50 / 874;

    return MultiProvider(
      providers: [
        Provider<HomeController>(create: (_) => HomeController()),
        ChangeNotifierProvider<HomeState>(
          create: (ctx) => ctx.read<HomeController>().state,
        ),
      ],
      builder: (context, _) {
        return Consumer<HomeState>(
          builder: (context, state, __) {
            final activeRequests = state.activeRequests;
            final hasMultiple = activeRequests.length > 1;
            final profile = Get.find<LoginSession>();

            final dropdown = Dropdown<String>(
              items: state.statusOptions
                  .map(
                    (status) =>
                        DropdownMenuItem(value: status, child: Text(status)),
                  )
                  .toList(),
              value: state.selectedStatus,
              onChanged: (value) {
                if (value != null) {
                  state.setSelectedStatus(value);
                }
              },
            );

            // Header is now OUTSIDE the refreshable area.
            return Column(
              children: [
                // Top spacing (unchanged) - fixed
                SizedBox(height: topGap),

                // Welcome header - fixed
                Container(
                  margin: padding,
                  child: WelcomeHeader(
                    phoneNumber: profile.phone,
                    enrollmentNumber: profile.identityId,
                    hostelName: profile.hostel,
                    roomNumber: profile.roomNo,
                    actor: TimelineActor.student,
                    name: state.profile?.name ?? '',
                    avatarUrl: state.profile?.profilePic,
                    greeting: 'Welcome,',
                  ),
                ),

                const SizedBox(height: 20),

                // Scrollable + refreshable content BELOW header
                Expanded(
                  child: RefreshIndicator(
                    color: Colors.deepPurple,
                    backgroundColor: Colors.white,
                    strokeWidth: 3,
                    displacement: 60,
                    // edgeOffset omitted: the list edge is already under the fixed header
                    onRefresh: () async {
                      state.clear();
                      await context
                          .read<HomeController>()
                          .fetchProfileAndRequests();
                    },
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      children: [
                        if (hasMultiple) ...[
                          SizedBox(
                            height: 330,
                            child: PageView.builder(
                              controller: _pageController,
                              itemCount: activeRequests.length,
                              itemBuilder: (context, index) {
                                final req = activeRequests[index];
                                return Container(
                                  margin: padding,
                                  child: ActiveRequestCard(
                                    actor: TimelineActor.student,
                                    reason: req.reason,
                                    requestId: req.requestId,
                                    requestType: req.requestType.name
                                        .toUpperCase(),
                                    status: req.status,
                                    fromDate: req.appliedFrom,
                                    toDate: req.appliedTo,
                                    timeline: Container(), // timeline widget
                                  ),
                                );
                              },
                            ),
                          ),
                          Center(
                            child: SmoothPageIndicator(
                              controller: _pageController,
                              count: activeRequests.length,
                              effect: JumpingDotEffect(
                                dotHeight: 9,
                                dotWidth: 9,
                                activeDotColor: Colors.black,
                                dotColor: Colors.grey[300]!,
                                jumpScale: 1,
                              ),
                            ),
                          ),
                        ] else if (activeRequests.isNotEmpty) ...[
                          Container(
                            margin: padding,
                            child: ActiveRequestCard(
                              
                                            actor: TimelineActor.student,
                              reason: activeRequests.first.reason,
                              requestId: activeRequests.first.requestId,
                              requestType: activeRequests.first.requestType.name
                                  .toUpperCase(),
                              status: activeRequests.first.status,
                              fromDate: activeRequests.first.appliedFrom,
                              toDate: activeRequests.first.appliedTo,
                              timeline: Container(), // timeline widget
                            ),
                          ),
                        ] else ...[
                          Container(
                            margin: padding,
                            height: 330,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(28),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.25),
                                    offset: const Offset(0, 0),
                                    blurRadius: 14,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              margin: const EdgeInsets.symmetric(
                                horizontal: 0,
                                vertical: 24,
                              ),
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 20,
                                ),
                                child: Center(
                                  child: Text("No active requests"),
                                ),
                              ),
                            ),
                          ),
                        ],

                        const SizedBox(height: 18),

                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: mediaQuery.size.width * 44 / 402,
                          ),
                          child: const Divider(
                            thickness: 1,
                            color: Color(0xFF757575),
                          ),
                        ),

                        Container(
                          margin: EdgeInsets.symmetric(
                            horizontal: 36 * mediaQuery.size.width / 402,
                            vertical: 20,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const Text(
                                    'History',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w500,
                                      fontSize: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  dropdown,
                                ],
                              ),
                              ClickableText(
                                text: "See all",
                                onTap: () {
                                  context.push(AppRoutes.history);
                                },
                              ),
                            ],
                          ),
                        ),

                        Container(
                          margin: padding,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 26,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: const Color.fromRGBO(117, 117, 117, 1),
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: state.filteredRequests == null
                                ? const Center(child: Text('No requests found'))
                                : SimpleRequestCard(
                                    requestType:
                                        state.filteredRequests!.requestType,
                                    fromDate:
                                        state.filteredRequests!.appliedFrom,
                                    toDate: state.filteredRequests!.appliedTo,
                                    status: state.filteredRequests!.status,
                                    statusDate:
                                        state.filteredRequests!.lastUpdatedAt,
                                    reason: state.filteredRequests!.reason,
                                  ),
                          ),
                        ),

                        // Spacer for bottom safe area as before
                        Container(
                          height:
                              184 + MediaQuery.of(context).viewPadding.bottom,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
