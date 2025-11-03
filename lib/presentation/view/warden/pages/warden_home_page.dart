// lib/ui/home_dashboard_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:hostel_mgmt/core/helpers/app_refreasher_widget.dart';
import 'package:hostel_mgmt/core/routes/app_route_constants.dart';
import 'package:hostel_mgmt/core/rumtime_state/login_session.dart';
import 'package:hostel_mgmt/core/theme/app_theme.dart';
import 'package:hostel_mgmt/models/expandable_stat_card_data.dart';
import 'package:hostel_mgmt/models/warden_statistics.dart';
import 'package:hostel_mgmt/presentation/components/expandable_stat_card.dart';
import 'package:hostel_mgmt/presentation/view/warden/controller/warden_home_controller.dart';
import 'package:hostel_mgmt/presentation/view/warden/state/warden_action_state.dart';
import 'package:hostel_mgmt/presentation/view/warden/state/warden_home_state.dart';
import 'package:hostel_mgmt/presentation/widgets/welcome_header.dart';
import 'package:provider/provider.dart';

class HomeDashboardPage extends StatelessWidget {
  const HomeDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<WardenStatisticsState>();
    final controller = context.read<WardenStatisticsController>();
    final mediaQuery = MediaQuery.of(context);
    final topGap = mediaQuery.size.height * 50 / 874;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!state.hostelsInitialized) {
        controller.initFromSession();
      }
    });

    final media = MediaQuery.of(context);
    final horizontalPad = EdgeInsets.symmetric(
      horizontal: 31 * media.size.width / 402,
    );
    final loginSession = Get.find<LoginSession>();

    return Column(
      children: [
        SizedBox(height: topGap),

        Container(
          margin: horizontalPad,
          child: WelcomeHeader(
            enrollmentNumber: loginSession.identityId,
            phoneNumber: loginSession.phone,
            actor: loginSession.role,
            hostelName: loginSession.hostels!
                .map((h) => h.hostelName)
                .toList()
                .join('\n'),
            name: loginSession.username,
            avatarUrl: loginSession.imageURL,
            greeting: 'Welcome back,',
          ),
        ),

        const SizedBox(height: 20),
        Expanded(
          // <-- give bounded height to the scrollable area
          child: AppRefreshWrapper(
            onRefresh: () => controller.refresh(),
            child: Padding(
              padding: horizontalPad,
              child: ListView(
                padding: const EdgeInsets.all(0),
                children: [
                  if (state.isLoading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else if (state.error != null)
                    Card(
                      color: Theme.of(context).colorScheme.errorContainer,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(state.error!),
                      ),
                    )
                  else if (state.stats != null)
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HostelSummaryCard(
                          selectedHostelName:
                              state.selectedHostelName ?? "Unknown",
                          hostels: state.hostels,
                          selectedHostelId: state.selectedHostelId!,
                          onHostelSelected: (HostelInfo selected) {
                            controller.selectHostel(
                              selected.hostelId,
                              selected.hostelName,
                            );
                          },
                          monthCount: state.stats!.monthCount,
                          todayCount: state.stats!.actionCount,
                        ),

                        const SizedBox(height: 20),
                        const Padding(
                          padding: EdgeInsetsGeometry.symmetric(horizontal: 11),
                          child: Divider(
                            color: Color.fromRGBO(117, 117, 117, 1),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Statistics section
                        DashboardGrid(stats: state.stats!),
                        Container(
                          height:
                              84 + MediaQuery.of(context).viewPadding.bottom,
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class HostelSummaryCard extends StatelessWidget {
  final String selectedHostelName;
  final List<HostelInfo> hostels;
  final String selectedHostelId;
  final void Function(HostelInfo) onHostelSelected;
  final int monthCount;
  final int todayCount;
  final IconData icon;

  const HostelSummaryCard({
    super.key,
    required this.selectedHostelName,
    required this.hostels,
    required this.selectedHostelId,
    required this.onHostelSelected,
    required this.monthCount,
    required this.todayCount,
    this.icon = Icons.apartment,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final multipleHostels = hostels.length > 1;
    final selectedHostel = hostels.firstWhere(
      (h) => h.hostelId == selectedHostelId,
      orElse: () => hostels.first,
    );

    return Container(
      decoration: BoxDecoration(
        color: const Color.fromRGBO(0, 193, 255, 0.25),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                'OVERVIEW',
                textAlign: TextAlign.start,
                style: textTheme.h4.w500,
              ),
            ),
            const SizedBox(height: 25),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!multipleHostels)
                    Expanded(
                      child: Text(
                        selectedHostelName,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: textTheme.h2.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  if (multipleHostels)
                    PopupMenuButton<HostelInfo>(
                      tooltip: 'Select hostel',
                      padding: EdgeInsets.zero,

                      itemBuilder: (context) {
                        return hostels.map((hostel) {
                          final isSelected =
                              hostel.hostelId == selectedHostelId;
                          return PopupMenuItem<HostelInfo>(
                            height: 35,
                            value: hostel,
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: Container(
                              decoration: isSelected
                                  ? BoxDecoration(
                                      color: Colors.blue.shade100,
                                      borderRadius: BorderRadius.circular(6),
                                    )
                                  : null,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 6,
                              ),
                              // NEW: Center row inside the container
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment
                                    .center, // Center horizontally
                                children: [
                                  if (isSelected)
                                    Icon(
                                      Icons.check_circle,
                                      color: Colors.blue,
                                      size: 20,
                                    )
                                  else
                                    SizedBox(width: 20),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      hostel.hostelName,
                                      style: TextStyle(
                                        fontWeight: isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                        color: isSelected
                                            ? Colors.black
                                            : Colors.grey[800],
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList();
                      },
                      onSelected: onHostelSelected,
                      // constraints: const BoxConstraints(
                      //   minWidth: 60,
                      //   maxWidth: 220,
                      // ),
                      elevation: 8,
                      color: Colors.blue[50], // Menu background (light blue)
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 0,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              selectedHostel.hostelName,
                              style: textTheme.h2.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(width: 6),
                            const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Colors.black87,
                              size: 22,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(32.0),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 14,
                    ),
                    child: CompressedStatTable(
                      textTheme: textTheme,
                      title: "This Month",
                      value: monthCount.toString(),
                      image: Image.asset(
                        'assets/monthly_calender.png',
                        height: 32,
                        width: 32,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(32.0),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 14,
                      horizontal: 14,
                    ),
                    child: CompressedStatTable(
                      textTheme: textTheme,
                      title: "Today",
                      value: todayCount.toString(),
                      image: Image.asset(
                        'assets/today_calender.png',
                        height: 32,
                        width: 32,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DashboardGrid extends StatelessWidget {
  final WardenStatistics stats;
  const DashboardGrid({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    // First row: no details
    final row0 = [
      StatCardData(
        dotColor: const Color.fromRGBO(0, 255, 13, 0.4),
        value: stats.count,
        valueLabel: "Active Requests",
        breakdown: const [],
        onTap: () {
          context.goNamed(
            AppRoutes.wardenActionPage,
            queryParameters: {
              'tab': WardenTab.pendingApproval.name, // "approved"
            },
          );
        },
      ),
      StatCardData(
        dotColor: const Color.fromRGBO(255, 0, 4, 0.4),
        value: stats.lateCount,
        valueLabel: "Late Students",
        breakdown: [
          {"label": "Leave", "value": stats.lateLeaveCount},
          {"label": "Outing", "value": stats.outLeaveCount},
          {"label": "Outing", "value": 7},
        ],
        onTap: () {
          context.goNamed(
            AppRoutes.wardenActionPage,
            queryParameters: {
              'tab': WardenTab.pendingParent.name, // "approved"
            },
          );
        },
      ),
    ];

    // Second row: always show details
    final row1 = [
      StatCardData(
        dotColor: const Color.fromRGBO(255, 251, 0, 0.5),
        value: stats.actionCount,
        valueLabel: "Pending Requests",
        breakdown: const [],
        onTap: () {
          context.goNamed(
            AppRoutes.wardenActionPage,
            queryParameters: {
              'tab': WardenTab.approved.name, // "approved"
            },
          );
        },
      ),

      StatCardData(
        dotColor: const Color.fromRGBO(0, 72, 255, 0.5),
        value: stats.outCount,
        valueLabel: "Student Out",
        breakdown: [
          {"label": "Leave", "value": stats.lateOutingCount},
          {"label": "Outing", "value": stats.outOutingCount},
        ],
        onTap: () {
          context.goNamed(
            AppRoutes.wardenActionPage,
            queryParameters: {
              'tab': WardenTab.approved.name, // "approved"
            },
          );
        },
      ),
    ];

    Widget buildRow(List<StatCardData> dataRow, {required bool showDetails}) {
      return IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final data in dataRow)
              Expanded(child: ExpandableStatCard(data: data)),
          ],
        ),
      );
    }

    return Column(
      children: [
        buildRow(row0, showDetails: false),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final data in row1)
              Expanded(child: ExpandableStatCard(data: data)),
          ],
        ),
      ],
    );
  }
}

class CompressedStatTable extends StatelessWidget {
  final TextTheme textTheme;
  final String title;
  final String value;
  final Image image;

  const CompressedStatTable({
    Key? key,
    required this.textTheme,
    this.title = '[translate:Thid Month]',
    this.value = '10',
    required this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: IntrinsicHeight(
        child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          columnWidths: const {
            0: IntrinsicColumnWidth(),
            1: IntrinsicColumnWidth(),
          },
          children: [
            TableRow(
              children: [
                image,
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    title,
                    style: textTheme.h6,
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
            TableRow(
              children: [
                const SizedBox.shrink(), // empty cell for alignment
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    value,
                    style: textTheme.h1.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.left,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
