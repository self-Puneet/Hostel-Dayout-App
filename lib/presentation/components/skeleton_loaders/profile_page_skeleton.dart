import 'package:flutter/material.dart';
import 'package:hostel_mgmt/presentation/widgets/shimmer_box.dart';
// import 'package:hostel_mgmt/presentation/components/skeleton_loaders/simple_request_card_skeleton.dart';
import 'package:shimmer/shimmer.dart';

Widget profileTopSkeleton() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      // SizedBox(height: 12),
      // Profile photo with camera icon shimmer
      Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          width: 95,
          height: 95,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey[400],
          ),
        ),
      ),
      SizedBox(height: 16),

      // Name
      shimmerBox(width: 130, height: 22, borderRadius: 10),
      SizedBox(height: 4),
      shimmerBox(width: 185, height: 17, borderRadius: 10),
      SizedBox(height: 16),
    ],
  );
}
