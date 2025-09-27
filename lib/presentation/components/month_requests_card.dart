// lib/presentation/view/student/widgets/month_group_card.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hostel_mgmt/models/request_model.dart';
import 'package:hostel_mgmt/presentation/components/simple_request_card.dart';
import 'package:provider/provider.dart';
import 'package:hostel_mgmt/presentation/view/student/state/history_state.dart';

class MonthGroupCard extends StatelessWidget {
  final String monthTitle;
  final List<RequestModel> requests;

  const MonthGroupCard({
    super.key,
    required this.monthTitle,
    required this.requests,
  });

  @override
  Widget build(BuildContext context) {
    final history = context.watch<HistoryState>();
    final expanded = history.isMonthExpanded[monthTitle] ?? false;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        // border: Border.all(color: const Color(0xFF2A2A2A), width: 1.2),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color(0x66000000), // #00000040 → 40 hex = 25% opacity
            blurRadius: 2, // like the "2px"
            spreadRadius: 0.4, // like the "0.4px"
            offset: Offset(0, 0), // x=0, y=0
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: Theme(
          // Keep ExpansionTile visuals transparent so the Container drives the look
          data: Theme.of(context).copyWith(
            dividerColor: Colors.transparent,
            splashColor: Colors.transparent, // remove ripple splash
            highlightColor: Colors.transparent, // remove tap highlight
            hoverColor:
                Colors.transparent, // remove hover highlight (for web/desktop)
          ),
          child: ExpansionTile(
            key: PageStorageKey<String>(monthTitle),
            initiallyExpanded: expanded,
            onExpansionChanged: (val) =>
                history.setMonthExpanded(monthTitle, val),
            backgroundColor: Colors.white,
            collapsedBackgroundColor: Colors.white,
            // No tile border; outer Container draws it
            shape: const RoundedRectangleBorder(
              side: BorderSide(color: Colors.transparent),
            ),
            collapsedShape: const RoundedRectangleBorder(
              side: BorderSide(color: Colors.transparent),
            ),
            tilePadding: const EdgeInsets.fromLTRB(30, 20, 20, 14),
            childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Month',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: Colors.black87,
                  ),
                ),
                // const SizedBox(height: 6),
                Text(
                  monthTitle,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            trailing: _Chevron(expanded: expanded),
            children: [
              // const SizedBox(height: 6),
              const Divider(color: Colors.black87, thickness: 1),
              // const SizedBox(height: 6),
              ..._buildRequestList(requests),
              const SizedBox(height: 4),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildRequestList(List<RequestModel> items) {
    final widgets = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      final r = items[i];
      widgets.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: SimpleRequestCard(
            requestType: r.requestType,
            fromDate: r.appliedFrom,
            toDate: r.appliedTo,
            status: r.status,
            statusDate: r.lastUpdatedAt,
            reason: r.reason,
          ),
        ),
      );
      if (i != items.length - 1) {
        widgets.add(
          const Divider(color: Color(0x1A000000)),
        ); // subtle divider between rows
      }
    }
    return widgets;
  }
}

class _Chevron extends StatelessWidget {
  final bool expanded;
  const _Chevron({required this.expanded});

  @override
  Widget build(BuildContext context) {
    return AnimatedRotation(
      turns: expanded ? 0.5 : 0.0, // 180° on expand
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: Container(
        padding: const EdgeInsets.all(6),
        // decoration: BoxDecoration(
        // color: const Color(0xFFF1F1F1),
        // borderRadius: BorderRadius.circular(12),
        // border: Border.all(color: const Color(0xFF2A2A2A), width: 1),
        // ),
        child: const Icon(
          Icons.keyboard_arrow_down_rounded,
          size: 25,
          color: Colors.black,
        ),
      ),
    );
  }
}
