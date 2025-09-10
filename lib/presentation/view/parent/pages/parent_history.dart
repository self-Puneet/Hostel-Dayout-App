import 'package:flutter/material.dart';
import 'package:hostel_mgmt/presentation/view/student/state/history_state.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hostel_mgmt/presentation/widgets/liquid_glass_morphism/liquid_back_button.dart';
import 'package:hostel_mgmt/presentation/widgets/segmented_button.dart';
import 'package:provider/provider.dart';

class ParentHistoryPage extends StatelessWidget {
  const ParentHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HistoryState(),
      child: _ParentHistoryPageView(),
    );
  }
}

class _ParentHistoryPageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: true,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 26,
                // top: mediaQuery.size.height * 50 / 874,
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
                    textAlign: TextAlign.center,
                    'History',
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
                    topLeft: Radius.circular(46),
                    topRight: Radius.circular(46),
                  ),
                  // border: Border.all(color: Colors.black, width: 1.6),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 35, right: 35, top: 30),
                  child: // consumer of Home state
                  Consumer<HistoryState>(
                    builder: (context, historyState, child) {
                      return GlassSegmentedTabs(
                        options: historyState.filterOptions,
                        views: [
                          Center(child: Text("Page Under Construction")),
                          Center(child: Text("Page Under Construction")),
                          Center(child: Text("Page Under Construction")),
                          Center(child: Text("Page Under Construction")),
                        ],
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
