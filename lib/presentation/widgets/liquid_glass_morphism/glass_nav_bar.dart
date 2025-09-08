import 'package:flutter/material.dart';
import 'dart:math';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

class LiquidGlassNavBar extends StatelessWidget {
  // void callback for home button, new button and profile button
  final VoidCallback onHomePressed;
  final VoidCallback onNewPressed;
  final VoidCallback onProfilePressed;

  const LiquidGlassNavBar({
    super.key,
    required this.onHomePressed,
    required this.onNewPressed,
    required this.onProfilePressed,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(40);

    return AspectRatio(
      aspectRatio: 340 / 65, // ✅ maintain ratio
      child: CustomPaint(
        painter: _OuterShadowPainter(borderRadius),
        child: ClipRRect(
          borderRadius: borderRadius,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Glass background
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
                  decoration: BoxDecoration(borderRadius: borderRadius),
                ),
              ),

              // Foreground content
              Row(
                children: [
                  Expanded(
                    flex: 97,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: IconButton(
                        icon: Image.asset(
                          'assets/home.png',
                          width: 34,
                          height: 34,
                        ),
                        onPressed: onHomePressed,
                      ),
                    ),
                  ),

                  // Middle NEW button → takes 1/3
                  Expanded(
                    flex: 143,
                    child: Center(
                      child: InkWell(
                        onTap: onNewPressed,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          // take as much height as it can
                          constraints: const BoxConstraints(minHeight: 80),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.add, color: Colors.white, size: 24.3),
                              SizedBox(width: 6),
                              Text(
                                "NEW",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600, // SemiBold
                                  fontStyle: FontStyle
                                      .normal, // SemiBold is weight, not style
                                  fontSize: 20,
                                  height: 1.0, // line-height: 100%
                                  letterSpacing: 0.0, // letter-spacing: 0%
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Profile button → takes 1/3
                  Expanded(
                    flex: 97,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: IconButton(
                        icon: Image.asset(
                          'assets/user.png',
                          width: 34,
                          height: 34,
                        ),
                        onPressed: onProfilePressed,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
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
          .withAlpha((0.2 * 255).toInt()) // shadow color
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 20); // only outside

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
