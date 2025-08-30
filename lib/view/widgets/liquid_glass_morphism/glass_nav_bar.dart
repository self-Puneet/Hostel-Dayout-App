import 'package:flutter/material.dart';
import 'dart:math';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

class LiquidGlassNavBar extends StatelessWidget {
  const LiquidGlassNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(40);

    return CustomPaint(
      painter: _OuterShadowPainter(borderRadius),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Stack(
          alignment: Alignment.center,
          children: [
            LiquidGlass(
              shape: LiquidRoundedSuperellipse(
                borderRadius: borderRadius.topLeft,
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
                width: 300,
                height: 50,
                decoration: BoxDecoration(borderRadius: borderRadius),
              ),
            ),

            /// Foreground content (NOT refracted)
            SizedBox(
              width: 300,
              // height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Left icon
                  IconButton(
                    icon: const Icon(Icons.home_outlined),
                    onPressed: () {},
                  ),

                  // Middle black "NEW" button
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.add, color: Colors.white, size: 18),
                        SizedBox(width: 6),
                        Text(
                          "NEW",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Right icon
                  IconButton(
                    icon: const Icon(Icons.person_outline),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ✅ Outer-only shadow painter
class _OuterShadowPainter extends CustomPainter {
  final BorderRadius borderRadius;

  _OuterShadowPainter(this.borderRadius);

  @override
  void paint(Canvas canvas, Size size) {
    final rrect = borderRadius.toRRect(Offset.zero & size);

    final paint = Paint()
      ..color = Colors.black
          .withOpacity(0.2) // shadow color
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 20); // only outside

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
