import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0B1228), // Dark navy background
          foregroundColor: Colors.white, // Text color
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)), // Slight round
          ),
          minimumSize: const Size(double.infinity, 50), // 👈 Full width

          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),
      // elevatedButtonTheme: ElevatedButtonThemeData(
      //   style: ButtonStyle(
      //     minimumSize: WidgetStatePropertyAll<Size>(const Size.fromHeight(50)),
      //     maximumSize: WidgetStatePropertyAll<Size>(
      //       const Size(double.infinity, double.infinity),
      //     ),
      //     shape: WidgetStatePropertyAll<OutlinedBorder>(
      //       RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      //     ),
      //     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      //     alignment: Alignment.center,
      //     // Set solid background color to #F13B09
      //     backgroundColor: WidgetStatePropertyAll(Color(0xFFF13B09)),
      //     foregroundColor: WidgetStatePropertyAll(Colors.white),
      //     elevation: WidgetStatePropertyAll(0),
      //     splashFactory: NoSplash.splashFactory,
      //     overlayColor: WidgetStatePropertyAll(Colors.transparent),
      //     shadowColor: WidgetStatePropertyAll(Colors.transparent),
      //     surfaceTintColor: WidgetStatePropertyAll(Colors.transparent),
      //     animationDuration: Duration.zero,
      //     textStyle: WidgetStatePropertyAll(
      //       TextStyle(
      //         fontFamily: 'Inter',
      //         fontWeight: FontWeight.w500, // Medium
      //         fontSize: 14,
      //         color: Colors.white,
      //       ),
      //     ),
      //   ),
      // ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          backgroundColor: const Color(0xFFF4F7FB), // Light background
          foregroundColor: const Color(0xFF0B1228), // Text color
          side: const BorderSide(color: Colors.transparent),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50), // Pill-shaped
          ),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
