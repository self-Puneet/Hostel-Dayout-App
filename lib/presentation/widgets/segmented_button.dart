import 'dart:math';
import 'package:flutter/material.dart';
import 'package:animated_segmented_tab_control/animated_segmented_tab_control.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

class GlassSegmentedTabs extends StatelessWidget {
  final List<String> options; // Tab labels
  final List<Widget> views; // Tab content

  const GlassSegmentedTabs({
    super.key,
    required this.options,
    required this.views,
  }) : assert(
         options.length == views.length,
         "Options and views must have the same length",
       );

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: options.length,
      child: Column(
        children: [
          Stack(
            children: [
              // Glass background (fills Stack size)
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
                      color: Colors.white.withAlpha(
                        (0.05 * 225).toInt(),
                      ), // subtle tint
                    ),
                  ),
                ),
              ),

              // Foreground (tabs)
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
                  textStyle: const TextStyle(fontSize: 12),
                  selectedTextStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
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

          // Tab views
          Expanded(child: TabBarView(children: views)),
        ],
      ),
    );
  }
}
