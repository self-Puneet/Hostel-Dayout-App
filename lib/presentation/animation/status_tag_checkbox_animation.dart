import 'package:flutter/material.dart';

class StatusWithCheck extends StatefulWidget {
  const StatusWithCheck({
    super.key,
    required this.tag,
    required this.selected,
    required this.selectedColor,
    this.hasSelection = false,
    this.iconSize = 20,
    this.gap = 8,
    this.duration = const Duration(milliseconds: 300),
  });

  final Widget tag;
  final bool selected;
  final bool hasSelection; // NEW
  final Color selectedColor;
  final double iconSize;
  final double gap;
  final Duration duration;

  @override
  State<StatusWithCheck> createState() => _StatusWithCheckState();
}

class _StatusWithCheckState extends State<StatusWithCheck>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _space; // 0..1
  late final Animation<double> _fade; // 0..1

  bool get _active => widget.selected || widget.hasSelection;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: widget.duration);

    // Forward: reserve space first (0.0→0.6), then fade in (0.6→1.0).
    // Reverse: fade out first (1.0→0.6), then collapse space (0.6→0.0).
    _space = CurvedAnimation(
      parent: _c,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      reverseCurve: const Interval(0.0, 0.6, curve: Curves.easeIn),
    );

    _fade = CurvedAnimation(
      parent: _c,
      curve: const Interval(0.6, 1.0, curve: Curves.easeIn),
      reverseCurve: const Interval(0.6, 1.0, curve: Curves.easeOut),
    );

    if (_active) _c.value = 1.0;
  }

  @override
  void didUpdateWidget(covariant StatusWithCheck old) {
    super.didUpdateWidget(old);
    final wasActive = old.selected || old.hasSelection;
    final nowActive = _active;
    if (wasActive != nowActive) {
      nowActive ? _c.forward() : _c.reverse();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Choose icon: checked when selected, empty circle when only hasSelection.
    final IconData iconData = widget.selected
        ? Icons.check_circle
        : Icons.radio_button_unchecked;

    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        final p = _space.value; // 0..1
        final gapW = widget.gap * p;
        final iconW = widget.iconSize * p;

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            widget.tag,
            SizedBox(width: gapW),
            // Grow the icon allocation with space animation; opacity is separate.
            SizedBox(
              width: iconW,
              height: widget.iconSize,
              child: FadeTransition(
                opacity: _fade,
                child: ClipRect(
                  child: Align(
                    alignment: Alignment.centerRight,
                    widthFactor: 1.0,
                    child: Icon(
                      iconData,
                      size: widget.iconSize,
                      color: widget.selectedColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
