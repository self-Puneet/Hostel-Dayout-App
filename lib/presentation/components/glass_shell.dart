// presentation/widgets/liquid_glass_morphism/glass_shell.dart
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

class GlassShell extends StatelessWidget {
  final Widget child;
  final BorderRadius borderRadius;
  final double aspectRatio;

  const GlassShell({
    super.key,
    required this.child,
    this.borderRadius = const BorderRadius.all(Radius.circular(40)),
    this.aspectRatio = 340 / 65,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: aspectRatio,
      child: CustomPaint(
        painter: _OuterShadowPainter(borderRadius),
        child: ClipRRect(
          borderRadius: borderRadius,
          child: Stack(
            fit: StackFit.expand,
            children: [
              LiquidGlass(
                shape: LiquidRoundedSuperellipse(borderRadius: borderRadius.topLeft),
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
                child: const SizedBox.expand(),
              ),
              child,
            ],
          ),
        ),
      ),
    );
  }
}

class _OuterShadowPainter extends CustomPainter {
  final BorderRadius borderRadius;
  _OuterShadowPainter(this.borderRadius);

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = borderRadius.toRRect(Offset.zero & size);
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 20);
    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
