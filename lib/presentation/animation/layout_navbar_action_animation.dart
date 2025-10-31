import 'package:flutter/cupertino.dart';

class SequencedBarSwitcher extends StatefulWidget {
  final bool showBulk; // true => show BulkActionsBar, false => show NavBar
  final WidgetBuilder buildNavBar;
  final WidgetBuilder buildBulkBar;
  final Duration slideDuration;
  final Duration opacityDuration;
  final Curve inCurve; // when coming in
  final Curve outCurve; // when going out

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
  // Paint/semantics gating
  bool _navOffstage = true;
  bool _bulkOffstage = true;

  // Animation states (slide + opacity)
  bool _navVisible = false;
  bool _bulkVisible = false;

  int _opId = 0; // cancel stale sequences

  @override
  void initState() {
    super.initState();
    if (widget.showBulk) {
      _bulkOffstage = false;
      _bulkVisible = true;
      _navOffstage = true;
      _navVisible = false;
    } else {
      _navOffstage = false;
      _navVisible = true;
      _bulkOffstage = true;
      _bulkVisible = false;
    }
  }

  @override
  void didUpdateWidget(covariant SequencedBarSwitcher oldWidget) {
    super.didUpdateWidget(oldWidget);
    final wantBulk = widget.showBulk;
    final showingBulk = !_bulkOffstage && _bulkVisible;
    if (wantBulk != showingBulk) {
      _startSwitch(toBulk: wantBulk);
    }
  }

  void _startSwitch({required bool toBulk}) {
    final id = ++_opId;

    if (toBulk) {
      // Prepare target offstage; animate current (nav) out.
      setState(() {
        _bulkOffstage = true; // target not painting yet
        _bulkVisible = false; // ensure it starts from off
        _navOffstage = false; // ensure current is painting
        _navVisible = false; // animate out (down + fade)
      });

      Future.delayed(widget.slideDuration, () {
        if (!mounted || id != _opId) return;
        setState(() {
          _navOffstage = true; // stop painting nav after out completes
          _bulkOffstage = false; // now paint bulk
          _bulkVisible = true; // animate in (up + fade)
        });
      });
    } else {
      // Prepare target offstage; animate current (bulk) out.
      setState(() {
        _navOffstage = true; // target not painting yet
        _navVisible = false; // ensure it starts from off
        _bulkOffstage = false; // ensure current is painting
        _bulkVisible = false; // animate out (down + fade)
      });

      Future.delayed(widget.slideDuration, () {
        if (!mounted || id != _opId) return;
        setState(() {
          _bulkOffstage = true; // stop painting bulk after out completes
          _navOffstage = false; // now paint nav
          _navVisible = true; // animate in (up + fade)
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        _BarLayer(
          offstage: _navOffstage,
          visible: _navVisible,
          slideDuration: widget.slideDuration,
          opacityDuration: widget.opacityDuration,
          inCurve: widget.inCurve,
          outCurve: widget.outCurve,
          child: widget.buildNavBar(context),
        ),
        _BarLayer(
          offstage: _bulkOffstage,
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

class _BarLayer extends StatelessWidget {
  final Widget child;
  final bool offstage;
  final bool visible;
  final Duration slideDuration;
  final Duration opacityDuration;
  final Curve inCurve;
  final Curve outCurve;

  const _BarLayer({
    required this.child,
    required this.offstage,
    required this.visible,
    required this.slideDuration,
    required this.opacityDuration,
    required this.inCurve,
    required this.outCurve,
  });

  @override
  Widget build(BuildContext context) {
    final curve = visible ? inCurve : outCurve;
    return Offstage(
      offstage: offstage,
      child: AnimatedSlide(
        offset: visible ? Offset.zero : const Offset(0, 1),
        duration: slideDuration,
        curve: curve,
        child: AnimatedOpacity(
          opacity: visible ? 1 : 0,
          duration: opacityDuration,
          curve: curve,
          child: IgnorePointer(ignoring: offstage || !visible, child: child),
        ),
      ),
    );
  }
}
