// // lib/presentation/widgets/collapsing_header.dart
// import 'dart:math' as math;
// import 'dart:ui' as ui; // for lerpDouble
// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:hostel_mgmt/presentation/widgets/liquid_glass_morphism/liquid_back_button.dart';

// class OneUiCollapsingHeader extends StatelessWidget {
//   const OneUiCollapsingHeader({
//     super.key,
//     required this.title,
//     required this.vsync, // required for snap on floating headers
//     this.onBack,
//     this.leading,
//     this.actions,
//     this.backgroundColor,
//     this.foregroundColor,
//     this.expandedHeight = 160,
//     this.toolbarHeight = kToolbarHeight,
//     this.largeTitleTextStyle,
//     this.smallTitleTextStyle,
//     this.leadingRadiusExpanded = 35,
//     this.leadingRadiusCollapsed = 26,

//     // Base padding knobs (constant margins)
//     this.largeTitlePadding = const EdgeInsets.fromLTRB(50, 0, 16, 20),
//     this.smallTitlePadding = const EdgeInsets.symmetric(horizontal: 8),

//     // Fixed leading area width and padding
//     this.leadingWidth,
//     this.leadingPaddingLeft = 0, // NEW: fixed left padding for back button
//     this.actionsPadding,

//     this.showBottomDividerWhenCollapsed = true,
//     this.snapDuration = const Duration(milliseconds: 220),
//     this.snapCurve = Curves.easeOutCubic,

//     // Precise control of large title position relative to the back button
//     this.largeTitleGapExpanded =
//         12, // gap between back button and large title (expanded)
//     this.largeTitleGapCollapsed = 4, // gap near collapsed
//     this.largeTitleTopPaddingExpanded = 2, // extra top padding (expanded)
//     this.largeTitleTopPaddingCollapsed =
//         0, // extra top padding (near collapsed)
//   });

//   final String title;
//   final TickerProvider vsync;

//   final VoidCallback? onBack;
//   final Widget? leading;
//   final List<Widget>? actions;

//   final double leadingRadiusExpanded;
//   final double leadingRadiusCollapsed;
//   final Color? backgroundColor;
//   final Color? foregroundColor;
//   final double expandedHeight;
//   final double toolbarHeight;

//   final TextStyle? largeTitleTextStyle;
//   final TextStyle? smallTitleTextStyle;

//   final EdgeInsetsGeometry largeTitlePadding;
//   final EdgeInsetsGeometry smallTitlePadding;

//   final double? leadingWidth;
//   final double leadingPaddingLeft; // NEW
//   final EdgeInsetsGeometry? actionsPadding;

//   final bool showBottomDividerWhenCollapsed;
//   final Duration snapDuration;
//   final Curve snapCurve;

//   // Position controls
//   final double largeTitleGapExpanded;
//   final double largeTitleGapCollapsed;
//   final double largeTitleTopPaddingExpanded;
//   final double largeTitleTopPaddingCollapsed;

//   @override
//   Widget build(BuildContext context) {
//     final top = MediaQuery.viewPaddingOf(context).top;
//     final scheme = Theme.of(context).colorScheme;

//     final TextStyle defaultLarge =
//         Theme.of(context).textTheme.headlineMedium?.copyWith(
//           color: scheme.onSurface,
//           fontWeight: FontWeight.w700,
//         ) ??
//         TextStyle(
//           fontSize: 28,
//           fontWeight: FontWeight.w700,
//           color: scheme.onSurface,
//         );

//     final TextStyle defaultSmall =
//         Theme.of(context).textTheme.titleMedium?.copyWith(
//           color: scheme.onSurface,
//           fontWeight: FontWeight.w600,
//         ) ??
//         TextStyle(
//           fontSize: 18,
//           fontWeight: FontWeight.w600,
//           color: scheme.onSurface,
//         );

//     return SliverPersistentHeader(
//       pinned: true,
//       floating: true, // keep floating to allow snap
//       delegate: _OneUiHeaderDelegate(
//         title: title,
//         vsync: vsync,
//         leading: LiquidGlassBackButton(
//           onPressed: () => Navigator.of(context).pop(),
//           enableGlass: false,
//           radius: 35,
//         ),
//         // leading ??
//         // (onBack == null ? null : _DefaultBackButton(onPressed: onBack)),
//         leadingRadiusExpanded: leadingRadiusExpanded,
//         leadingRadiusCollapsed: leadingRadiusCollapsed,
//         actions: actions,
//         backgroundColor: backgroundColor ?? scheme.surface,
//         foregroundColor: foregroundColor ?? scheme.onSurface,
//         maxExtentWithoutSafeArea: expandedHeight,
//         minToolbarHeight: toolbarHeight,
//         safeAreaTop: top,
//         largeTitleTextStyle: largeTitleTextStyle ?? defaultLarge,
//         smallTitleTextStyle: smallTitleTextStyle ?? defaultSmall,
//         largeTitlePadding: largeTitlePadding,
//         smallTitlePadding: smallTitlePadding,
//         leadingWidth: leadingWidth ?? kToolbarHeight,
//         leadingPaddingLeft: leadingPaddingLeft, // NEW
//         actionsPadding: actionsPadding ?? const EdgeInsets.only(right: 4),
//         showBottomDividerWhenCollapsed: showBottomDividerWhenCollapsed,
//         snapDuration: snapDuration,
//         snapCurve: snapCurve,
//         largeTitleGapExpanded: largeTitleGapExpanded,
//         largeTitleGapCollapsed: largeTitleGapCollapsed,
//         largeTitleTopPaddingExpanded: largeTitleTopPaddingExpanded,
//         largeTitleTopPaddingCollapsed: largeTitleTopPaddingCollapsed,
//       ),
//     );
//   }
// }

// class _OneUiHeaderDelegate extends SliverPersistentHeaderDelegate {
//   _OneUiHeaderDelegate({
//     required this.title,
//     required this.leadingRadiusExpanded,
//     required this.leadingRadiusCollapsed,
//     required TickerProvider vsync,
//     required this.backgroundColor,
//     required this.foregroundColor,
//     required this.maxExtentWithoutSafeArea,
//     required this.minToolbarHeight,
//     required this.safeAreaTop,
//     required this.largeTitleTextStyle,
//     required this.smallTitleTextStyle,
//     required this.largeTitlePadding,
//     required this.smallTitlePadding,
//     required this.leadingWidth,
//     required this.leadingPaddingLeft, // NEW
//     required this.actionsPadding,
//     required this.showBottomDividerWhenCollapsed,
//     required this.snapDuration,
//     required this.snapCurve,
//     required this.largeTitleGapExpanded,
//     required this.largeTitleGapCollapsed,
//     required this.largeTitleTopPaddingExpanded,
//     required this.largeTitleTopPaddingCollapsed,
//     this.leading,
//     this.actions,
//   }) : _vsync = vsync;

//   final double leadingRadiusExpanded;
//   final double leadingRadiusCollapsed;

//   final String title;
//   final TickerProvider _vsync;

//   final Widget? leading;
//   final List<Widget>? actions;

//   final Color backgroundColor;
//   final Color foregroundColor;

//   final double maxExtentWithoutSafeArea;
//   final double minToolbarHeight;
//   final double safeAreaTop;

//   final TextStyle largeTitleTextStyle;
//   final TextStyle smallTitleTextStyle;

//   final EdgeInsetsGeometry largeTitlePadding;
//   final EdgeInsetsGeometry smallTitlePadding;

//   final double leadingWidth;
//   final double leadingPaddingLeft; // NEW
//   final EdgeInsetsGeometry actionsPadding;

//   final bool showBottomDividerWhenCollapsed;
//   final Duration snapDuration;
//   final Curve snapCurve;

//   // Position controls
//   final double largeTitleGapExpanded;
//   final double largeTitleGapCollapsed;
//   final double largeTitleTopPaddingExpanded;
//   final double largeTitleTopPaddingCollapsed;

//   // Non-overlapping cross-fade thresholds.
//   static const double _largeDisappear = 0.45;
//   static const double _smallAppear = 0.55;

//   @override
//   double get minExtent => safeAreaTop + minToolbarHeight;

//   @override
//   double get maxExtent =>
//       math.max(minExtent, safeAreaTop + maxExtentWithoutSafeArea);

//   double _t(double shrinkOffset) {
//     final total = (maxExtent - minExtent).clamp(0.0, double.infinity);
//     if (total == 0) return 1;
//     return (shrinkOffset / total).clamp(0.0, 1.0);
//   }

//   @override
//   Widget build(
//     BuildContext context,
//     double shrinkOffset,
//     bool overlapsContent,
//   ) {
//     final tRaw = _t(shrinkOffset);
//     final t = Curves.easeOut.transform(tRaw);

//     // Disjoint opacities.
//     final double largeOpacity = t <= _largeDisappear
//         ? 1 - (t / _largeDisappear)
//         : 0;
//     final double smallOpacity = t >= _smallAppear
//         ? (t - _smallAppear) / (1 - _smallAppear)
//         : 0;

//     // Subtle translations.
//     final largeTranslate = Tween<double>(begin: 0, end: -12).transform(t);
//     final smallTranslate = Tween<double>(begin: 8, end: 0).transform(t);

//     // Resolve paddings (unchanged)
//     final EdgeInsets smallPad = smallTitlePadding.resolve(TextDirection.ltr);
//     final EdgeInsets largePad = largeTitlePadding.resolve(TextDirection.ltr);

//     // Animated gap (unchanged)
//     final double gap = ui.lerpDouble(
//       largeTitleGapExpanded,
//       largeTitleGapCollapsed,
//       t,
//     )!;

//     // Left offset for the large title (unchanged)
//     final double largeLeft =
//         smallPad.left + leadingPaddingLeft + leadingWidth + gap + largePad.left;

//     // CHANGE: anchor large title to the SAME row top as the back button.
//     final double largeTopExtra = ui.lerpDouble(
//       largeTitleTopPaddingExpanded,
//       largeTitleTopPaddingCollapsed,
//       t,
//     )!;

//     // Use smallPad.top as the base so it's aligned with the toolbar/back button row.
//     final double largeTop = smallPad.top + largeTopExtra;
//     return Material(
//       color: backgroundColor,
//       elevation: 0,
//       child: Container(
//         padding: EdgeInsets.only(top: safeAreaTop),
//         child: Stack(
//           fit: StackFit.expand,
//           children: [
//             // Large title to the right of the back button (expanded state)
//             Positioned(
//               top: largeTop, // <-- now shares the toolbar row's top
//               left: largeLeft,
//               right: largePad.right,
//               height:
//                   minToolbarHeight, // <-- same height as the row that holds the back button
//               child: Offstage(
//                 offstage: largeOpacity == 0,
//                 child: Opacity(
//                   opacity: largeOpacity,
//                   child: Transform.translate(
//                     offset: Offset(0, largeTranslate),
//                     child: Align(
//                       alignment: Alignment
//                           .centerLeft, // centers vertically like IconButton row
//                       child: DefaultTextStyle(
//                         style: largeTitleTextStyle,
//                         maxLines: 1,
//                         overflow: TextOverflow.ellipsis,
//                         child: Text(
//                           title,
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             // Toolbar with fixed-position back button and small title
//             Padding(
//               padding: smallPad,
//               child: SizedBox(
//                 height: minToolbarHeight,
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     // Fixed left padding for back button (applies in all states)
//                     Padding(
//                       padding: EdgeInsets.only(left: leadingPaddingLeft),
//                       child: SizedBox(
//                         width: leadingWidth,
//                         child: Align(
//                           alignment: Alignment.centerLeft,
//                           child: IconTheme(
//                             data: IconThemeData(color: foregroundColor),
//                             child: leading ?? const SizedBox.shrink(),
//                           ),
//                         ),
//                       ),
//                     ),

//                     Expanded(
//                       child: Offstage(
//                         offstage: smallOpacity == 0,
//                         child: Opacity(
//                           opacity: smallOpacity,
//                           child: Transform.translate(
//                             offset: Offset(0, smallTranslate),
//                             child: DefaultTextStyle(
//                               style: smallTitleTextStyle,
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                               child: Text(
//                                 title,
//                                 maxLines: 1,
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),

//                     Padding(
//                       padding: actionsPadding,
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: actions ?? const [],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),

//             if (showBottomDividerWhenCollapsed)
//               Align(
//                 alignment: Alignment.bottomCenter,
//                 child: Opacity(
//                   opacity: smallOpacity,
//                   child: const Divider(height: 1),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   // Enable snapping for floating headers.
//   @override
//   FloatingHeaderSnapConfiguration? get snapConfiguration =>
//       FloatingHeaderSnapConfiguration(duration: snapDuration, curve: snapCurve);

//   // Provide vsync for the snap animation.
//   @override
//   TickerProvider get vsync => _vsync;

//   @override
//   bool shouldRebuild(covariant _OneUiHeaderDelegate old) {
//     return title != old.title ||
//         leadingWidth != old.leadingWidth ||
//         leadingPaddingLeft != old.leadingPaddingLeft ||
//         backgroundColor != old.backgroundColor ||
//         foregroundColor != old.foregroundColor ||
//         maxExtentWithoutSafeArea != old.maxExtentWithoutSafeArea ||
//         minToolbarHeight != old.minToolbarHeight ||
//         safeAreaTop != old.safeAreaTop ||
//         largeTitleTextStyle != old.largeTitleTextStyle ||
//         smallTitleTextStyle != old.smallTitleTextStyle ||
//         largeTitlePadding != old.largeTitlePadding ||
//         smallTitlePadding != old.smallTitlePadding ||
//         showBottomDividerWhenCollapsed != old.showBottomDividerWhenCollapsed ||
//         actionsPadding != old.actionsPadding ||
//         (actions?.length ?? 0) != (old.actions?.length ?? 0) ||
//         leading?.key != old.leading?.key ||
//         snapDuration != old.snapDuration ||
//         snapCurve != old.snapCurve ||
//         largeTitleGapExpanded != old.largeTitleGapExpanded ||
//         largeTitleGapCollapsed != old.largeTitleGapCollapsed ||
//         largeTitleTopPaddingExpanded != old.largeTitleTopPaddingExpanded ||
//         largeTitleTopPaddingCollapsed != old.largeTitleTopPaddingCollapsed;
//   }
// }

// // ignore: unused_element
// class _DefaultBackButton extends StatelessWidget {
//   const _DefaultBackButton({required this.onPressed});
//   final VoidCallback? onPressed;

//   @override
//   Widget build(BuildContext context) {
//     final color = IconTheme.of(context).color;
//     return IconButton(
//       onPressed: onPressed,
//       tooltip: 'Back',
//       icon: DecoratedBox(
//         decoration: BoxDecoration(
//           color: color?.withOpacity(0.08),
//           shape: BoxShape.circle,
//         ),
//         child: const Padding(
//           padding: EdgeInsets.all(6),
//           child: Icon(Icons.arrow_back_rounded),
//         ),
//       ),
//     );
//   }
// }

// lib/presentation/widgets/collapsing_header.dart
import 'dart:math' as math;
import 'dart:ui' as ui; // for lerpDouble
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hostel_mgmt/presentation/widgets/liquid_glass_morphism/liquid_back_button.dart';

class OneUiCollapsingHeader extends StatelessWidget {
  const OneUiCollapsingHeader({
    super.key,
    required this.title,
    required this.vsync, // required for snap on floating headers
    this.onBack,
    this.leading,
    this.actions,
    this.backgroundColor,
    this.foregroundColor,
    this.expandedHeight = 160,
    this.toolbarHeight = kToolbarHeight,
    this.largeTitleTextStyle,
    this.smallTitleTextStyle,

    // Base padding knobs (constant margins)
    this.largeTitlePadding = const EdgeInsets.fromLTRB(50, 0, 16, 20),
    this.smallTitlePadding = const EdgeInsets.symmetric(horizontal: 8),

    // Fixed leading area width and padding
    this.leadingWidth,
    this.leadingPaddingLeft = 0, // NEW: fixed left padding for back button
    this.actionsPadding,

    this.showBottomDividerWhenCollapsed = true,
    this.snapDuration = const Duration(milliseconds: 220),
    this.snapCurve = Curves.easeOutCubic,

    // Precise control of large title position relative to the back button
    this.largeTitleGapExpanded =
        12, // gap between back button and large title (expanded)
    this.largeTitleGapCollapsed = 4, // gap near collapsed
    this.largeTitleTopPaddingExpanded = 2, // extra top padding (expanded)
    this.largeTitleTopPaddingCollapsed =
        0, // extra top padding (near collapsed)
    // NEW: control back button radius shrink
    this.leadingRadiusExpanded = 35,
    this.leadingRadiusCollapsed = 20,
  });

  final String title;
  final TickerProvider vsync;

  final VoidCallback? onBack;
  final Widget? leading;
  final List<Widget>? actions;

  final Color? backgroundColor;
  final Color? foregroundColor;
  final double expandedHeight;
  final double toolbarHeight;

  final TextStyle? largeTitleTextStyle;
  final TextStyle? smallTitleTextStyle;

  final EdgeInsetsGeometry largeTitlePadding;
  final EdgeInsetsGeometry smallTitlePadding;

  final double? leadingWidth;
  final double leadingPaddingLeft; // NEW
  final EdgeInsetsGeometry? actionsPadding;

  final bool showBottomDividerWhenCollapsed;
  final Duration snapDuration;
  final Curve snapCurve;

  // Position controls
  final double largeTitleGapExpanded;
  final double largeTitleGapCollapsed;
  final double largeTitleTopPaddingExpanded;
  final double largeTitleTopPaddingCollapsed;

  // NEW: radius controls for leading back button
  final double leadingRadiusExpanded;
  final double leadingRadiusCollapsed;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.viewPaddingOf(context).top;
    final scheme = Theme.of(context).colorScheme;

    final TextStyle defaultLarge =
        Theme.of(context).textTheme.headlineMedium?.copyWith(
          color: scheme.onSurface,
          fontWeight: FontWeight.w700,
        ) ??
        TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: scheme.onSurface,
        );

    final TextStyle defaultSmall =
        Theme.of(context).textTheme.titleMedium?.copyWith(
          color: scheme.onSurface,
          fontWeight: FontWeight.w600,
        ) ??
        TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: scheme.onSurface,
        );

    return SliverPersistentHeader(
      pinned: true,
      floating: true, // keep floating to allow snap
      delegate: _OneUiHeaderDelegate(
        title: title,
        vsync: vsync,
        leading:
            leading ??
            LiquidGlassBackButton(
              onPressed: () => Navigator.of(context).pop(),
              enableGlass: false,
              radius: leadingRadiusExpanded,
            ),
        actions: actions,
        backgroundColor: backgroundColor ?? scheme.surface,
        foregroundColor: foregroundColor ?? scheme.onSurface,
        maxExtentWithoutSafeArea: expandedHeight,
        minToolbarHeight: toolbarHeight,
        safeAreaTop: top,
        largeTitleTextStyle: largeTitleTextStyle ?? defaultLarge,
        smallTitleTextStyle: smallTitleTextStyle ?? defaultSmall,
        largeTitlePadding: largeTitlePadding,
        smallTitlePadding: smallTitlePadding,
        leadingWidth: leadingWidth ?? kToolbarHeight,
        leadingPaddingLeft: leadingPaddingLeft, // NEW
        actionsPadding: actionsPadding ?? const EdgeInsets.only(right: 4),
        showBottomDividerWhenCollapsed: showBottomDividerWhenCollapsed,
        snapDuration: snapDuration,
        snapCurve: snapCurve,
        largeTitleGapExpanded: largeTitleGapExpanded,
        largeTitleGapCollapsed: largeTitleGapCollapsed,
        largeTitleTopPaddingExpanded: largeTitleTopPaddingExpanded,
        largeTitleTopPaddingCollapsed: largeTitleTopPaddingCollapsed,
        // NEW
        leadingRadiusExpanded: leadingRadiusExpanded,
        leadingRadiusCollapsed: leadingRadiusCollapsed,
      ),
    );
  }
}

class _OneUiHeaderDelegate extends SliverPersistentHeaderDelegate {
  _OneUiHeaderDelegate({
    required this.title,
    required TickerProvider vsync,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.maxExtentWithoutSafeArea,
    required this.minToolbarHeight,
    required this.safeAreaTop,
    required this.largeTitleTextStyle,
    required this.smallTitleTextStyle,
    required this.largeTitlePadding,
    required this.smallTitlePadding,
    required this.leadingWidth,
    required this.leadingPaddingLeft, // NEW
    required this.actionsPadding,
    required this.showBottomDividerWhenCollapsed,
    required this.snapDuration,
    required this.snapCurve,
    required this.largeTitleGapExpanded,
    required this.largeTitleGapCollapsed,
    required this.largeTitleTopPaddingExpanded,
    required this.largeTitleTopPaddingCollapsed,
    required this.leadingRadiusExpanded, // NEW
    required this.leadingRadiusCollapsed, // NEW
    this.leading,
    this.actions,
  }) : _vsync = vsync;

  final String title;
  final TickerProvider _vsync;

  final Widget? leading;
  final List<Widget>? actions;

  final Color backgroundColor;
  final Color foregroundColor;

  final double maxExtentWithoutSafeArea;
  final double minToolbarHeight;
  final double safeAreaTop;

  final TextStyle largeTitleTextStyle;
  final TextStyle smallTitleTextStyle;

  final EdgeInsetsGeometry largeTitlePadding;
  final EdgeInsetsGeometry smallTitlePadding;

  final double leadingWidth;
  final double leadingPaddingLeft; // NEW
  final EdgeInsetsGeometry actionsPadding;

  final bool showBottomDividerWhenCollapsed;
  final Duration snapDuration;
  final Curve snapCurve;

  // Position controls
  final double largeTitleGapExpanded;
  final double largeTitleGapCollapsed;
  final double largeTitleTopPaddingExpanded;
  final double largeTitleTopPaddingCollapsed;

  // NEW: radius controls
  final double leadingRadiusExpanded;
  final double leadingRadiusCollapsed;

  // Non-overlapping cross-fade thresholds.
  static const double _largeDisappear = 0.45;
  static const double _smallAppear = 0.55;

  @override
  double get minExtent => safeAreaTop + minToolbarHeight;

  @override
  double get maxExtent =>
      math.max(minExtent, safeAreaTop + maxExtentWithoutSafeArea);

  double _t(double shrinkOffset) {
    final total = (maxExtent - minExtent).clamp(0.0, double.infinity);
    if (total == 0) return 1;
    return (shrinkOffset / total).clamp(0.0, 1.0);
  }

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final tRaw = _t(shrinkOffset);
    final t = Curves.easeOut.transform(tRaw);

    // Disjoint opacities.
    final double largeOpacity = t <= _largeDisappear
        ? 1 - (t / _largeDisappear)
        : 0;
    final double smallOpacity = t >= _smallAppear
        ? (t - _smallAppear) / (1 - _smallAppear)
        : 0;

    // Subtle translations.
    final largeTranslate = Tween<double>(begin: 0, end: -12).transform(t);
    final smallTranslate = Tween<double>(begin: 8, end: 0).transform(t);

    // Resolve paddings (unchanged)
    final EdgeInsets smallPad = smallTitlePadding.resolve(TextDirection.ltr);
    final EdgeInsets largePad = largeTitlePadding.resolve(TextDirection.ltr);

    // Animated gap (unchanged)
    final double gap = ui.lerpDouble(
      largeTitleGapExpanded,
      largeTitleGapCollapsed,
      t,
    )!;

    // Left offset for the large title (unchanged)
    final double largeLeft =
        smallPad.left + leadingPaddingLeft + leadingWidth + gap + largePad.left;

    // CHANGE: anchor large title to the SAME row top as the back button.
    final double largeTopExtra = ui.lerpDouble(
      largeTitleTopPaddingExpanded,
      largeTitleTopPaddingCollapsed,
      t,
    )!;

    // Use smallPad.top as the base so it's aligned with the toolbar/back button row.
    final double largeTop = smallPad.top + largeTopExtra;

    // NEW: compute current back-button radius and scale fallback
    final double currentRadius = ui.lerpDouble(
      leadingRadiusExpanded,
      leadingRadiusCollapsed,
      t,
    )!;
    final double fallbackScale = (leadingRadiusExpanded == 0)
        ? 1.0
        : (currentRadius / leadingRadiusExpanded);

    return Material(
      color: backgroundColor,
      elevation: 0,
      child: Container(
        padding: EdgeInsets.only(top: safeAreaTop),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Large title to the right of the back button (expanded state)
            Positioned(
              top: largeTop, // <-- now shares the toolbar row's top
              left: largeLeft,
              right: largePad.right,
              height:
                  minToolbarHeight, // <-- same height as the row that holds the back button
              child: Offstage(
                offstage: largeOpacity == 0,
                child: Opacity(
                  opacity: largeOpacity,
                  child: Transform.translate(
                    offset: Offset(0, largeTranslate),
                    child: Align(
                      alignment: Alignment
                          .centerLeft, // centers vertically like IconButton row
                      child: DefaultTextStyle(
                        style: largeTitleTextStyle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Toolbar with fixed-position back button and small title
            Padding(
              padding: smallPad,
              child: SizedBox(
                height: minToolbarHeight,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Fixed left padding for back button (applies in all states)
                    Padding(
                      padding: EdgeInsets.only(left: leadingPaddingLeft),
                      child: SizedBox(
                        width: leadingWidth,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: IconTheme(
                            data: IconThemeData(color: foregroundColor),
                            child: _buildAnimatedLeading(
                              currentRadius: currentRadius,
                              fallbackScale: fallbackScale,
                            ),
                          ),
                        ),
                      ),
                    ),

                    Expanded(
                      child: Offstage(
                        offstage: smallOpacity == 0,
                        child: Opacity(
                          opacity: smallOpacity,
                          child: Transform.translate(
                            offset: Offset(0, smallTranslate),
                            child: DefaultTextStyle(
                              style: smallTitleTextStyle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              child: Text(
                                title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: actionsPadding,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: actions ?? const [],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            if (showBottomDividerWhenCollapsed)
              Align(
                alignment: Alignment.bottomCenter,
                child: Opacity(
                  opacity: smallOpacity,
                  child: const Divider(height: 1),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Build leading with animated radius if it's a LiquidGlassBackButton,
  // otherwise apply a scale fallback so any custom leading still shrinks visually.
  Widget _buildAnimatedLeading({
    required double currentRadius,
    required double fallbackScale,
  }) {
    final w = leading;
    if (w is LiquidGlassBackButton) {
      // Rebuild with lerped radius; preserve other properties.
      return LiquidGlassBackButton(
        onPressed: w.onPressed,
        enableGlass: w.enableGlass,
        radius: currentRadius,
      );
    }
    // Fallback: scale any custom leading (keeps API flexible).
    return Transform.scale(
      scale: fallbackScale,
      alignment: Alignment.centerLeft,
      child: w ?? const SizedBox.shrink(),
    );
  }

  // Enable snapping for floating headers.
  @override
  FloatingHeaderSnapConfiguration? get snapConfiguration =>
      FloatingHeaderSnapConfiguration(duration: snapDuration, curve: snapCurve);

  // Provide vsync for the snap animation.
  @override
  TickerProvider get vsync => _vsync;

  @override
  bool shouldRebuild(covariant _OneUiHeaderDelegate old) {
    return title != old.title ||
        leadingWidth != old.leadingWidth ||
        leadingPaddingLeft != old.leadingPaddingLeft ||
        backgroundColor != old.backgroundColor ||
        foregroundColor != old.foregroundColor ||
        maxExtentWithoutSafeArea != old.maxExtentWithoutSafeArea ||
        minToolbarHeight != old.minToolbarHeight ||
        safeAreaTop != old.safeAreaTop ||
        largeTitleTextStyle != old.largeTitleTextStyle ||
        smallTitleTextStyle != old.smallTitleTextStyle ||
        largeTitlePadding != old.largeTitlePadding ||
        smallTitlePadding != old.smallTitlePadding ||
        showBottomDividerWhenCollapsed != old.showBottomDividerWhenCollapsed ||
        actionsPadding != old.actionsPadding ||
        (actions?.length ?? 0) != (old.actions?.length ?? 0) ||
        leading?.key != old.leading?.key ||
        snapDuration != old.snapDuration ||
        snapCurve != old.snapCurve ||
        largeTitleGapExpanded != old.largeTitleGapExpanded ||
        largeTitleGapCollapsed != old.largeTitleGapCollapsed ||
        largeTitleTopPaddingExpanded != old.largeTitleTopPaddingExpanded ||
        largeTitleTopPaddingCollapsed != old.largeTitleTopPaddingCollapsed ||
        leadingRadiusExpanded != old.leadingRadiusExpanded || // NEW
        leadingRadiusCollapsed != old.leadingRadiusCollapsed; // NEW
  }
}

// ignore: unused_element
class _DefaultBackButton extends StatelessWidget {
  const _DefaultBackButton({required this.onPressed});
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final color = IconTheme.of(context).color;
    return IconButton(
      onPressed: onPressed,
      tooltip: 'Back',
      icon: DecoratedBox(
        decoration: BoxDecoration(
          color: color?.withOpacity(0.08),
          shape: BoxShape.circle,
        ),
        child: const Padding(
          padding: EdgeInsets.all(6),
          child: Icon(Icons.arrow_back_rounded),
        ),
      ),
    );
  }
}
