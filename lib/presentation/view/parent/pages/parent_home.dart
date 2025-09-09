// presentation/view/parent/pages/parent_home.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hostel_mgmt/core/enums/request_status.dart';
import 'package:hostel_mgmt/core/rumtime_state/login_session.dart';
import 'package:hostel_mgmt/presentation/components/active_request_card.dart';
import 'package:hostel_mgmt/presentation/view/parent/controllers/parent_home_controller.dart';
import 'package:hostel_mgmt/presentation/widgets/welcome_header.dart';
import 'package:provider/provider.dart';
import 'package:hostel_mgmt/presentation/view/parent/state/parent_state.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ParentHomePage extends StatelessWidget {
  ParentHomePage({Key? key}) : super(key: key);

  // Stateless page controller (lives as long as this widget instance)
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final padding = EdgeInsets.symmetric(
      horizontal: 31 * mediaQuery.size.width / 402,
    );

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

        return Padding(
          padding: EdgeInsets.only(top: mediaQuery.size.height * 50 / 874),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: padding,
                  child: WelcomeHeader(
                    actor: loginSession.role,
                    name: loginSession.username,
                    avatarUrl: loginSession.imageURL,
                    greeting: 'Welcome back,',
                  ),
                ),
                const SizedBox(height: 20),

                if (state.isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (state.isErrored)
                  Padding(
                    padding: padding,
                    child: Text(
                      state.errorMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                  )
                else
                  (hasMultiple)
                      ? Column(
                          children: [
                            SizedBox(
                              height: 380,
                              child: PageView.builder(
                                controller: pageController,
                                itemCount: activeRequests.length,
                                itemBuilder: (context, index) {
                                  final req = activeRequests[index];
                                  final controller = ParentHomeController(
                                    state,
                                  );
                                  final bool canAct =
                                      isParent &&
                                      req.status == RequestStatus.referred &&
                                      !state.isActioning;

                                  return Container(
                                    margin: padding,
                                    child: ActiveRequestCard(
                                      reason: req.reason,
                                      requestId: req.requestId,
                                      requestType: req.requestType.name
                                          .toUpperCase(),
                                      status: req.status,
                                      fromDate: req.appliedFrom,
                                      toDate: req.appliedTo,
                                      timeline: Container(),
                                      // Show actions only for parent; disable while actioning
                                      onApprove: canAct
                                          ? () => controller.approveById(
                                              req.requestId,
                                            )
                                          : null,
                                      onDecline: canAct
                                          ? () => controller.rejectById(
                                              req.requestId,
                                            )
                                          : null,
                                    ),
                                  );
                                },
                              ),
                            ),
                            SmoothPageIndicator(
                              controller: pageController,
                              count: activeRequests.length,
                              effect: JumpingDotEffect(
                                dotHeight: 9,
                                dotWidth: 9,
                                activeDotColor: Colors.black,
                                dotColor: Colors.grey.shade400,
                                jumpScale: 1,
                              ),
                            ),
                          ],
                        )
                      : activeRequests.isNotEmpty
                      ? Container(
                          margin: padding,
                          child: ActiveRequestCard(
                            reason: activeRequests.first.reason,
                            requestId: activeRequests.first.requestId,
                            requestType: activeRequests.first.requestType.name
                                .toUpperCase(),
                            status: activeRequests.first.status,
                            fromDate: activeRequests.first.appliedFrom,
                            toDate: activeRequests.first.appliedTo,
                            timeline: Container(),
                            onApprove: isParent && !state.isActioning
                                ? () => ParentHomeController(
                                    state,
                                  ).approveById(activeRequests.first.requestId)
                                : null,
                            onDecline: isParent && !state.isActioning
                                ? () => ParentHomeController(
                                    state,
                                  ).rejectById(activeRequests.first.requestId)
                                : null,
                          ),
                        )
                      : const SizedBox(),

                const SizedBox(height: 18),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: mediaQuery.size.width * 44 / 402,
                  ),
                  child: const Divider(thickness: 1, color: Color(0xFF757575)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
