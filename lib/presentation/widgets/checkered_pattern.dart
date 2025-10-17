import 'dart:math';
import 'package:flutter/material.dart';

class CheckeredContainer extends StatelessWidget {
  final Color color;
  final int columns;
  final int rows;
  final double opacityStep;
  final double tileSize;
  final Widget? child;
  final double? height;
  final BorderRadiusGeometry? borderRadius;

  const CheckeredContainer({
    Key? key,
    required this.color,
    this.columns = 8,
    this.rows = 6,
    this.opacityStep = 0.1,
    this.tileSize = 48,
    this.child,
    this.height,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Optionally use screen height or set your own preferred height
    final containerHeight = height ?? rows * tileSize;

    // Adjust tileSize and columns to fill the width perfectly if you want
    final effectiveColumns = columns;
    final effectiveTileSize = screenWidth / effectiveColumns;

    List<Widget> tiles = [];
    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < effectiveColumns; col++) {
        final t = (row + col) / (rows + effectiveColumns - 2);
        final nonlinear = pow(t, 4).toDouble();
        final opacity = (nonlinear * 1.5).clamp(0.0, 1.0);

        final backgroundColor =
            t < 0.02 ? Colors.white : color.withOpacity(opacity);

        tiles.add(
          Positioned(
            left: col * effectiveTileSize,
            top: (rows - row - 1) * effectiveTileSize,
            child: Container(
              width: effectiveTileSize,
              height: effectiveTileSize,
              color: backgroundColor,
            ),
          ),
        );
      }
    }

    return Container(
      width: screenWidth,
      height: containerHeight,
      decoration: borderRadius != null
          ? BoxDecoration(borderRadius: borderRadius)
          : null,
      clipBehavior: borderRadius != null ? Clip.antiAlias : Clip.none,
      child: Stack(
        children: [
          ...tiles,
          if (child != null) Positioned.fill(child: child!),
        ],
      ),
    );
  }
}
