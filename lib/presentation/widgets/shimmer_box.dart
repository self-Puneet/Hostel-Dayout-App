import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

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