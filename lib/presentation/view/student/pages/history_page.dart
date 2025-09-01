// create a demo history Page
import 'package:animated_segmented_tab_control/animated_segmented_tab_control.dart';
import 'package:flutter/material.dart';
import 'package:hostel_mgmt/presentation/view/student/state/history_state.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hostel_mgmt/presentation/widgets/liquid_glass_morphism/liquid_back_button.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:provider/provider.dart';
import 'dart:math';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => HistoryState(),
      child: _HistoryPageView(),
    );
  }
}

class _HistoryPageView extends StatelessWidget {
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
                  border: Border.all(color: Colors.black, width: 1.6),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 35, right: 35, top: 30),
                  child: // consumer of Home state
                  Consumer<HistoryState>(
                    builder: (context, historyState, child) {
                      return DefaultTabController(
                        length:
                            historyState.filterOptions.length, // number of tabs
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                // Glass background (fills Stack size)
                                Positioned.fill(
                                  child: LiquidGlass(
                                    shape: LiquidRoundedSuperellipse(
                                      borderRadius: BorderRadius.circular(
                                        40,
                                      ).topLeft,
                                    ),
                                    settings: const LiquidGlassSettings(
                                      thickness: 10,
                                      blur: 8,
                                      chromaticAberration: 0.01,
                                      lightAngle: pi * 5 / 18,
                                      lightIntensity: 0.5,
                                      refractiveIndex: 1.4,
                                      saturation: 1,
                                      lightness: 1,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(40),
                                        color: Colors.white.withAlpha(
                                          (0.05 * 225).toInt(),
                                        ), // subtle tint
                                      ),
                                    ),
                                  ),
                                ),

                                // Foreground (tabs) drives the size of the Stack
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 4,
                                  ),
                                  child: SegmentedTabControl(
                                    indicatorPadding:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    barDecoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    indicatorDecoration: BoxDecoration(
                                      color: Colors.black,
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    textStyle: const TextStyle(fontSize: 12),
                                    selectedTextStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                    tabTextColor: Colors.black,
                                    selectedTabTextColor: Colors.white,
                                    squeezeIntensity: 2,
                                    tabs: [
                                      ...historyState.filterOptions.map((
                                        option,
                                      ) {
                                        return SegmentTab(
                                          label: option,
                                          splashColor: Colors.transparent,
                                          splashHighlightColor:
                                              Colors.transparent,
                                        );
                                      }),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const Expanded(
                              child: TabBarView(
                                children: [
                                  Center(child: Text('Student History')),
                                  Center(child: Text('Warden History')),
                                  Center(child: Text('Parent History')),
                                  Center(child: Text('Admin History')),
                                ],
                              ),
                            ),
                          ],
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
