import 'package:flutter/material.dart';
import 'package:hostel_mgmt/presentation/components/active_request_card.dart';
import 'package:hostel_mgmt/presentation/components/simple_request_card.dart';
import 'package:hostel_mgmt/presentation/view/student/controllers/home_controller.dart';
import 'package:hostel_mgmt/presentation/view/student/state/home_state.dart';
import 'package:hostel_mgmt/presentation/widgets/clickable_text.dart';
import 'package:hostel_mgmt/presentation/widgets/dropdown.dart';
import 'package:hostel_mgmt/presentation/widgets/welcome_header.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'; // Make sure to import this package
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    // Use a PageController for the PageView
    final pageController = PageController();
    final padding = EdgeInsets.symmetric(
      horizontal: 31 * mediaQuery.size.width / 402,
    );

    return ChangeNotifierProvider<HomeState>(
      create: (_) {
        final controller = HomeController();
        return controller.state;
      },
      child: Consumer<HomeState>(
        builder: (context, state, _) {
          final activeRequests =
              state.activeRequests; // Replace requests with your state.requests
          final hasMultiple = activeRequests.length > 1;
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

          return Padding(
            padding: EdgeInsetsGeometry.only(
              top: mediaQuery.size.height * 50 / 874,
            ),
            child: Container(
              child:
                  // ? SingleChildScrollView(child: const ShimmerCard())
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ElevatedButton(
                        //   onPressed: () {
                        //     LoginController.logout(context);
                        //     // Handle button press
                        //   },
                        //   child: Text('Elevated Button'),
                        // ),
                        Container(
                          margin: padding,
                          child: WelcomeHeader(
                            name: state.profile?.name ?? '',
                            avatarUrl: state.profile?.profilePic,
                            greeting: 'Welcome back,',
                          ),
                        ),

                        // Container(
                        //   margin: EdgeInsets.symmetric(
                        //     horizontal: 36 * mediaQuery.size.width / 402,
                        //     vertical: 20,
                        //   ),
                        //   child: Text(
                        //     'Your Requests',
                        //     style: TextStyle(
                        //       fontFamily: 'Poppins',
                        //       fontWeight:
                        //           FontWeight.w600, // SemiBold equivalent
                        //       fontSize: 30,
                        //       height: 1.0, // line-height 100%
                        //       letterSpacing: 0.0,
                        //     ),
                        //   ),
                        // ),
                        SizedBox(height: 20),
                        // Requests Cards with PageView if more than one
                        hasMultiple
                            ? Column(
                                children: [
                                  SizedBox(
                                    height:
                                        300, // adjust depending on card content
                                    child: PageView.builder(
                                      controller: pageController,
                                      itemCount: activeRequests.length,
                                      itemBuilder: (context, index) {
                                        final req = activeRequests[index];
                                        return Container(
                                          margin: padding,
                                          child: ActiveRequestCard(
                                            requestId: req.requestId,
                                            requestType: req.requestType.name
                                                .toUpperCase(),
                                            status: req.status,
                                            fromDate: req.appliedFrom,
                                            toDate: req.appliedTo,
                                            timeline:
                                                Container(), // your timeline widget
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
                                      dotColor: Colors.grey[300]!,
                                      jumpScale: 1,
                                    ),
                                  ),
                                ],
                              )
                            : activeRequests.isNotEmpty
                            ? Container(
                                margin: padding,
                                child: ActiveRequestCard(
                                  requestId: activeRequests.first.id,
                                  requestType:
                                      activeRequests.first.requestType.name,
                                  status: activeRequests.first.status,
                                  fromDate: activeRequests.first.appliedFrom,
                                  toDate: activeRequests.first.appliedTo,
                                  timeline: Container(), // your timeline widget
                                ),
                              )
                            : SizedBox(), // nothing if no requests
                        SizedBox(height: 18),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: mediaQuery.size.width * 44 / 402,
                          ),
                          child: Divider(
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
                                  Text(
                                    'History',
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight:
                                          FontWeight.w500, // Medium weight
                                      fontSize: 24,
                                    ),
                                  ),
                                  SizedBox(width: 12),

                                  // our custom dropdown
                                  dropdown,
                                ],
                              ),

                              ClickableText(
                                text: "See all",
                                onTap: () {
                                  // go route push to history page
                                  context.push('/history');
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
                                color: Color.fromRGBO(117, 117, 117, 1),
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            // condition if the filteredRequests is empty
                            child: state.filteredRequests == null
                                ? Center(child: Text('No requests found'))
                                : SimpleRequestCard(
                                    requestType:
                                        state.filteredRequests!.requestType,
                                    fromDate:
                                        state.filteredRequests!.appliedFrom,
                                    toDate: state.filteredRequests!.appliedTo,
                                    status: state.filteredRequests!.status,
                                    statusDate:
                                        state.filteredRequests!.lastUpdatedAt,
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
            ),
          );
        },
      ),
    );
  }
}
