import 'package:flutter/material.dart';
import 'package:hostel_mgmt/presentation/widgets/shimmer_box.dart';
import 'package:hostel_mgmt/presentation/widgets/skeleton_circle.dart';

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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                shimmerBox(width: 120, height: 15),
                SizedBox(height: 5),
                shimmerBox(width: 120, height: 15),
              ],
            ),
            shimmerBox(width: 80, height: 32, borderRadius: 20),
          ],
        ),
        SizedBox(height: 12),
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
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 20, left: 20, top: 15),
              child: shimmerBox(width: double.infinity, height: 4),
            ),
            Center(
              child: Row(
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
            ),
          ],
        ),
      ],
    ),
  );
}