import 'package:flutter/material.dart';
import 'package:hostel_mgmt/presentation/components/skeleton_loaders/simple_request_card_skeleton.dart';

// Assume simpleRequestCardSkeleton() is already defined (from previous code)

Widget monthGroupCardSkeleton() {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(28),
      boxShadow: const [
        BoxShadow(
          color: Color(0x66000000),
          blurRadius: 2,
          spreadRadius: 0.4,
          offset: Offset(0, 0),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Month Heading
        Padding(
          padding: const EdgeInsets.fromLTRB(30, 20, 20, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              shimmerBox(width: 60, height: 20, borderRadius: 10),

              SizedBox(height: 8),
              shimmerBox(width: 180, height: 24, borderRadius: 10),
            ],
          ),
        ),
        SizedBox(height: 10),

        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Divider(color: Colors.grey[400], thickness: 1),
        ),
        // Repeat skeleton cards

        // Month Heading
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...List.generate(
                3,
                (i) => Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: simpleRequestCardSkeleton(),
                    ),
                    if (i < 2)
                      Divider(color: Color(0x1A000000)), // mimic separation
                  ],
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ],
    ),
  );
}
