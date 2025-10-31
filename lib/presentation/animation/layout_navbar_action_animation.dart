import 'package:flutter/cupertino.dart';

class SequencedBarSwitcher extends StatefulWidget {
  final bool showBulk; // true => BulkActionsBar, false => NavBar
  final WidgetBuilder buildNavBar;
  final WidgetBuilder buildBulkBar;
  final Duration slideDuration;
  final Duration opacityDuration;
  final Curve inCurve;   // when coming in
  final Curve outCurve;  // when going out

  const SequencedBarSwitcher({
    super.key,
    required this.showBulk,
    required this.buildNavBar,
    required this.buildBulkBar,
    this.slideDuration = const Duration(milliseconds: 180),
    this.opacityDuration = const Duration(milliseconds: 120),
    this.inCurve = Curves.easeOut,
    this.outCurve = Curves.easeIn,
  });

  @override
  State<SequencedBarSwitcher> createState() => _SequencedBarSwitcherState();
}

class _SequencedBarSwitcherState extends State<SequencedBarSwitcher> {
  bool _navMounted = false;
  bool _bulkMounted = false;
  bool _navVisible = false;
  bool _bulkVisible = false;
  int _opId = 0; // cancels stale transitions on rapid toggles

  @override
  void initState() {
    super.initState();
    if (widget.showBulk) {
      _bulkMounted = true;
      _bulkVisible = true;
    } else {
      _navMounted = true;
      _navVisible = true;
    }
  }

  @override
  void didUpdateWidget(covariant SequencedBarSwitcher oldWidget) {
    super.didUpdateWidget(oldWidget);
    final wantBulk = widget.showBulk;
    final showingBulk = _bulkVisible && _bulkMounted;

    if (wantBulk != showingBulk) {
      _startSwitch(toBulk: wantBulk);
    }
  }

  void _startSwitch({required bool toBulk}) {
    final id = ++_opId;

    setState(() {
      if (toBulk) {
        _bulkMounted = true;   // ensure target is mounted
        _navVisible = false;   // slide out nav
      } else {
        _navMounted = true;    // ensure target is mounted
        _bulkVisible = false;  // slide out bulk
      }
    });

    Future.delayed(widget.slideDuration, () {
      if (!mounted || id != _opId) return;
      setState(() {
        if (toBulk) {
          _navMounted = false;   // unmount nav once out
          _bulkVisible = true;   // slide in bulk
        } else {
          _bulkMounted = false;  // unmount bulk once out
          _navVisible = true;    // slide in nav
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        if (_navMounted)
          _BarAnimator(
            visible: _navVisible,
            slideDuration: widget.slideDuration,
            opacityDuration: widget.opacityDuration,
            inCurve: widget.inCurve,
            outCurve: widget.outCurve,
            child: widget.buildNavBar(context),
          ),
        if (_bulkMounted)
          _BarAnimator(
            visible: _bulkVisible,
            slideDuration: widget.slideDuration,
            opacityDuration: widget.opacityDuration,
            inCurve: widget.inCurve,
            outCurve: widget.outCurve,
            child: widget.buildBulkBar(context),
          ),
      ],
    );
  }
}

class _BarAnimator extends StatelessWidget {
  final Widget child;
  final bool visible;
  final Duration slideDuration;
  final Duration opacityDuration;
  final Curve inCurve;
  final Curve outCurve;

  const _BarAnimator({
    required this.child,
    required this.visible,
    required this.slideDuration,
    required this.opacityDuration,
    required this.inCurve,
    required this.outCurve,
  });

  @override
  Widget build(BuildContext context) {
    final curve = visible ? inCurve : outCurve;
    return AnimatedSlide(
      offset: visible ? Offset.zero : const Offset(0, 1),
      duration: slideDuration,
      curve: curve,
      child: AnimatedOpacity(
        opacity: visible ? 1 : 0,
        duration: opacityDuration,
        curve: curve,
        child: IgnorePointer(
          ignoring: !visible,
          child: child,
        ),
      ),
    );
  }
}
