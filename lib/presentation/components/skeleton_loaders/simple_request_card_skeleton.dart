import 'package:flutter/material.dart';
import 'package:hostel_mgmt/presentation/widgets/shimmer_box.dart';

Widget simpleRequestCardSkeleton() {
  return Container(
    margin: EdgeInsets.all(0),
    padding: EdgeInsets.all(0),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      // border: Border.all(color: Colors.black12),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left Section: Title & Time
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            shimmerBox(width: 80, height: 20),
            SizedBox(height: 8),
            shimmerBox(width: 140, height: 14),
          ],
        ),
        // Right Section: Status Badge & Date
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            shimmerBox(width: 70, height: 20, borderRadius: 16),
            SizedBox(height: 6),
            shimmerBox(width: 50, height: 14),
          ],
        ),
      ],
    ),
  );
}