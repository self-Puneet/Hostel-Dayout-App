import 'dart:math';
import 'package:flutter/material.dart';
import 'package:animated_segmented_tab_control/animated_segmented_tab_control.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

class GlassSegmentedTabs extends StatelessWidget {
  final List<String> options; // Tab labels
  final List<Widget> views;   // Tab content

  // Nullable text sizes
  final double? labelFontSize;
  final double? selectedLabelFontSize;

  // NEW: nullable flag to show/hide segmented tabs
  final bool? showTabs;

  const GlassSegmentedTabs({
    super.key,
    required this.options,
    required this.views,
    this.labelFontSize,
    this.selectedLabelFontSize,
    this.showTabs, // optional
  }) : assert(
          options.length == views.length,
          "Options and views must have the same length",
        );

  @override
  Widget build(BuildContext context) {
    // Resolve sizes with sensible defaults and inheritance
    const double _defaultSize = 12.0;
    final double resolvedLabelSize = labelFontSize ?? _defaultSize;
    final double resolvedSelectedSize =
        selectedLabelFontSize ?? labelFontSize ?? _defaultSize;

    // Resolve visibility with default true
    final bool showTabsResolved = showTabs ?? true; // default on [1][4]

    return DefaultTabController(
      length: options.length,
      child: Column(
        children: [
          if (showTabsResolved) // conditionally render tabs [6][8]
            Stack(
              children: [
                Positioned.fill(
                  child: LiquidGlass(
                    shape: LiquidRoundedSuperellipse(
                      borderRadius: BorderRadius.circular(40).topLeft,
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
                        color: Colors.white.withAlpha((0.05 * 225).toInt()),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: SegmentedTabControl(
                    indicatorPadding: const EdgeInsets.symmetric(vertical: 4),
                    barDecoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    indicatorDecoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    textStyle: TextStyle(fontSize: resolvedLabelSize),
                    selectedTextStyle: TextStyle(
                      color: Colors.white,
                      fontSize: resolvedSelectedSize,
                    ),
                    tabTextColor: Colors.black,
                    selectedTabTextColor: Colors.white,
                    squeezeIntensity: 2,
                    tabs: options.map((option) {
                      return SegmentTab(
                        label: option,
                        splashColor: Colors.transparent,
                        splashHighlightColor: Colors.transparent,
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),

          // Tab views remain visible; tabs can be hidden while views stay mounted
          Expanded(
            child: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              children: views,
            ),
          ),
        ],
      ),
    );
  }
}
