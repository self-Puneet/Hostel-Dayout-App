// lib/presentation/view/student/widgets/month_group_card.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hostel_mgmt/core/enums/enum.dart';
import 'package:hostel_mgmt/models/request_model.dart';
import 'package:hostel_mgmt/presentation/components/simple_request_card.dart';

class MonthGroupCard extends StatefulWidget {
  final String monthTitle;
  final List<RequestModel> requests;
  final TimelineActor actor;

  const MonthGroupCard({
    super.key,
    required this.monthTitle,
    required this.requests,
    required this.actor,
  });

  @override
  State<MonthGroupCard> createState() => _MonthGroupCardState();
}

class _MonthGroupCardState extends State<MonthGroupCard> {
  bool _expanded = false; // local expansion state
  int _resetTick = 0; // bump to force ExpansionTile rebuild
  TabController? _tabController;
  int _lastIndex = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final controller = DefaultTabController.of(context);
    if (_tabController != controller) {
      _tabController?.removeListener(_onTabChanged);
      _tabController = controller;
      if (_tabController != null) {
        _lastIndex = _tabController!.index;
        _tabController!.addListener(_onTabChanged);
      }
    }
  }

  void _onTabChanged() {
    if (_tabController == null) return;
    // Run after the tab finishes changing
    if (!_tabController!.indexIsChanging &&
        _tabController!.index != _lastIndex) {
      setState(() {
        _expanded = false; // collapse this card on every tab switch
        _resetTick++; // change key to reinitialize ExpansionTile state
      });
      _lastIndex = _tabController!.index;
    }
  }

  @override
  void dispose() {
    _tabController?.removeListener(_onTabChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x66000000),
            blurRadius: 2,
            spreadRadius: 0.4,
            offset: Offset(0, 0),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: Theme(
          data: Theme.of(context).copyWith(
            dividerColor: Colors.transparent,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            hoverColor: Colors.transparent,
          ),
          child: ExpansionTile(
            // No PageStorageKey → no persistence across tabs
            // Use a ValueKey that changes after tab switches so initiallyExpanded is reapplied
            key: ValueKey<String>('exp:${_resetTick}:${widget.monthTitle}'),
            initiallyExpanded: _expanded,
            onExpansionChanged: (val) => setState(() => _expanded = val),
            backgroundColor: Colors.white,
            collapsedBackgroundColor: Colors.white,
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
                Text(
                  widget.monthTitle,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            trailing: _Chevron(expanded: _expanded),
            children: [
              const Divider(color: Colors.black87, thickness: 1),
              ..._buildRequestList(widget.requests),
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
            requestId: r.id,
            actor: widget.actor,
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
        widgets.add(const Divider(color: Color(0x1A000000)));
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
      turns: expanded ? 0.5 : 0.0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      child: const Icon(
        Icons.keyboard_arrow_down_rounded,
        size: 25,
        color: Colors.black,
      ),
    );
  }
}
