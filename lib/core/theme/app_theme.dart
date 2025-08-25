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

          // minimumSize: const Size(double.infinity, 50), // 👈 Full width
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),

      // // Outlined Button Theme
      // outlinedButtonTheme: OutlinedButtonThemeData(
      //   style: OutlinedButton.styleFrom(
      //     backgroundColor: const Color(0xFFF4F7FB), // Light background
      //     foregroundColor: const Color(0xFF0B1228), // Text color
      //     side: const BorderSide(color: Colors.transparent),
      //     shape: RoundedRectangleBorder(
      //       borderRadius: BorderRadius.circular(50), // Pill-shaped
      //     ),
      //     padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      //     textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
      //   ),
      // ),

      // // text Button theme
      // textButtonTheme: TextButtonThemeData(
      //     style: TextButton.styleFrom(
      //       backgroundColor: Colors.black12, // light grey background
      //       foregroundColor: Colors.black87, // text color
      //       // padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      //       // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      //       textStyle: TextStyle(
      //         fontSize: 14,
      //         fontWeight: FontWeight.w600,
      //         // height: 1.3,
      //       ),
      //     ),
      //   ),
    );
  }
}
