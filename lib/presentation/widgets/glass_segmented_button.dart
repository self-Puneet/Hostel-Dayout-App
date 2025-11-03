import 'dart:math';
import 'package:flutter/material.dart';
import 'package:animated_segmented_tab_control/animated_segmented_tab_control.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

class GlassSegmentedTabs extends StatefulWidget {
  final List<String> options;
  final List<Widget> views;
  final double? labelFontSize;
  final double? selectedLabelFontSize;
  final bool? showTabs;
  final double margin;
  final ValueChanged<int>? onTabChanged;

  const GlassSegmentedTabs({
    super.key,
    required this.options,
    required this.views,
    this.labelFontSize,
    this.selectedLabelFontSize,
    this.showTabs,
    this.onTabChanged,
    this.margin = 0,
  }) : assert(
         options.length == views.length,
         "Options and views must have the same length",
       );

  @override
  State<GlassSegmentedTabs> createState() => _GlassSegmentedTabsState();
}

class _GlassSegmentedTabsState extends State<GlassSegmentedTabs>
    with SingleTickerProviderStateMixin {
  TabController? _attached;
  int _index = 0;

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
      setState(() => _index = c.index);
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
    const tabsHeight = 48.0;
    const double _defaultSize = 12.0;
    final double resolvedLabelSize = widget.labelFontSize ?? _defaultSize;
    final double resolvedSelectedSize =
        widget.selectedLabelFontSize ?? widget.labelFontSize ?? _defaultSize;
    final bool showTabsResolved = widget.showTabs ?? true;

    Widget header(BuildContext context) => Stack(
      children: [
        Positioned.fill(
          left: widget.margin,
          right: widget.margin,
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
                // color: Colors.transparent,
                color: Colors.white.withAlpha((0.05 * 225).toInt()),
              ),
            ),
          ),
        ),
        Container(
          height: tabsHeight,
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(horizontal: widget.margin),
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
            tabs: widget.options
                .map(
                  (label) => SegmentTab(
                    label: label,
                    splashColor: Colors.transparent,
                    splashHighlightColor: Colors.transparent,
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );

    return DefaultTabController(
      length: widget.options.length,
      child: Builder(
        builder: (innerCtx) {
          _attachIfNeeded(DefaultTabController.of(innerCtx));
          // BOUNDED HEIGHT: overlay header above content so lists slide behind it
          return Stack(
            clipBehavior: Clip.none,
            children: [
              // Content layer fills available space, offset below the header
              Positioned.fill(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: showTabsResolved ? tabsHeight / 2 : 0,
                  ),
                  child: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    children: widget.views,
                  ),
                ),
              ),
              // Overlay header stays fixed at the top
              if (showTabsResolved)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: tabsHeight,
                  child: header(context),
                ),
            ],
          );
        },
      ),
    );
  }
}
