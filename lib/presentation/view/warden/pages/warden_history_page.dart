import 'package:flutter/material.dart';
import 'package:hostel_mgmt/core/enums/enum.dart';
import 'package:hostel_mgmt/presentation/view/warden/controller/warden_history_controller.dart';
import 'package:hostel_mgmt/presentation/view/warden/state/warden_action_state.dart';
import 'package:hostel_mgmt/presentation/view/warden/state/warden_history_state.dart';
import 'package:hostel_mgmt/presentation/widgets/segmented_scrollable_tab_view.dart';

// Assume WardenTab is already defined elsewhere in your project
// and it has a .values list and a .label(actor) method like before.
// import 'warden_tab.dart'; // <-- update this import to match your project

class WardenHistoryPage extends StatefulWidget {
  final TimelineActor actor;

  const WardenHistoryPage({super.key, required this.actor});

  @override
  State<WardenHistoryPage> createState() => _WardenHistoryPageState();
}

class _WardenHistoryPageState extends State<WardenHistoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: WardenTab.values.length, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final labels = WardenTab.values.map((t) => t.label(widget.actor)).toList();
    final horizontalPad = EdgeInsets.symmetric(
      horizontal: 31 * media.size.width / 402,
    );
    // text field controller
    final TextEditingController _controller = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xFFE9E9E9),

      body: Column(
        children: [
          Padding(
            padding: horizontalPad,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
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
          ),
          const SizedBox(height: 12),
          Padding(
            padding: horizontalPad,
            child: SegmentedTabs(controller: _tabs, labels: labels),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: horizontalPad,
            child: Divider(thickness: 2, color: Colors.grey.shade300),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabs,
              physics: const NeverScrollableScrollPhysics(),
              children: List.generate(
                WardenTab.values.length,
                (index) => const _EmptyHistoryTab(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget hostelWidget(WardenActionState s) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 10),
  //     child: s.hostelIds.length <= 1 && s.selectedHostelId != null
  //         ? SizedBox(
  //             height: 50,
  //             child: Row(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 const Icon(Icons.home, color: Colors.blueGrey, size: 18),
  //                 const SizedBox(width: 5),
  //                 Expanded(
  //                   child: Text(
  //                     s.selectedHostelId!,
  //                     maxLines: 1,
  //                     overflow: TextOverflow.ellipsis,
  //                     textAlign: TextAlign.center,
  //                     style: const TextStyle(
  //                       fontWeight: FontWeight.w500,
  //                       fontSize: 13,
  //                       color: Colors.blueGrey,
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           )
  //         : SizedBox(
  //             height: 50,
  //             child: DropdownButtonHideUnderline(
  //               child: DropdownButton<String>(
  //                 isDense: true,
  //                 isExpanded: true,
  //                 itemHeight: 48.0,
  //                 value:
  //                     s.selectedHostelId ??
  //                     (s.hostelIds.isNotEmpty ? s.hostelIds.first : null),
  //                 items: s.hostelIds
  //                     .map(
  //                       (id) => DropdownMenuItem<String>(
  //                         value: id,
  //                         child: Row(
  //                           children: [
  //                             const Icon(
  //                               Icons.home,
  //                               color: Colors.blueGrey,
  //                               size: 16,
  //                             ),
  //                             const SizedBox(width: 6),
  //                             Expanded(
  //                               child: Text(
  //                                 id,
  //                                 overflow: TextOverflow.ellipsis,
  //                                 style: const TextStyle(
  //                                   fontSize: 13,
  //                                   color: Colors.black87,
  //                                 ),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     )
  //                     .toList(),
  //                 onChanged: (val) async {
  //                   if (val == null) return;
  //                   s.setSelectedHostelId(val);
  //                   s.resetForHostelChange();
  //                   await WardenActionPageController(
  //                     s,
  //                   ).fetchRequestsFromApi(hostelId: val);
  //                 },
  //                 icon: const Icon(
  //                   Icons.keyboard_arrow_down_rounded,
  //                   color: Colors.blueGrey,
  //                 ),
  //                 iconSize: 20,
  //                 style: const TextStyle(fontSize: 13, color: Colors.black87),
  //                 dropdownColor: Colors.white,
  //               ),
  //             ),
  //           ),
  //   );
  // }
Widget hostelWidget(WardenHistoryState s) {
  if (s.hostels.length <= 1 && s.selectedHostelId != null) {
    // Single hostel: just show name
    return SizedBox(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.home, color: Colors.blueGrey, size: 18),
          const SizedBox(width: 5),
          Expanded(
            child: Text(
              s.selectedHostelName ?? '',
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
    );
  }
  // Multiple hostels: dropdown by id, display name
  return SizedBox(
    height: 50,
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        isDense: true,
        isExpanded: true,
        itemHeight: 48.0,
        value: s.selectedHostelId,
        items: s.hostels.map((hostel) => DropdownMenuItem<String>(
          value: hostel.hostelId,
          child: Row(
            children: [
              const Icon(Icons.home, color: Colors.blueGrey, size: 16),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  hostel.hostelName,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13, color: Colors.black87),
                ),
              ),
            ],
          ),
        )).toList(),
        onChanged: (val) async {
          if (val == null) return;
          s.setSelectedHostelId(val);
          s.clearForHostelOrMonthChange();
          await WardenHistoryPageController(s).fetchRequestsFromApi(hostelId: val);
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

class _EmptyHistoryTab extends StatelessWidget {
  const _EmptyHistoryTab();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'No history requests found',
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey.shade600,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
