import 'package:flutter/material.dart';
import 'package:hostel_mgmt/presentation/widgets/shimmer_box.dart';

Widget requestDetailSkeletonLoader() {
  return Column(
    children: [
      IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 2,
              child: shimmerBox(width: 200, height: 150, borderRadius: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  shimmerBox(width: 300, height: 75, borderRadius: 12),
                  SizedBox(height: 12),
                  shimmerBox(width: 300, height: 75, borderRadius: 12),
                ],
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 15),

      Container(
        decoration: BoxDecoration(
          color: Color.fromRGBO(246, 246, 246, 1),
          borderRadius: BorderRadius.circular(20),
        ),
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 6),
              child: shimmerBox(width: 50, height: 25),
            ),
            SizedBox(height: 8),
            shimmerBox(width: double.infinity, height: 40),

            SizedBox(height: 10),
            Divider(height: 0.5, color: Colors.grey[400]),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 6),
              child: shimmerBox(width: 50, height: 25),
            ),
            SizedBox(height: 8),
            shimmerBox(width: double.infinity, height: 40),
          ],
        ),
      ),
    ],
  );
}
