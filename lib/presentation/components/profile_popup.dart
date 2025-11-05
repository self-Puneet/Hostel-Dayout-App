// bottom_popup.dart
import 'dart:async';
import 'package:flutter/material.dart';

Future<T?> showBottomPopup<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  EdgeInsets padding = const EdgeInsets.fromLTRB(16, 0, 16, 16),
  double initialHeight = 50, // kept for API compatibility
  double borderRadius = 30,
  Duration openDuration = const Duration(milliseconds: 150),
  Duration closeDuration = const Duration(milliseconds: 150),
  Curve curve = Curves.easeInOut,
  Color barrierColor = Colors.black54,
  double maxHeightFraction = 0.9,
  Color containerColor = Colors.white,
  BoxShadow? shadow,

  // New: independent timings (fallback to open/close if not provided)
  Duration? sizeOpenDuration,
  Duration? sizeCloseDuration,
  Duration? contentFadeInDuration,
  Duration? contentFadeOutDuration,
  Duration? barrierOpenDuration,
  Duration? barrierCloseDuration,

  // New: whether to fade content after the size grow completes
  bool fadeAfterSize = true,
}) async {
  final overlay = Overlay.of(context, rootOverlay: true);
  final completer = Completer<T?>();
  late OverlayEntry entry;
  final media = MediaQuery.of(context);
  final bottomSafe = media.viewPadding.bottom;
  final double barBottomOffset = bottomSafe + 12;
  final double horizontalPadding = 31 * media.size.width / 402;
  padding = EdgeInsets.fromLTRB(
    horizontalPadding,
    0,
    horizontalPadding,
    barBottomOffset,
  );

  entry = OverlayEntry(
    builder: (ctx) => _BottomPopupOverlay<T>(
      onComplete: (value) {
        if (!completer.isCompleted) completer.complete(value);
      },
      removeSelf: () {
        if (entry.mounted) entry.remove();
      },
      builder: builder,
      padding: padding,
      initialHeight: initialHeight,
      borderRadius: borderRadius,
      openDuration: openDuration,
      closeDuration: closeDuration,
      curve: curve,
      barrierColor: barrierColor,
      maxHeightFraction: maxHeightFraction,
      containerColor: containerColor,
      shadow:
          shadow ??
          const BoxShadow(
            color: Color(0x1F000000),
            blurRadius: 16,
            offset: Offset(0, -2),
          ),
      sizeOpenDuration: sizeOpenDuration,
      sizeCloseDuration: sizeCloseDuration,
      contentFadeInDuration: contentFadeInDuration,
      contentFadeOutDuration: contentFadeOutDuration,
      barrierOpenDuration: barrierOpenDuration,
      barrierCloseDuration: barrierCloseDuration,
      fadeAfterSize: fadeAfterSize,
    ),
  );

  overlay.insert(entry);
  return completer.future;
}

class _BottomPopupOverlay<T> extends StatefulWidget {
  const _BottomPopupOverlay({
    required this.onComplete,
    required this.removeSelf,
    required this.builder,
    required this.padding,
    required this.initialHeight,
    required this.borderRadius,
    required this.openDuration,
    required this.closeDuration,
    required this.curve,
    required this.barrierColor,
    required this.maxHeightFraction,
    required this.containerColor,
    required this.shadow,
    this.sizeOpenDuration,
    this.sizeCloseDuration,
    this.contentFadeInDuration,
    this.contentFadeOutDuration,
    this.barrierOpenDuration,
    this.barrierCloseDuration,
    this.fadeAfterSize = true,
  });

  final void Function(T? value) onComplete;
  final VoidCallback removeSelf;
  final WidgetBuilder builder;

  final EdgeInsets padding;
  final double initialHeight;
  final double borderRadius;
  final Duration openDuration; // legacy "open" knob
  final Duration closeDuration; // legacy "close" knob
  final Curve curve; // used for size animation
  final Color barrierColor;
  final double maxHeightFraction;
  final Color containerColor;
  final BoxShadow shadow;

  // Optional overrides
  final Duration? sizeOpenDuration;
  final Duration? sizeCloseDuration;
  final Duration? contentFadeInDuration;
  final Duration? contentFadeOutDuration;
  final Duration? barrierOpenDuration;
  final Duration? barrierCloseDuration;

  final bool fadeAfterSize;

  @override
  State<_BottomPopupOverlay<T>> createState() => _BottomPopupOverlayState<T>();
}

class _BottomPopupOverlayState<T> extends State<_BottomPopupOverlay<T>>
    with TickerProviderStateMixin {
  late final AnimationController _barrierCtrl;
  late final Animation<Color?> _barrierColorAnim;

  // Derived timings with sensible fallbacks
  late final Duration _sizeOpen;
  late final Duration _sizeClose;
  late final Duration _fadeIn;
  late final Duration _fadeOut;
  late final Duration _dimIn;
  late final Duration _dimOut;

  bool _expanded = false;
  bool _closing = false;
  double _contentOpacity = 0.0;

  // Arm AnimatedSize only after the first frame so the stub appears instantly.
  bool _armAnimatedSize = false;

  @override
  void initState() {
    super.initState();

    // Resolve timings
    _sizeOpen = widget.sizeOpenDuration ?? widget.openDuration;
    _sizeClose = widget.sizeCloseDuration ?? widget.closeDuration;
    _fadeIn = widget.contentFadeInDuration ?? widget.openDuration;
    _fadeOut = widget.contentFadeOutDuration ?? widget.closeDuration;
    _dimIn = widget.barrierOpenDuration ?? widget.openDuration;
    _dimOut = widget.barrierCloseDuration ?? widget.closeDuration;

    // Barrier controller uses the barrier timings
    _barrierCtrl = AnimationController(
      vsync: this,
      duration: _dimIn,
      reverseDuration: _dimOut,
    );
    _barrierColorAnim = ColorTween(
      begin: Colors.transparent,
      end: widget.barrierColor,
    ).animate(CurvedAnimation(parent: _barrierCtrl, curve: Curves.easeOut));

    // Frame 1: insert AnimatedSize but keep collapsed so it can measure base size.
    // Next frame: grow height + dim backdrop, then fade content either immediately
    // or after size animation completes (configurable).
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      setState(() => _armAnimatedSize = true);

      // Ensure AnimatedSize sees the collapsed size as its "old" size.
      await WidgetsBinding.instance.endOfFrame;

      if (!mounted) return;

      _barrierCtrl.forward();
      setState(() {
        _expanded = true; // triggers AnimatedSize grow with _sizeOpen
        if (!widget.fadeAfterSize) {
          _contentOpacity = 1.0; // parallel fade if not staging
        }
      });
    });
  }

  Future<void> _close([T? value]) async {
    if (_closing) return;
    _closing = true; // set early so widgets use close durations
    setState(() {
      _contentOpacity = 0.0; // fade out content
      _expanded = false; // shrink height via AnimatedSize reverse
    });

    // Start dim-out immediately
    _barrierCtrl.reverse();

    // Wait long enough for all effects to finish before removing
    final Duration maxWait = [
      _dimOut,
      _sizeClose,
      _fadeOut,
    ].reduce((a, b) => a > b ? a : b);
    await Future.delayed(maxWait);

    widget.onComplete(value);
    widget.removeSelf();
  }

  @override
  void dispose() {
    _barrierCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final maxH = media.size.height * widget.maxHeightFraction;

    final popupCore = _PopupChrome(
      radius: widget.borderRadius,
      color: widget.containerColor,
      shadow: widget.shadow,
      child: IgnorePointer(
        ignoring: !_expanded,
        child: AnimatedOpacity(
          opacity: _contentOpacity,
          // Independent content fade timings
          duration: _closing ? _fadeOut : _fadeIn,
          curve: Curves.easeOut,
          child: _ContentWrapper(
            maxHeight: maxH,
            builder: widget.builder,
            onClose: _close,
          ),
        ),
      ),
    );

    // Compute dynamic collapsed height from available width using aspect ratio 340:65.
    double _collapsedHeightForWidth(double w) => w / (340 / 65);

    Widget sized;
    if (!_armAnimatedSize) {
      // First frame: dynamic-height stub via aspect ratio, no animation.
      sized = LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          final h = _collapsedHeightForWidth(w);
          return ConstrainedBox(
            constraints: BoxConstraints.tightFor(height: h),
            child: popupCore,
          );
        },
      );
    } else {
      // Animate height only; anchor at bottom so it grows/shrinks upward.
      sized = AnimatedSize(
        duration: _sizeOpen,
        reverseDuration: _sizeClose,
        curve: widget.curve,
        alignment: Alignment.bottomCenter, // anchor bottom for both directions
        clipBehavior: Clip.none, // preserve rounded corners
        onEnd: () {
          // If we staged the fade, reveal content after grow completes.
          if (mounted &&
              !_closing &&
              widget.fadeAfterSize &&
              _expanded &&
              _contentOpacity == 0.0) {
            setState(() => _contentOpacity = 1.0);
          }
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            final w = constraints.maxWidth;
            final h = _collapsedHeightForWidth(w);
            return ConstrainedBox(
              constraints: _expanded
                  ? BoxConstraints(maxHeight: maxH)
                  : BoxConstraints.tightFor(height: h),
              child: popupCore,
            );
          },
        ),
      );
    }

    return Stack(
      children: [
        // Animated, dismissible dimmed backdrop.
        AnimatedModalBarrier(
          color: _barrierColorAnim,
          dismissible: true,
          onDismiss: () => _close(),
        ),

        // Bottom-aligned popup with external padding.
        Positioned(
          left: widget.padding.left,
          right: widget.padding.right,
          bottom: widget.padding.bottom,
          child: sized,
        ),
      ],
    );
  }
}

class _PopupChrome extends StatelessWidget {
  const _PopupChrome({
    required this.radius,
    required this.color,
    required this.shadow,
    required this.child,
  });

  final double radius;
  final Color color;
  final BoxShadow shadow;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // Outer shadow that is not clipped, inner Material that clips to radius.
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [shadow],
      ),
      child: Material(
        color: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
        ),
        clipBehavior: Clip.antiAlias, // ensure child respects rounded corners
        child: child,
      ),
    );
  }
}

class _ContentWrapper extends StatelessWidget {
  const _ContentWrapper({
    required this.maxHeight,
    required this.builder,
    required this.onClose,
  });

  final double maxHeight;
  final WidgetBuilder builder;
  final Future<void> Function() onClose;

  @override
  Widget build(BuildContext context) {
    // Make overly-tall content scrollable, while parent animates to natural size.
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: Material(
        type: MaterialType.transparency,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: builder(context),
        ),
      ),
    );
  }
}
