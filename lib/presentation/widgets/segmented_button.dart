// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:animated_segmented_tab_control/animated_segmented_tab_control.dart';
// import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

// class GlassSegmentedTabs extends StatelessWidget {
//   final List<String> options; // Tab labels
//   final List<Widget> views; // Tab content
//   final double? labelFontSize;
//   final double? selectedLabelFontSize;
//   final bool? showTabs;
//   final double margin;

//   const GlassSegmentedTabs({
//     this.margin = 0,
//     super.key,
//     required this.options,
//     required this.views,
//     this.labelFontSize,
//     this.selectedLabelFontSize,
//     this.showTabs,
//   }) : assert(
//          options.length == views.length,
//          "Options and views must have the same length",
//        );

//   @override
//   Widget build(BuildContext context) {
//     const double _defaultSize = 12.0;
//     final double resolvedLabelSize = labelFontSize ?? _defaultSize;
//     final double resolvedSelectedSize =
//         selectedLabelFontSize ?? labelFontSize ?? _defaultSize;
//     final bool showTabsResolved = showTabs ?? true;

//     // Visual height of the segmented control + glass background
//     const double tabsHeight = 48.0;

//     return DefaultTabController(
//       length: options.length,
//       child: LayoutBuilder(
//         builder: (context, constraints) {
//           return SizedBox(
//             height: constraints.maxHeight,
//             width: double.infinity,
//             child: Stack(
//               clipBehavior: Clip.none,
//               children: [
//                 // Content fills the area but starts below half of the tabs,
//                 // so it only slides "behind" the top half of the segmented bar.
//                 Positioned.fill(
//                   top: tabsHeight / 2, // allow underlap only to half height
//                   child: TabBarView(
//                     physics: const NeverScrollableScrollPhysics(),
//                     children: views,
//                   ),
//                 ),
//                 if (showTabsResolved)
//                   Positioned(
//                     top: 0,
//                     left: 0,
//                     right: 0,
//                     height: tabsHeight,
//                     child: Stack(
//                       children: [
//                         // Glass background
//                         Positioned.fill(
//                           left: margin,
//                           right: margin,
//                           child: LiquidGlass(
//                             shape: LiquidRoundedSuperellipse(
//                               borderRadius: BorderRadius.circular(40).topLeft,
//                             ),
//                             settings: const LiquidGlassSettings(
//                               thickness: 10,
//                               blur: 8,
//                               chromaticAberration: 0.01,
//                               lightAngle: pi * 5 / 18,
//                               lightIntensity: 0.5,
//                               refractiveIndex: 1.4,
//                               saturation: 1,
//                               lightness: 1,
//                             ),
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(40),
//                                 color: Colors.white.withAlpha(
//                                   (0.05 * 225).toInt(),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ),
//                         // Segmented control
//                         Container(
//                           height: tabsHeight,
//                           alignment: Alignment.center,
//                           margin: EdgeInsets.symmetric(horizontal: margin),
//                           padding: const EdgeInsets.symmetric(horizontal: 4),
//                           child: SegmentedTabControl(
//                             indicatorPadding: const EdgeInsets.symmetric(
//                               vertical: 4,
//                             ),
//                             barDecoration: BoxDecoration(
//                               color: Colors.transparent,
//                               borderRadius: BorderRadius.circular(999),
//                             ),
//                             indicatorDecoration: BoxDecoration(
//                               color: Colors.black,
//                               borderRadius: BorderRadius.circular(999),
//                             ),
//                             textStyle: TextStyle(fontSize: resolvedLabelSize),
//                             selectedTextStyle: TextStyle(
//                               color: Colors.white,
//                               fontSize: resolvedSelectedSize,
//                             ),
//                             tabTextColor: Colors.black,
//                             selectedTabTextColor: Colors.white,
//                             squeezeIntensity: 2,
//                             tabs: options
//                                 .map(
//                                   (option) => SegmentTab(
//                                     label: option,
//                                     splashColor: Colors.transparent,
//                                     splashHighlightColor: Colors.transparent,
//                                   ),
//                                 )
//                                 .toList(),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
// glass_segmented_tabs.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:animated_segmented_tab_control/animated_segmented_tab_control.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

class GlassSegmentedTabs extends StatefulWidget {
  final List<String> options; // Tab labels
  final List<Widget> views; // Tab content
  final double? labelFontSize;
  final double? selectedLabelFontSize;
  final bool? showTabs;
  final double margin;
  final ValueChanged<int>? onTabChanged; // NEW

  const GlassSegmentedTabs({
    this.margin = 0,
    super.key,
    required this.options,
    required this.views,
    this.labelFontSize,
    this.selectedLabelFontSize,
    this.showTabs,
    this.onTabChanged,
  }) : assert(
         options.length == views.length,
         "Options and views must have the same length",
       );

  @override
  State<GlassSegmentedTabs> createState() => _GlassSegmentedTabsState();
}

class _GlassSegmentedTabsState extends State<GlassSegmentedTabs> {
  TabController? _attached;

  void _attachIfNeeded(TabController? c) {
    if (_attached == c) return;
    _attached?.removeListener(_handleTabChanged);
    _attached = c;
    _attached?.addListener(_handleTabChanged);
  }

  void _handleTabChanged() {
    final c = _attached;
    if (!mounted || c == null) return;
    if (!c.indexIsChanging) {
      widget.onTabChanged?.call(c.index);
    }
  }

  @override
  void dispose() {
    _attached?.removeListener(_handleTabChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double _defaultSize = 12.0;
    final double resolvedLabelSize = widget.labelFontSize ?? _defaultSize;
    final double resolvedSelectedSize =
        widget.selectedLabelFontSize ?? widget.labelFontSize ?? _defaultSize;
    final bool showTabsResolved = widget.showTabs ?? true;

    const double tabsHeight = 48.0;

    return DefaultTabController(
      length: widget.options.length,
      child: Builder(
        // inner context has a DefaultTabController ancestor
        builder: (innerCtx) {
          _attachIfNeeded(DefaultTabController.of(innerCtx));
          return LayoutBuilder(
            builder: (context, constraints) {
              return SizedBox(
                height: constraints.maxHeight,
                width: double.infinity,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned.fill(
                      top: tabsHeight / 2,
                      child: TabBarView(
                        physics: const NeverScrollableScrollPhysics(),
                        children: widget.views,
                      ),
                    ),
                    if (showTabsResolved)
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        height: tabsHeight,
                        child: Stack(
                          children: [
                            Positioned.fill(
                              left: widget.margin,
                              right: widget.margin,
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
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              height: tabsHeight,
                              alignment: Alignment.center,
                              margin: EdgeInsets.symmetric(
                                horizontal: widget.margin,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                              ),
                              child: SegmentedTabControl(
                                indicatorPadding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                ),
                                barDecoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                indicatorDecoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                textStyle: TextStyle(
                                  fontSize: resolvedLabelSize,
                                ),
                                selectedTextStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: resolvedSelectedSize,
                                ),
                                tabTextColor: Colors.black,
                                selectedTabTextColor: Colors.white,
                                squeezeIntensity: 2,
                                tabs: widget.options
                                    .map(
                                      (option) => SegmentTab(
                                        label: option,
                                        splashColor: Colors.transparent,
                                        splashHighlightColor:
                                            Colors.transparent,
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
