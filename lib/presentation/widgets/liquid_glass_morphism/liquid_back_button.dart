import 'dart:math';
import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

class LiquidGlassBackButton extends StatelessWidget {
  final VoidCallback? onPressed; // ✅ make it nullable
  final double radius;

  const LiquidGlassBackButton({ // ✅ can now be const
    super.key,
    this.onPressed,
    this.radius = 50,
  });

  @override
  Widget build(BuildContext context) {
    final size = radius * 2;

    return GestureDetector(
      onTap: onPressed, // ✅ null is safe now
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFC1C1C1), width: 1),
        ),
        child: ClipOval(
          child: LiquidGlass(
            shape: LiquidRoundedSuperellipse(
              borderRadius: Radius.circular(radius),
            ),
            settings: const LiquidGlassSettings( // ✅ const is fine here
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
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withAlpha((0.1 * 255).toInt()),
                  ],
                ),
              ),
              child: const Icon(
                Icons.arrow_back,
                size: 32,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
