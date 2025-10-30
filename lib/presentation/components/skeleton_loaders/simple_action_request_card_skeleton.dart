import 'package:flutter/material.dart';
import 'package:hostel_mgmt/presentation/widgets/shimmer_box.dart';
import 'package:hostel_mgmt/presentation/widgets/skeleton_circle.dart';

Widget simpleActionRequestCardSkeleton() {
  return Container(
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Color.fromRGBO(246, 246, 246, 1),
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            shimmerCircle(size: 40),
            const SizedBox(width: 12),
            Column(
              children: [
                shimmerBox(width: 80, height: 15),
                const SizedBox(height: 8),
                shimmerBox(width: 80, height: 15),
              ],
            ),
            Expanded(child: Container()),
            shimmerBox(width: 80, height: 30, borderRadius: 99),
          ],
        ),
        const SizedBox(height: 18),
        shimmerBox(width: 200, height: 20),
        const SizedBox(height: 12),
        shimmerBox(width: 200, height: 20),
        const SizedBox(height: 10),
        shimmerBox(width: 200, height: 20),
      ],
    ),
  );
}
