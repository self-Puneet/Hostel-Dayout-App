// presentation/view/parent/pages/parent_home.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:hostel_mgmt/core/enums/request_status.dart';
import 'package:hostel_mgmt/core/enums/timeline_actor.dart';
import 'package:hostel_mgmt/core/helpers/app_refreasher_widget.dart';
import 'package:hostel_mgmt/core/routes/app_route_constants.dart';
import 'package:hostel_mgmt/core/rumtime_state/login_session.dart';
import 'package:hostel_mgmt/core/theme/app_theme.dart';
import 'package:hostel_mgmt/presentation/components/active_request_card.dart';
import 'package:hostel_mgmt/presentation/components/simple_request_card.dart';
import 'package:hostel_mgmt/presentation/components/skeleton_loaders/active_request_card_skeleton.dart';
import 'package:hostel_mgmt/presentation/components/skeleton_loaders/simple_request_card_skeleton.dart';
import 'package:hostel_mgmt/presentation/view/parent/controllers/parent_home_controller.dart';
import 'package:hostel_mgmt/presentation/widgets/clickable_text.dart';
import 'package:hostel_mgmt/presentation/widgets/dropdown.dart';
import 'package:hostel_mgmt/presentation/widgets/welcome_header.dart';
import 'package:provider/provider.dart';
import 'package:hostel_mgmt/presentation/view/parent/state/parent_state.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ParentHomePage extends StatefulWidget {
  const ParentHomePage({Key? key}) : super(key: key);

  @override
  State<ParentHomePage> createState() => _ParentHomePageState();
}

class _ParentHomePageState extends State<ParentHomePage> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final mediaQuery = MediaQuery.of(context);
    final padding = EdgeInsets.symmetric(
      horizontal: 31 * mediaQuery.size.width / 402,
    );
    final topGap = mediaQuery.size.height * 50 / 874;

    Widget yourRequestsTitle() {
      return Container(
        margin: padding + const EdgeInsets.only(left: 12),
        child: Text(
          'Your Requests',
          style: textTheme.h1.copyWith(fontWeight: FontWeight.w600),
        ),
      );
    }

    return Consumer<ParentState>(
      builder: (context, state, _) {
        // Trigger initial fetch only when no data has been loaded yet
        if (!state.isLoading && !state.hasData) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ParentHomeController(state).fetchActiveRequests();
          });
        }

        final loginSession = Get.find<LoginSession>();
        final activeRequests = state.activeRequests;
        final hasMultiple = activeRequests.length > 1;
        final isParent = loginSession.role.name == 'parent';

        final dropdown = Dropdown<String>(
          items: state.statusOptions
              .map(
                (status) => DropdownMenuItem(
                  value: status,
                  child: Text(status, style: textTheme.h5),
                ),
              )
              .toList(),
          value: state.selectedStatus,
          onChanged: (value) {
            if (value != null) {
              state.setSelectedStatus(value);
            }
          },
        );

        Widget activeRequestView() {
          if (state.isLoading) {
            return Container(
              margin: padding,
              height: 360,
              child: activeRequestCardSkeleton(actionButton: true),
            );
          }
          if (hasMultiple) {
            return SizedBox(
              height: 360,
              child: PageView.builder(
                controller: _pageController,
                itemCount: activeRequests.length,
                itemBuilder: (context, index) {
                  final req = activeRequests[index];
                  final controller = ParentHomeController(state);
                  final bool canAct =
                      isParent &&
                      req.status == RequestStatus.referred &&
                      !state.isActioning;

                  return Container(
                    margin: padding,
                    child: ActiveRequestCard(
                      actor: TimelineActor.parent,
                      showActions: true,
                      reason: req.reason,
                      requestId: req.requestId,
                      requestType: req.requestType,
                      status: req.status,
                      fromDate: req.appliedFrom,
                      toDate: req.appliedTo,
                      timeline: Container(),
                      onApprove: canAct
                          ? () => controller.approveById(req.requestId)
                          : null,
                      onDecline: canAct
                          ? () => controller.rejectById(req.requestId)
                          : null,
                    ),
                  );
                },
              ),
            );
          } else if (activeRequests.isNotEmpty) {
            final req = activeRequests.first;
            final bool canAct =
                isParent &&
                req.status == RequestStatus.referred &&
                !state.isActioning;

            return Container(
              margin: padding,
              child: ActiveRequestCard(
                actor: TimelineActor.parent,
                showActions: true,
                reason: req.reason,
                requestId: req.requestId,
                requestType: req.requestType,
                status: req.status,
                fromDate: req.appliedFrom,
                toDate: req.appliedTo,
                timeline: Container(),
                onApprove: canAct
                    ? () =>
                          ParentHomeController(state).approveById(req.requestId)
                    : null,
                onDecline: canAct
                    ? () =>
                          ParentHomeController(state).rejectById(req.requestId)
                    : null,
              ),
            );
          } else {
            return Container(
              margin: padding,
              height: 315,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha((0.25 * 225).toInt()),
                      offset: const Offset(0, 0),
                      blurRadius: 14,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 24),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Center(child: Text("No active requests")),
                ),
              ),
            );
          }
        }

        return Column(
          children: [
            SizedBox(height: topGap),

            // Fixed welcome header (outside refresher)
            Container(
              margin: padding,
              child: WelcomeHeader(
                phoneNumber: loginSession.phone!,
                actor: loginSession.role,
                name: loginSession.username,
                avatarUrl: loginSession.imageURL,
                greeting: 'Welcome,',
              ),
            ),

            const SizedBox(height: 20),

            // Scrollable + refreshable content BELOW header
            Expanded(
              child: AppRefreshWrapper(
                onRefresh: () async {
                  final s = context.read<ParentState>();
                  s.resetForRefresh();
                  await ParentHomeController(s).fetchActiveRequests();
                  await ParentHomeController(s).fetchHistoryRequests();
                },
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  children: [
                    const SizedBox(height: 20),

                    yourRequestsTitle(),

                    activeRequestView(),

                    if (hasMultiple & !state.isLoading) ...[
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
                              Text('History', style: textTheme.h2.w500),
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
                        child: state.isLoadingHistory
                            ? simpleRequestCardSkeleton()
                            : state.filteredRequests == null
                            ? const Center(child: Text('No requests found'))
                            : SimpleRequestCard(
                                requestType:
                                    state.filteredRequests!.requestType,
                                fromDate: state.filteredRequests!.appliedFrom,
                                toDate: state.filteredRequests!.appliedTo,
                                status: state.filteredRequests!.status,
                                statusDate:
                                    state.filteredRequests!.lastUpdatedAt,
                                reason: state.filteredRequests!.reason,
                                requestId: state.filteredRequests!.requestId,
                                actor: TimelineActor.parent,
                              ),
                      ),
                    ),

                    // Bottom safe-area spacer
                    Container(
                      height: 84 + MediaQuery.of(context).viewPadding.bottom,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
