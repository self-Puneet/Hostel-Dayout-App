import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget activeRequestCardSkeleton() {
  return Container(
    margin: EdgeInsets.symmetric(vertical: 24),
    padding: EdgeInsets.all(20),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(28),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withAlpha((0.25 * 225).toInt()),
          offset: const Offset(0, 0),
          blurRadius: 14,
          spreadRadius: 2,
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Status bar & heading
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            shimmerBox(width: 120, height: 18),
            shimmerBox(width: 70, height: 32),
          ],
        ),
        SizedBox(height: 16),
        Divider(color: Colors.grey.shade300, thickness: 1),
        SizedBox(height: 12),
        shimmerBox(width: 140, height: 18), // Reason text
        SizedBox(height: 18),
        Row(
          children: [
            // Box in place of calendar icon
            shimmerBox(width: 18, height: 18, borderRadius: 4),
            SizedBox(width: 12),
            shimmerBox(width: 70, height: 16),
            SizedBox(width: 12),
            shimmerBox(width: 40, height: 16),
            SizedBox(width: 12),
            shimmerBox(width: 70, height: 16),
          ],
        ),
        SizedBox(height: 28),
        // Progress dots and labels
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            4,
            (index) => Column(
              children: [
                shimmerCircle(size: 32),
                SizedBox(height: 8),
                shimmerBox(width: 48, height: 10),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

// Helper widget to wrap individual box in shimmer
Widget shimmerBox({
  required double width,
  required double height,
  double borderRadius = 8,
}) {
  return Shimmer.fromColors(
    baseColor: Colors.grey.shade300,
    highlightColor: Colors.grey.shade100,
    child: Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[400],
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    ),
  );
}

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
