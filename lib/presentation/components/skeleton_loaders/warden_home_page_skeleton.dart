import 'package:flutter/material.dart';
import 'package:hostel_mgmt/presentation/widgets/shimmer_box.dart';
import 'package:hostel_mgmt/presentation/widgets/skeleton_circle.dart';

// Assume simpleRequestCardSkeleton() is already defined (from previous code)

Widget wardenHomePageSkeelton() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        height: 225,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20, right: 10, top: 20),
              child: shimmerBox(width: 80, height: 25, borderRadius: 16),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 10, top: 0),
              child: shimmerBox(width: 200, height: 30, borderRadius: 10),
            ),
            Row(
              children: [
                Expanded(
                  child: shimmerBox(
                    width: double.infinity,
                    height: 90,
                    borderRadius: 32,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: shimmerBox(
                    width: double.infinity,
                    height: 90,
                    borderRadius: 32,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      const SizedBox(height: 20),
      const Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 11),
        child: Divider(color: Color.fromRGBO(117, 117, 117, 1)),
      ),
      const SizedBox(height: 20),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 8,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        shimmerCircle(size: 20),
                        shimmerBox(height: 30, width: 40, borderRadius: 5),
                        shimmerBox(height: 16, width: 100, borderRadius: 12),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 8,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        shimmerCircle(size: 20),
                        shimmerBox(height: 30, width: 40, borderRadius: 5),
                        shimmerBox(height: 16, width: 100, borderRadius: 12),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 8,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        shimmerCircle(size: 20),
                        shimmerBox(height: 30, width: 40, borderRadius: 5),
                        shimmerBox(height: 16, width: 100, borderRadius: 12),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 8,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        shimmerCircle(size: 20),
                        shimmerBox(height: 30, width: 40, borderRadius: 5),
                        shimmerBox(height: 16, width: 100, borderRadius: 12),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}
