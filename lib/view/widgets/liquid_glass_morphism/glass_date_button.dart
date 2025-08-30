import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';

class LiquidGlassCard extends StatelessWidget {
  final String text;

  const LiquidGlassCard({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GlassmorphicContainer(
        width: 300,
        height: 80,
        borderRadius: 40,
        blur: 10,
        alignment: Alignment.center,
        border: 1,
        linearGradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.15),
            Colors.white.withOpacity(0.05),
          ],
          stops: const [0.1, 1],
        ),
        borderGradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.5),
            Colors.white.withOpacity(0.5),
          ],
        ),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}
