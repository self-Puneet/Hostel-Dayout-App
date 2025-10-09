// lib/ui/home_dashboard_page.dart
import 'package:flutter/material.dart';
import 'package:hostel_mgmt/core/helpers/app_refreasher_widget.dart';
import 'package:hostel_mgmt/core/theme/app_theme.dart';
import 'package:hostel_mgmt/models/expandable_stat_card_data.dart';
import 'package:hostel_mgmt/models/warden_statistics.dart';
import 'package:hostel_mgmt/presentation/components/expandable_stat_card.dart';
import 'package:hostel_mgmt/presentation/view/warden/controller/warden_home_controller.dart';
import 'package:hostel_mgmt/presentation/view/warden/state/warden_home_state.dart';
import 'package:provider/provider.dart';

class HomeDashboardPage extends StatelessWidget {
  const HomeDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final state = context.watch<WardenStatisticsState>();
    final controller = context.read<WardenStatisticsController>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!state.hostelsInitialized) {
        controller.initFromSession();
      }
    });

    final media = MediaQuery.of(context);
    final horizontalPad = EdgeInsets.symmetric(
      horizontal: 31 * media.size.width / 402,
    );

    return AppRefreshWrapper(
      onRefresh: () => controller.refresh(),
      child: Padding(
        padding: horizontalPad,
        child: ListView(
          padding: const EdgeInsets.all(0),
          children: [
            // Section label (matches image)
            if (state.hostelsInitialized && state.hostelIds.length > 1) ...[
              Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 4),
                child: Text(
                  "SELECT HOSTEL",
                  style: textTheme.h7.copyWith(letterSpacing: 1.2),
                ),
              ),
            ],
            // Dropdown
            Visibility(
              visible: state.hostelsInitialized && state.hostelIds.length > 1,
              replacement: const SizedBox.shrink(),
              child: Theme(
                data: Theme.of(context).copyWith(
                  // Blue overlay when an item is focused/selected in the open menu
                  focusColor: Colors.blue.withAlpha((0.20 * 255).toInt()),
                  // Optional: subtler blue on hover and press
                  hoverColor: Colors.blue.withAlpha((0.08 * 255).toInt()),
                  highlightColor: Colors.blue.withAlpha((0.12 * 255).toInt()),
                ),
                child: DropdownButtonFormField<String>(
                  initialValue: state.selectedHostelId,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.black,
                        width: 1.4,
                      ),
                    ),
                  ),
                  elevation: 0,
                  icon: const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: Colors.black,
                  ),
                  dropdownColor: Colors.white,
                  borderRadius: BorderRadius.circular(12),

                  // Selected (displayed) item in the field -> BLUE
                  selectedItemBuilder: (context) {
                    return state.hostelIds.map((id) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            id,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: Colors.blue,
                                ), // blue for selected display
                          ),
                        ),
                      );
                    }).toList();
                  },

                  // Menu items -> keep black so only the selected display is blue
                  items: state.hostelIds.map((id) {
                    final isSelected = id == state.selectedHostelId;
                    return DropdownMenuItem(
                      value: id,
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.blue.shade100
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        child: Text(
                          id,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(color: Colors.black),
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (id) {
                    if (id != null) controller.selectHostel(id);
                  },
                ),
              ),
            ),
            const SizedBox(height: 18),
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
                    hostelName: state.selectedHostelId!,
                    monthCount: state.stats!.monthCount,
                    todayCount: state.stats!.actionCount,
                  ),

                  const SizedBox(height: 20),
                  // Statistics section
                  Text(
                    "OVERVIEW",
                    style: textTheme.h5.copyWith(fontWeight: FontWeight.bold),
                  ),
                  DashboardGrid(stats: state.stats!),
                  // _StatsSection(onTap: controller.onCardTap),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class HostelSummaryCard extends StatelessWidget {
  final String hostelName;
  final int monthCount;
  final int todayCount;
  final IconData icon;
  const HostelSummaryCard({
    super.key,
    required this.hostelName,
    required this.monthCount,
    required this.todayCount,
    this.icon = Icons.apartment, // or another relevant icon
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
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
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top: icon + hostel name
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  width: 44,
                  height: 44,
                  child: Icon(icon, color: Colors.blue, size: 28),
                ),
                const SizedBox(width: 14),
                Text(
                  hostelName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.h5.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Stats row: This Month & Today
            Row(
              children: [
                // "This Month"
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.withAlpha((0.08 * 225).toInt()),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 18,
                      horizontal: 14,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("This Month", style: textTheme.h5),
                        const SizedBox(height: 8),
                        Text(
                          '$monthCount',
                          style: textTheme.h3.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                // "Today"
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 18,
                      horizontal: 14,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Today", style: textTheme.h5),
                        const SizedBox(height: 8),
                        Text(
                          '$todayCount',
                          style: textTheme.h3.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
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
      ExpandableStatCardData(
        icon: Icons.assignment_outlined,
        iconColor: const Color.fromRGBO(36, 99, 235, 1.0),
        iconBgColor: const Color.fromRGBO(233, 239, 252, 0.8),
        value: stats.count,
        valueLabel: "Active Requests",
        title: "Active Requests",
        breakdown: const [],
      ),
      ExpandableStatCardData(
        icon: Icons.assignment_turned_in_outlined,
        iconColor: const Color.fromRGBO(249, 116, 21, 1.0),
        iconBgColor: const Color.fromRGBO(254, 241, 231, 1.0),
        value: stats.actionCount,
        valueLabel: "Pending Approvals",
        title: "Pending Approvals",
        breakdown: const [],
      ),
    ];

    // Second row: always show details
    final row1 = [
      ExpandableStatCardData(
        icon: Icons.watch_later_outlined,
        iconColor: const Color.fromRGBO(239, 67, 67, 1.0),
        iconBgColor: const Color.fromRGBO(253, 236, 236, 1.0),
        value: stats.lateCount,
        valueLabel: "Late Students",
        title: "Late Students",
        breakdown: [
          {"label": "Leave", "value": stats.lateLeaveCount},
          {"label": "Outing", "value": stats.outLeaveCount},
          {"label": "Outing", "value": 7},
        ],
      ),
      ExpandableStatCardData(
        icon: Icons.people_outline,
        iconColor: const Color.fromRGBO(36, 99, 235, 1.0),
        iconBgColor: const Color.fromRGBO(233, 239, 252, 0.8),
        value: stats.outCount,
        valueLabel: "Student Out",
        title: "Student Out",
        breakdown: [
          {"label": "Leave", "value": stats.lateOutingCount},
          {"label": "Outing", "value": stats.outOutingCount},
        ],
      ),
    ];

    Widget buildRow(List<ExpandableStatCardData> dataRow, {required bool showDetails}) {
      return IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (final data in dataRow)
              Expanded(
                child: ExpandableStatCard(
                  data: data,
                  // If desired, allow tapping whole card to expand when breakdown exists
                  enableExpandOnCardTap: false,
                  onTap: () {
                    // Example: navigate and pass data to details page using named routes
                    Navigator.pushNamed(
                      context,
                      '/details',
                      arguments: {
                        'title': data.title,
                        'value': data.value,
                        'label': data.valueLabel,
                      },
                    );
                  },
                ),
              ),
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
              Expanded(
                child: ExpandableStatCard(
                  data: data,
                  onTap: () {
                    // Different action for second-row cards if needed
                    Navigator.pushNamed(
                      context,
                      '/breakdown',
                      arguments: {'title': data.title, 'breakdown': data.breakdown},
                    );
                  },
                ),
              ),
          ],
        ),
      ],
    );
  }
}
