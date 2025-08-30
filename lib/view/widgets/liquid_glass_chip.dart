import 'dart:math';
import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

class LiquidGlassChip extends StatelessWidget {
  final String label;
  final double width;
  final double height;
  final BorderRadius borderRadius;

  const LiquidGlassChip({
    super.key,
    required this.label,
    this.width = 100,
    this.height = 33,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        border: Border.all(color: const Color(0xFFC1C1C1), width: 1),
      ),
      child: LiquidGlass(
        shape: LiquidRoundedSuperellipse(
          borderRadius: borderRadius.topLeft, // matches your radius
        ),
        settings: const LiquidGlassSettings(
          thickness: 8,
          blur: 6,
          chromaticAberration: 0.01,
          lightAngle: pi / 4,
          lightIntensity: 0.5,
          refractiveIndex: 1.4,
          saturation: 1,
          lightness: 1,
        ),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.transparent,
                Colors.black.withAlpha((0.1 * 225).toInt()),
              ],
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
