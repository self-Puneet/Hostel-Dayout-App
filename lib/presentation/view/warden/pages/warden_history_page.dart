// lib/presentation/view/warden/warden_history_page.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:hostel_mgmt/core/enums/enum.dart';
import 'package:hostel_mgmt/core/helpers/app_refreasher_widget.dart';
import 'package:hostel_mgmt/presentation/components/simple_action_request_card.dart';
import 'package:hostel_mgmt/presentation/widgets/glass_segmented_button.dart';

import 'package:hostel_mgmt/presentation/view/warden/state/warden_history_state.dart';
import 'package:hostel_mgmt/presentation/view/warden/controller/warden_history_controller.dart';

class WardenHistoryPage extends StatelessWidget {
  final TimelineActor actor;
  const WardenHistoryPage({Key? key, required this.actor}) : super(key: key);

  String _formatMonthYear(DateTime d) {
    // Simple MMM yyyy without intl; customize as needed
    const months = [
      'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'
    ];
    return '${months[d.month - 1]} ${d.year}';
    // Alternatively, use intl's DateFormat('MMM yyyy').format(d)
  }

  @override
  Widget build(BuildContext context) {
    final state = context.read<WardenHistoryState>();
    final controller = WardenHistoryPageController(state);

    return AppRefreshWrapper(
      onRefresh: () async {
        await controller.fetchRequestsFromApi();
      },
      child: Consumer<WardenHistoryState>(
        builder: (context, state, _) {
          if (!state.hostelsInitialized) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              WardenHistoryPageController(state).loadHostelsFromSession();
            });
          }

          if (state.hostelsInitialized &&
              !state.isLoading &&
              !state.isErrored &&
              !state.hasData) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              WardenHistoryPageController(state).fetchRequestsFromApi();
            });
          }

          if (state.isLoading && !state.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            padding: const EdgeInsets.all(0),
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              // Row 1: Search only
              Row(
                children: [
                  Expanded(
                    child: TextField(
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
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Row 2: Hostel + Month-Year
              Row(
                children: [
                  // Hostel dropdown
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          isDense: true,
                          isExpanded: true,
                          itemHeight: 48.0,
                          value: state.selectedHostelId ??
                              (state.hostelIds.isNotEmpty
                                  ? state.hostelIds.first
                                  : null),
                          items: state.hostelIds
                              .map(
                                (id) => DropdownMenuItem<String>(
                                  value: id,
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.home,
                                        color: Colors.blueGrey,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          id,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (val) async {
                            if (val == null) return;
                            state.setSelectedHostelId(val);
                            state.clearForHostelOrMonthChange();
                            await WardenHistoryPageController(state)
                                .fetchRequestsFromApi(hostelId: val);
                          },
                          icon: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: Colors.blueGrey,
                          ),
                          iconSize: 20,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black87,
                          ),
                          dropdownColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Month-Year picker button
                  SizedBox(
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        await controller.pickMonthYear(context);
                      },
                      icon: const Icon(Icons.calendar_month),
                      label: Text(_formatMonthYear(state.selectedMonthYear)),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Tabs + content (same type filter behavior)
              GlassSegmentedTabs(
                options: const ['All', 'Dayout', 'Leave'],
                onTabChanged: (index) {
                  switch (index) {
                    case 0:
                      state.setTypeFilter(null);
                      break;
                    case 1:
                      state.setTypeFilter(RequestType.dayout);
                      break;
                    case 2:
                      state.setTypeFilter(RequestType.leave);
                      break;
                  }
                },
                views: const [
                  _HistoryTabBody(type: null),
                  _HistoryTabBody(type: RequestType.dayout),
                  _HistoryTabBody(type: RequestType.leave),
                ],
                labelFontSize: 12,
                selectedLabelFontSize: 12,
                showTabs: true,
                margin: 0,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _HistoryTabBody extends StatelessWidget {
  final RequestType? type; // null = All
  const _HistoryTabBody({required this.type});

  @override
  Widget build(BuildContext context) {
    const double padHeight = 48.0;
    final state = context.watch<WardenHistoryState>();

    final wrapped = state.currentOnScreen.where((w) {
      if (type == null) return true;
      return w.request.requestType == type;
    }).toList();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: padHeight / 2),
        const Divider(height: 1, thickness: 1),
        const SizedBox(height: 12),

        if (state.isErrored)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Center(child: Text(state.errorMessage)),
          )
        else if (state.isLoading && !state.hasData)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (wrapped.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: Text("no request currently")),
          )
        else
          ListView.separated(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: wrapped.length,
            separatorBuilder: (_, __) => const SizedBox(height: 0),
            itemBuilder: (context, index) {
              final w = wrapped[index];
              final req = w.request;
              final stu = w.student;

              final safeName = (stu.name.trim().isNotEmpty)
                  ? stu.name
                  : (stu.enrollmentNo.trim().isNotEmpty
                      ? stu.enrollmentNo
                      : req.studentEnrollmentNumber);

              // Read-only history card: no selection, no actions
              return SimpleActionRequestCard(
                profileImageUrl: stu.profilePic,
                reason: req.reason,
                name: safeName,
                status: req.status,
                leaveType: req.requestType,
                fromDate: req.appliedFrom,
                toDate: req.appliedTo,
                selected: false,
                onLongPress: null,
                onTap: null,
                onRejection: null,
                onAcceptence: null,
              );
            },
          ),
      ],
    );
  }
}
