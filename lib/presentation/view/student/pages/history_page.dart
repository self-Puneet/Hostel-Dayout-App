// lib/presentation/view/student/history_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hostel_mgmt/core/helpers/app_refreasher_widget.dart';
import 'package:hostel_mgmt/presentation/components/month_requests_card.dart';
import 'package:provider/provider.dart';

import 'package:hostel_mgmt/presentation/view/student/state/history_state.dart';
import 'package:hostel_mgmt/presentation/widgets/liquid_glass_morphism/liquid_back_button.dart';
import 'package:hostel_mgmt/presentation/widgets/segmented_button.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HistoryState(),
      child: const _HistoryPageView(),
    );
  }
}

class _HistoryPageView extends StatefulWidget {
  const _HistoryPageView();

  @override
  State<_HistoryPageView> createState() => _HistoryPageViewState();
}

class _HistoryPageViewState extends State<_HistoryPageView> {
  @override
  void initState() {
    super.initState();
    // Trigger initial load once the widget is mounted
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HistoryState>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final padding = 31 * mediaQuery.size.width / 402;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: true,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 26,
                vertical: mediaQuery.size.height * 25 / 874,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: LiquidGlassBackButton(
                      onPressed: () => Navigator.of(context).pop(),
                      radius: 30,
                    ),
                  ),
                  Text(
                    'History',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.normal,
                      fontSize: 28,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                constraints: const BoxConstraints(minWidth: double.infinity),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(233, 233, 233, 1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  border: Border.all(color: Colors.black, width: 1.6),
                ),
                child: Container(
                  margin: const EdgeInsets.only(top: 30),
                  child: Consumer<HistoryState>(
                    builder: (context, historyState, _) {
                      final views = [
                        HistoryListView(filter: 'All'),
                        HistoryListView(filter: 'Cancelled'),
                        HistoryListView(filter: 'Accepted'),
                        HistoryListView(filter: 'Rejected'),
                      ];
                      return AppRefreshWrapper(
                        onRefresh: () async {
                          await context.read<HistoryState>().load();
                        },
                        child: GlassSegmentedTabs(
                          options: historyState.filterOptions,
                          views: views,
                          margin: padding,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class HistoryListView extends StatelessWidget {
//   final String filter;
//   const HistoryListView({super.key, required this.filter});

//   @override
//   Widget build(BuildContext context) {
//     final mediaQuery = MediaQuery.of(context);
//     final padding = 31 * mediaQuery.size.width / 402;

//     return Consumer<HistoryState>(
//       builder: (context, state, _) {
//         if (state.isLoading) {
//           return const Center(child: CircularProgressIndicator());
//         }
//         if (state.isErrored) {
//           return Center(
//             child: Text(
//               state.errorMessage,
//               style: const TextStyle(color: Colors.red),
//             ),
//           );
//         }

//         final grouped = state.groupedForFilter(filter);
//         final monthKeys = state.sortedMonthKeys(grouped.keys);

//         if (monthKeys.isEmpty) {
//           return const Center(child: Text('No requests found'));
//         }

//         return ListView.builder(
//           padding: const EdgeInsets.fromLTRB(0, 30, 0, 0), // tiny inset
//           itemCount: monthKeys.length,
//           itemBuilder: (context, index) {
//             final key = monthKeys[index];
//             final items = grouped[key]!;
//             return Padding(
//               padding: EdgeInsetsGeometry.symmetric(horizontal: padding),
//               child: MonthGroupCard(monthTitle: key, requests: items),
//             );
//           },
//         );
//       },
//     );
//   }
// }
class HistoryListView extends StatelessWidget {
  final String filter;
  const HistoryListView({super.key, required this.filter});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final padding = 31 * mediaQuery.size.width / 402;

    return Consumer<HistoryState>(
      builder: (context, state, _) {
        // Error state: keep pull-to-refresh available
        if (state.isErrored) {
          return AppRefreshWrapper(
            onRefresh: () async => context.read<HistoryState>().load(),
            child: const CustomScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: Text('Something went wrong')),
                ),
              ],
            ),
          );
        }

        // Loading state can stay as-is, or also be scrollable if desired
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final grouped = state.groupedForFilter(filter);
        final monthKeys = state.sortedMonthKeys(grouped.keys);

        // Empty: still scrollable so pull-to-refresh works
        if (monthKeys.isEmpty) {
          return AppRefreshWrapper(
            onRefresh: () async => context.read<HistoryState>().load(),
            child: const CustomScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(child: Text('No requests found')),
                ),
              ],
            ),
          );
        }

        // Non-empty: a scrollable ListView with AlwaysScrollableScrollPhysics
        return AppRefreshWrapper(
          onRefresh: () async => context.read<HistoryState>().load(),
          child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
            itemCount: monthKeys.length,
            itemBuilder: (context, index) {
              final key = monthKeys[index];
              final items = grouped[key]!;
              return Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: padding),
                child: MonthGroupCard(monthTitle: key, requests: items),
              );
            },
          ),
        );
      },
    );
  }
}
