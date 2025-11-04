import 'package:flutter/material.dart';
import 'package:hostel_mgmt/presentation/widgets/shimmer_box.dart';
import 'package:hostel_mgmt/presentation/widgets/skeleton_circle.dart';

Widget timelineSkeletonLoader() {
  return Container(
    margin: const EdgeInsets.all(0),
    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      children: [
        ...List.generate(
          4,
          (i) => _timelineStepSkeleton(isFirst: i == 0, isLast: i == 3),
        ),
      ],
    ),
  );
}

Widget _timelineStepSkeleton({bool isFirst = false, bool isLast = false}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Left column: Date/time shimmer
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            shimmerBox(width: 75, height: 17),
            SizedBox(height: 6),
            shimmerBox(width: 48, height: 13),
          ],
        ),
      ),
      SizedBox(width: 16),
      // Timeline vertical indicator and step circle
      Column(
        children: [
          if (!isFirst) shimmerBox(width: 3, height: 22, borderRadius: 2),
          shimmerCircle(size: 28),
          if (!isLast) shimmerBox(width: 3, height: 22, borderRadius: 2),
        ],
      ),
      SizedBox(width: 16),
      // Right column: Step title & description shimmer
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            shimmerBox(width: 90, height: 16),
            SizedBox(height: 7),
            shimmerBox(width: 110, height: 13),
          ],
        ),
      ),
    ],
  );
}
