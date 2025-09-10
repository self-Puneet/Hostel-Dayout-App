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
    return SizedBox(
      width: width, // constrain chip size from parent
      height: height,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Glass background with only a Container child
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                border: Border.all(color: const Color(0xFFC1C1C1), width: 1),
              ),
              child: LiquidGlass(
                shape: LiquidRoundedSuperellipse(
                  borderRadius: borderRadius.topLeft,
                ),
                settings: const LiquidGlassSettings(
                  thickness: 8,
                  blur: 6,
                  chromaticAberration: 0.01,
                  lightAngle: pi * 5 / 18,
                  lightIntensity: 0,
                  refractiveIndex: 1.4,
                  saturation: 1,
                  lightness: 1,
                ),
                child: Container(
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
                ),
              ),
            ),
          ),

          // Text OVER the glass (not inside LiquidGlass child)
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
