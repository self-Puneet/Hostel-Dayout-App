import 'dart:math';
import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

class LiquidGlassBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final double radius;

  // New: toggle LiquidGlass on/off (defaults to true)
  final bool enableGlass;

  const LiquidGlassBackButton({
    super.key,
    this.onPressed,
    this.radius = 50,
    this.enableGlass = true,
  });

  @override
  Widget build(BuildContext context) {
    final size = radius * 2;

    return GestureDetector(
      onTap: onPressed,
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Circular frame with border
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFC1C1C1), width: 1),
              ),
              child: ClipOval(
                child: enableGlass
                    ? LiquidGlass(
                        shape: LiquidRoundedSuperellipse(
                          borderRadius: Radius.circular(radius),
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
                        // Keep sizing stable when enabled
                        child: const SizedBox.expand(),
                      )
                    // Keep sizing stable when disabled
                    : const SizedBox.expand(),
              ),
            ),

            // Foreground icon, always on top
            const Icon(Icons.arrow_back, size: 32, color: Colors.black),
          ],
        ),
      ),
    );
  }
}
