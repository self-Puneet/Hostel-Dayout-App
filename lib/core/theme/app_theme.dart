import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      // inputDecorationTheme: InputDecorationTheme(
      //   border: OutlineInputBorder(
      //     borderRadius: BorderRadius.circular(8),
      //     borderSide: const BorderSide(color: Color(0xFF0B1228), width: 1.2),
      //   ),
      //   enabledBorder: OutlineInputBorder(
      //     borderRadius: BorderRadius.circular(8),
      //     borderSide: const BorderSide(color: Color(0xFF0B1228), width: 1.2),
      //   ),
      //   focusedBorder: OutlineInputBorder(
      //     borderRadius: BorderRadius.circular(8),
      //     borderSide: const BorderSide(color: Color(0xFF0B1228), width: 2),
      //   ),
      //   errorBorder: OutlineInputBorder(
      //     borderRadius: BorderRadius.circular(8),
      //     borderSide: const BorderSide(color: Colors.red, width: 1.2),
      //   ),
      //   focusedErrorBorder: OutlineInputBorder(
      //     borderRadius: BorderRadius.circular(8),
      //     borderSide: const BorderSide(color: Colors.red, width: 2),
      //   ),
      //   fillColor: const Color(0xFFF4F7FB),
      //   filled: true,
      //   contentPadding: const EdgeInsets.symmetric(
      //     vertical: 10,
      //     horizontal: 14,
      //   ),
      //   hintStyle: const TextStyle(color: Colors.black38, fontSize: 14),
      //   labelStyle: const TextStyle(
      //     color: Color(0xFF0B1228),
      //     fontWeight: FontWeight.w200,
      //   ),
      // ),
      // textTheme: TextTheme(
        // Override bodyLarge to match h2 semibold style
      //   bodyLarge: TextStyle(
      //     fontSize: 24,
      //     fontWeight: FontWeight.w600,
      //     height: 1.3,
      //     color: Colors.black87,
      //   ),
      // ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0B1228), // Dark navy background
          foregroundColor: Colors.white, // Text color
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)), // Slight round
          ),
          // minimumSize: const Size(,50), // 👈 Full width

          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ),

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

      // text Button theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          backgroundColor: Colors.black12, // light grey background
          foregroundColor: Colors.black87, // text color
          // padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            // height: 1.3,
          ),
        ),
      ),
    );
  }
}
