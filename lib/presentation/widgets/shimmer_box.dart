import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget shimmerBox({
  double? width, // nullable, let parent bound it
  double? height, // nullable; provide a sensible default below
  double borderRadius = 8,
}) {
  return SizedBox(
    width: width, // if null, parent constraints apply
    height: height ?? 16, // ensure finite height
    child: Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.grey[400],
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    ),
  );
}
