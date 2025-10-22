import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

// Helper widget to wrap individual circle in shimmer
Widget shimmerCircle({required double size}) {
  return Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.grey[400],
        shape: BoxShape.circle,
      ),
    ),
  );
}
