import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hostel_mgmt/core/rumtime_state/login_session.dart';
import 'package:hostel_mgmt/presentation/components/simple_action_request_card.dart';
import 'package:hostel_mgmt/core/enums/enum.dart';
import 'package:hostel_mgmt/presentation/view/warden/state/warden_history_state.dart';
import 'package:hostel_mgmt/presentation/view/warden/controller/warden_history_controller.dart';
import 'package:hostel_mgmt/presentation/widgets/segmented_scrollable_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:wheel_picker/wheel_picker.dart';

class WardenHistoryPage extends StatefulWidget {
  final TimelineActor actor;

  const WardenHistoryPage({super.key, required this.actor});

  @override
  State<WardenHistoryPage> createState() => _WardenHistoryPageState();
}

class _WardenHistoryPageState extends State<WardenHistoryPage>
    with SingleTickerProviderStateMixin {
  late WardenHistoryPageController controller;
  late TabController _tabs;

  Future<(int month, int year)?> showMonthYearWheelPicker(
    BuildContext context, {
    int? initialMonth,
    int? initialYear,
  }) {
    // Month & Year Data Sources
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    final currentYear = DateTime.now().year;
    final years = List.generate(11, (i) => currentYear - 5 + i);

    // Initial indices
    final initialMonthIndex = (initialMonth ?? DateTime.now().month) - 1;
    final initialYearIndex = years
        .indexOf(initialYear ?? currentYear)
        .clamp(0, years.length - 1);

    // Controllers
    final monthController = WheelPickerController(
      itemCount: months.length,
      initialIndex: initialMonthIndex,
    );
    final yearController = WheelPickerController(
      itemCount: years.length,
      initialIndex: initialYearIndex,
    );

    // Current selection
    int currentMonth = initialMonth ?? DateTime.now().month;
    int currentYearSelected = years[initialYearIndex];

    return showDialog<(int, int)>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.black.withOpacity(0.85),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          height: 340,
          width: 320,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                'Select Month & Year',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Row(
                  children: [
                    // Month Picker
                    Expanded(
                      child: StatefulBuilder(
                        builder: (context, setState) {
                          return WheelPicker(
                            controller: monthController,
                            looping: false,
                            enableTap: true,
                            selectedIndexColor: Colors.transparent,
                            style: const WheelPickerStyle(
                              squeeze: 1.1,
                              diameterRatio: 1.2,
                              magnification: 1.05,
                            ),
                            builder: (context, index) {
                              final isSelected = index == currentMonth - 1;
                              final month = months[index];
                              return Center(
                                child: AnimatedDefaultTextStyle(
                                  duration: const Duration(milliseconds: 150),
                                  style: TextStyle(
                                    fontSize: isSelected ? 20 : 14,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.white.withOpacity(0.45),
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                                  child: Text(month),
                                ),
                              );
                            },
                            onIndexChanged: (index, reason) {
                              setState(() {
                                currentMonth = index + 1;
                              });
                            },
                          );
                        },
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: VerticalDivider(
                        color: Colors.white38,
                        thickness: 1,
                      ),
                    ),
                    // Year Picker
                    Expanded(
                      child: StatefulBuilder(
                        builder: (context, setState) {
                          return WheelPicker(
                            controller: yearController,
                            looping: false,
                            enableTap: true,
                            selectedIndexColor: Colors.transparent,
                            style: const WheelPickerStyle(
                              squeeze: 1.1,
                              diameterRatio: 1.2,
                              magnification: 1.05,
                            ),
                            builder: (context, index) {
                              final isSelected =
                                  years[index] == currentYearSelected;
                              final year = years[index];
                              return Center(
                                child: AnimatedDefaultTextStyle(
                                  duration: const Duration(milliseconds: 150),
                                  style: TextStyle(
                                    fontSize: isSelected ? 20 : 14,
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.white.withOpacity(0.45),
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                                  child: Text(year.toString()),
                                ),
                              );
                            },
                            onIndexChanged: (index, reason) {
                              setState(() {
                                currentYearSelected = years[index];
                              });
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white70,
                    ),
                    child: const Text('CANCEL'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () =>
                        Navigator.pop(ctx, (currentMonth, currentYearSelected)),
                    child: const Text('OK'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    final state = context.read<WardenHistoryState>();
    controller = WardenHistoryPageController(state);

    _tabs = TabController(
      length: WardenHistoryTab.values.length, // now includes “All”
      vsync: this,
      initialIndex: state.currentTab.index,
    );
    _tabs.addListener(() {
      if (!_tabs.indexIsChanging) {
        final tab = WardenHistoryTabX.fromIndex(_tabs.index);
        state.setCurrentTab(tab);
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.loadHostelsFromSession();
      controller.fetchRequestsFromApi();
      state.setCurrentTab(WardenHistoryTabX.fromIndex(_tabs.index));
    });
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<WardenHistoryState>();
    final media = MediaQuery.of(context);
    final horizontalPad = EdgeInsets.symmetric(
      horizontal: 31 * media.size.width / 402,
    );
    final tabLabels = WardenHistoryTab.values.map((t) => t.label).toList();

    return RefreshIndicator(
      onRefresh: () async {
        state.resetForHostelChange();
        await controller.fetchRequestsFromApi();
      },
      child: Padding(
        padding: horizontalPad,
        child: Column(
          children: [
            TextField(
              controller: state.filterController,
              decoration: InputDecoration(
                hintText: 'Search by Name ...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                isDense: true,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blueGrey, width: 1.1),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: hostelDropdownWidget(state),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: () async {
                      final state = context.read<WardenHistoryState>();
                      final result = await showMonthYearWheelPicker(
                        context,
                        initialMonth: state.selectedMonth,
                        initialYear: state.selectedYear,
                      );
                      if (result != null) {
                        final (month, year) = result;
                        state.setMonthYear(month, year);
                        state.resetForHostelChange();
                        await controller.fetchRequestsFromApi(
                          monthYear: DateTime(year, month),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: const BorderSide(
                        color: Colors.blueGrey,
                        width: 1.1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                    ),
                    child: Text(
                      "${state.selectedMonth.toString().padLeft(2, '0')}-${state.selectedYear}",
                      style: const TextStyle(
                        color: Colors.blueGrey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Tabs

            // Segmented, scrollable tabs (your custom component)
            Padding(
              padding: horizontalPad,
              child: SegmentedTabs(controller: _tabs, labels: tabLabels),
            ),
            const SizedBox(height: 6),
            Padding(
              padding: horizontalPad,
              child: Divider(thickness: 2, color: Colors.grey.shade300),
            ),

            // Tab Content
            Expanded(
              child: (state.isLoading && !state.hasData)
                  ? const Center(child: CircularProgressIndicator())
                  : TabBarView(
                      controller: _tabs,
                      physics: const NeverScrollableScrollPhysics(),
                      children: WardenHistoryTab.values.map((tab) {
                        final filteredRequests = state.currentOnScreenRequests
                            .where((req) {
                              final allowedStatuses = state
                                  .allowedStatusesForTab(
                                    Get.find<LoginSession>().role,
                                    tab,
                                  );
                              return allowedStatuses.contains(
                                req.request.status,
                              );
                            })
                            .toList();

                        if (state.isErrored) {
                          return Center(
                            child: Text('Error: ${state.errorMessage}'),
                          );
                        }

                        if (filteredRequests.isEmpty) {
                          final q = state.filterController.text.trim();
                          return Center(
                            child: Text(
                              q.isEmpty
                                  ? 'Nothing here yet'
                                  : 'No matches for "$q"',
                            ),
                          );
                        }

                        return ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: filteredRequests.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, i) {
                            final wrap = filteredRequests[i];
                            final req = wrap.request;
                            final stu = wrap.student;
                            final safeName = stu.name.isEmpty
                                ? 'Unknown'
                                : stu.name;

                            return SimpleActionRequestCard(
                              reason: req.reason,
                              name: safeName,
                              status: req.status,
                              leaveType: req.requestType,
                              fromDate: req.appliedFrom,
                              toDate: req.appliedTo,
                              profileImageUrl: stu.profilePic,
                              isAcceptence: false,
                              isLate: false,
                              isRejection: false,
                            );
                          },
                        );
                      }).toList(),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget hostelDropdownWidget(WardenHistoryState state) {
    if (state.hostels.length <= 1 && state.selectedHostelId != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SizedBox(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.home, color: Colors.blueGrey, size: 18),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  state.selectedHostelName ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                    color: Colors.blueGrey,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isDense: true,
            isExpanded: true,
            value: state.selectedHostelId,
            items: state.hostels.map((hostel) {
              return DropdownMenuItem<String>(
                value: hostel.hostelId,
                child: Row(
                  children: [
                    const Icon(Icons.home, color: Colors.blueGrey, size: 16),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        hostel.hostelName,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: (val) async {
              if (val == null) return;
              final hostel = state.hostels.firstWhere(
                (h) => h.hostelId == val,
                orElse: () => state.hostels.first,
              );
              state.setSelectedHostelId(hostel.hostelId, hostel.hostelName);
              state.resetForHostelChange();
              await controller.fetchRequestsFromApi(hostelId: hostel.hostelId);
            },
            icon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.blueGrey,
            ),
            iconSize: 20,
            style: const TextStyle(fontSize: 13, color: Colors.black87),
            dropdownColor: Colors.white,
          ),
        ),
      );
    }
  }
}
