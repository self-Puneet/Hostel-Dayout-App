import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hostel_mgmt/core/theme/app_theme.dart';
import 'package:hostel_mgmt/presentation/components/simple_action_request_card.dart';
import 'package:hostel_mgmt/core/enums/enum.dart';
import 'package:hostel_mgmt/presentation/components/skeleton_loaders/simple_action_request_card_skeleton.dart';
import 'package:hostel_mgmt/presentation/view/warden/state/warden_history_state.dart';
import 'package:hostel_mgmt/presentation/view/warden/controller/warden_history_controller.dart';
import 'package:hostel_mgmt/presentation/widgets/no_request_card.dart';
import 'package:hostel_mgmt/presentation/widgets/segmented_scrollable_tab_view.dart';
import 'package:intl/intl.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:provider/provider.dart';

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

  Future<(int, int)?> showMonthYearWheelPickerLWSV(
    BuildContext context, {
    int? initialMonth,
    int? initialYear,
  }) {
    const months = [
      'Jan',
      'Feb',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'Sept',
      'Oct',
      'Nov',
      'Dec',
    ];
    final currentYear = DateTime.now().year;
    final years = List.generate(currentYear - 2023 + 1, (i) => 2023 + i);

    // Initial indices
    final initMonth = (initialMonth ?? DateTime.now().month) - 1;
    final initYearIdx = years
        .indexOf(initialYear ?? currentYear)
        .clamp(0, years.length - 1);

    // Controllers
    final monthCtrl = FixedExtentScrollController(initialItem: initMonth);
    final yearCtrl = FixedExtentScrollController(initialItem: initYearIdx);

    // Dynamic sizing
    final base = (Theme.of(context).textTheme.titleMedium?.fontSize ?? 16);
    final itemExtent = (base * 1.9).clamp(36.0, 56.0); // row height from text
    final gap = itemExtent * 0.5; // compact, scalable spacing

    // Visual tuning
    const magnify = 1.12;
    const opacity = 0.42;
    const persp = 0.0001; // very shallow curvature
    const diaRatio = 1.6;
    const squeeze = 1.05;

    final textTheme = Theme.of(context).textTheme;

    return showDialog<(int, int)>(
      context: context,
      barrierColor: Colors.black54,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          // Colors.black87,
          elevation: 0,
          insetPadding: EdgeInsets.symmetric(
            horizontal:
                (3 * 31 * MediaQuery.of(context).size.width) / (402 * 2),
          ),
          child: LiquidGlass(
            shape: LiquidRoundedSuperellipse(borderRadius: Radius.circular(20)),
            settings: const LiquidGlassSettings(
              thickness: 10,
              blur: 20,
              chromaticAberration: 0.01,
              lightAngle: pi * 5 / 18,
              lightIntensity: 10,
              refractiveIndex: 10,
              saturation: 1,
              lightness: 1,
            ),
            child: Container(
              // Size to content; keep width constrained if desired
              constraints: const BoxConstraints(minWidth: 300, maxWidth: 340),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Select Month & Year',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: gap),
                  Row(
                    children: [
                      // Month wheel
                      Expanded(
                        child: SizedBox(
                          height: itemExtent * 3, // exactly 3 rows
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              AnimatedBuilder(
                                animation: monthCtrl,
                                builder: (context, _) {
                                  // Live centered index (guarded)
                                  final monthIndex = monthCtrl.hasClients
                                      ? monthCtrl.selectedItem
                                      : initMonth;
                                  return ListWheelScrollView.useDelegate(
                                    controller: monthCtrl,
                                    physics: const FixedExtentScrollPhysics(),
                                    itemExtent: itemExtent,
                                    perspective: persp,
                                    diameterRatio: diaRatio,
                                    squeeze: squeeze,
                                    useMagnifier: true,
                                    magnification: magnify,
                                    overAndUnderCenterOpacity: opacity,
                                    onSelectedItemChanged: (_) {},
                                    childDelegate:
                                        ListWheelChildBuilderDelegate(
                                          childCount: months.length,
                                          builder: (context, index) {
                                            final isSelected =
                                                index == monthIndex;
                                            return GestureDetector(
                                              behavior: HitTestBehavior.opaque,
                                              onTap: () =>
                                                  monthCtrl.animateToItem(
                                                    index,
                                                    duration: const Duration(
                                                      milliseconds: 160,
                                                    ),
                                                    curve: Curves.easeOutQuad,
                                                  ),
                                              child: Center(
                                                child: AnimatedDefaultTextStyle(
                                                  duration: const Duration(
                                                    milliseconds: 120,
                                                  ),
                                                  style: TextStyle(
                                                    fontSize: isSelected
                                                        ? base + 4
                                                        : base,
                                                    color: isSelected
                                                        ? Colors.white
                                                        : Colors.white
                                                              .withAlpha(
                                                                (0.45 * 225)
                                                                    .toInt(),
                                                              ),
                                                    fontWeight: isSelected
                                                        ? FontWeight.w600
                                                        : FontWeight.normal,
                                                  ),
                                                  child: Text(months[index]),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                  );
                                },
                              ),
                              // Transparent selection lane (border only)
                              IgnorePointer(
                                child: Container(
                                  height: itemExtent + 5,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.white.withAlpha(
                                        (0.25 * 225).toInt(),
                                      ),
                                    ),
                                    color: Colors.transparent,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: VerticalDivider(
                          color: Colors.white38,
                          thickness: 1,
                        ),
                      ),
                      // Year wheel
                      Expanded(
                        child: SizedBox(
                          height: itemExtent * 3,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              AnimatedBuilder(
                                animation: yearCtrl,
                                builder: (context, _) {
                                  final yearIndex = yearCtrl.hasClients
                                      ? yearCtrl.selectedItem
                                      : initYearIdx;
                                  return ListWheelScrollView.useDelegate(
                                    controller: yearCtrl,
                                    physics: const FixedExtentScrollPhysics(),
                                    itemExtent: itemExtent,
                                    perspective: persp,
                                    diameterRatio: diaRatio,
                                    squeeze: squeeze,
                                    useMagnifier: true,
                                    magnification: magnify,
                                    overAndUnderCenterOpacity: opacity,
                                    onSelectedItemChanged: (_) {},
                                    childDelegate:
                                        ListWheelChildBuilderDelegate(
                                          childCount: years.length,
                                          builder: (context, index) {
                                            final value = years[index];
                                            final isSelected =
                                                index == yearIndex;
                                            return GestureDetector(
                                              behavior: HitTestBehavior.opaque,
                                              onTap: () =>
                                                  yearCtrl.animateToItem(
                                                    index,
                                                    duration: const Duration(
                                                      milliseconds: 160,
                                                    ),
                                                    curve: Curves.easeOutQuad,
                                                  ),
                                              child: Center(
                                                child: AnimatedDefaultTextStyle(
                                                  duration: const Duration(
                                                    milliseconds: 120,
                                                  ),
                                                  style: TextStyle(
                                                    fontSize: isSelected
                                                        ? base + 4
                                                        : base - 2,
                                                    color: isSelected
                                                        ? Colors.white
                                                        : Colors.white
                                                              .withAlpha(
                                                                (0.45 * 225)
                                                                    .toInt(),
                                                              ),
                                                    fontWeight: isSelected
                                                        ? FontWeight.w600
                                                        : FontWeight.normal,
                                                  ),
                                                  child: Text('$value'),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                  );
                                },
                              ),
                              IgnorePointer(
                                child: Container(
                                  height: itemExtent + 5,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      width: 1,
                                      color: Colors.white.withAlpha(
                                        (0.25 * 225).toInt(),
                                      ),
                                    ),
                                    color: Colors.transparent,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: gap),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white70,
                        ),
                        child: Text(
                          'CANCEL',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),

                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.white70,
                        ),
                        onPressed: () {
                          final m = monthCtrl.hasClients
                              ? monthCtrl.selectedItem + 1
                              : initMonth + 1;
                          final yIdx = yearCtrl.hasClients
                              ? yearCtrl.selectedItem
                              : initYearIdx;
                          Navigator.pop(ctx, (m, years[yIdx]));
                        },
                        child: Text(
                          'OK',
                          style: textTheme.h5.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
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
    final height = 84 + MediaQuery.of(context).viewPadding.bottom;
    final textTheme = Theme.of(context).textTheme;

    return RefreshIndicator(
      triggerMode: RefreshIndicatorTriggerMode.anywhere,
      color: Colors.black,
      backgroundColor: Colors.white,
      notificationPredicate: (notification) =>
          notification.metrics.axis == Axis.vertical && notification.depth > 0,
      strokeWidth: 3,
      displacement: 60,
      onRefresh: () async {
        state.resetForHostelChange();
        await controller.fetchRequestsFromApi();
      },
      child: Column(
        children: [
          Padding(
            padding: horizontalPad,
            child: TextField(
              controller: state.filterController,
              decoration: InputDecoration(
                hintText: 'Search by Name',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                isDense: true,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: horizontalPad,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
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

                // Month-Year Picker and Show widget
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: () async {
                      final state = context.read<WardenHistoryState>();
                      final result = await showMonthYearWheelPickerLWSV(
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
                    child: Row(
                      // mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsetsGeometry.fromLTRB(10, 0, 0, 0),
                          child: Icon(
                            Icons.calendar_month_rounded,
                            color: Colors.blueGrey,
                            size: 18,
                          ),
                        ),
                        // const SizedBox(width: 8),
                        Expanded(
                          child: Center(
                            child: Text(
                              DateFormat('MMMM yyyy', 'en_US').format(
                                DateTime(
                                  state.selectedYear,
                                  state.selectedMonth,
                                ),
                              ),
                              style: textTheme.h6.copyWith(
                                color: Colors.blueGrey,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: horizontalPad,
            child: SegmentedTabs(
              controller: _tabs,
              labels: tabLabels,
              scrollable: false,
            ),
          ),
          Padding(
            padding: horizontalPad,
            child: Divider(
              height: 0,
              thickness: 2,
              color: Colors.grey.shade300,
            ),
          ),
          // Tab Content
          Expanded(
            child: (state.isLoading && !state.hasData)
                // true
                ? Padding(
                    padding:
                        horizontalPad +
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                    child: SingleChildScrollView(
                      child: Column(
                        children: List.generate(2, (index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: simpleActionRequestCardSkeleton(),
                          );
                        }),
                      ),
                    ),
                  )
                : TabBarView(
                    controller: _tabs,
                    physics: const NeverScrollableScrollPhysics(),
                    children: WardenHistoryTab.values.map((tab) {
                      final result = controller.getRequestsForTab(
                        widget.actor,
                        tab,
                      );

                      if (state.isErrored) {
                        // return Center(
                        //   child: Text('Error: ${state.errorMessage}'),
                        // );
                        final q = state.filterController.text.trim();
                        return LayoutBuilder(
                          builder: (context, constraints) =>
                              SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minHeight: constraints.maxHeight,
                                  ),
                                  child: Center(
                                    child: EmptyQueueCard(
                                      title: q.isEmpty
                                          ? 'Your queue is empty.'
                                          : 'No matches found.',
                                      subtitle: q.isEmpty
                                          ? 'All clear! No requests for now.'
                                          : 'Try refining your search.',
                                      minHeight: 280,
                                      bottomPadding:
                                          height, // already added via padding
                                    ),
                                  ),
                                ),
                              ),
                        );
                      }

                      if (result.isEmpty) {
                        final q = state.filterController.text.trim();
                        return LayoutBuilder(
                          builder: (context, constraints) =>
                              SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minHeight: constraints.maxHeight,
                                  ),
                                  child: Center(
                                    child: EmptyQueueCard(
                                      title: q.isEmpty
                                          ? 'Your queue is empty.'
                                          : 'No matches found.',
                                      subtitle: q.isEmpty
                                          ? 'All clear! No requests for now.'
                                          : 'Try refining your search.',
                                      minHeight: 280,
                                      bottomPadding:
                                          height, // already added via padding
                                    ),
                                  ),
                                ),
                              ),
                        );
                      }

                      return ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: EdgeInsets.fromLTRB(0, 16, 0, height),
                        itemCount: result.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, i) {
                          final wrap = result[i];
                          final req = wrap.request;
                          final stu = wrap.student;
                          final safeName = stu.name.isEmpty
                              ? 'Unknown'
                              : stu.name;

                          return Padding(
                            padding: horizontalPad,
                            child: SimpleActionRequestCard(
                              overflowStatusTag: true,
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
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }

  Widget hostelDropdownWidget(WardenHistoryState state) {
    final textTheme = Theme.of(context).textTheme;
    if (state.hostels.length <= 1 && state.selectedHostelId != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SizedBox(
          height: 46,
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
                  style: textTheme.h6.copyWith(
                    color: Colors.blueGrey,
                    fontWeight: FontWeight.w600,
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
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white, // Button background color (visible selection)
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              elevation: 0,
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
                          style: textTheme.h6.copyWith(
                            color: Colors.blueGrey,
                            fontWeight: FontWeight.w600,
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
                await controller.fetchRequestsFromApi(
                  hostelId: hostel.hostelId,
                );
              },
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Colors.blueGrey,
              ),
              iconSize: 20,
              style: textTheme.h6.copyWith(
                color: Colors.blueGrey,
                fontWeight: FontWeight.w600,
              ),
              dropdownColor: Colors.white,
            ),
          ),
        ),
      );
    }
  }
}
