import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// define grey color as custom
const greyColor = Color(0xFF757575);

class AppTheme {
  static ThemeData get lightTheme {
    final base = ThemeData(useMaterial3: true);
    final on = base.colorScheme.onSurface;
    final textTheme = _buildTextTheme(base.textTheme, on);

    return base.copyWith(
      textTheme: textTheme,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0B1228),
          foregroundColor: Colors.white,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          textStyle: textTheme.labelLarge?.copyWith(fontSize: 14),
        ),
      ),
    );
  }

  static TextTheme _buildTextTheme(TextTheme base, Color on) {
    final t = GoogleFonts.poppinsTextTheme(base);

    return t.copyWith(
      headlineLarge: t.headlineLarge?.copyWith(
        fontSize: 30,
        height: 1,
        color: on,
        fontWeight: FontWeight.w400,
      ), // h1 w400 default
      headlineMedium: t.headlineMedium?.copyWith(
        fontSize: 24,
        height: 1,
        color: on,
        fontWeight: FontWeight.w400,
      ), // h2 w400 default
      titleLarge: t.titleLarge?.copyWith(
        fontSize: 20,
        height: 1,
        color: on,
        fontWeight: FontWeight.w400,
      ), // h3 w400 default
      titleMedium: t.titleMedium?.copyWith(
        fontSize: 18,
        height: 1,
        color: on,
        fontWeight: FontWeight.w400,
      ), // h4 w400 default
      bodyLarge: t.bodyLarge?.copyWith(
        fontSize: 14,
        height: 1,
        color: on,
        fontWeight: FontWeight.w400,
      ), // h5 w400 default
      bodySmall: t.bodySmall?.copyWith(
        fontSize: 12,
        height: 1,
        color: on,
        fontWeight: FontWeight.w400,
      ), // h6 w400 default
      labelSmall: t.labelSmall?.copyWith(
        fontSize: 10,
        height: 1,
        color: on,
        fontWeight: FontWeight.w400,
      ), // h7 w400 default
      labelLarge: t.labelLarge?.copyWith(fontSize: 14, height: 1, color: on),
      labelMedium: t.labelMedium?.copyWith(fontSize: 12, height: 1, color: on),
    );
  }
}

// Size aliases (h-series = font size + default weight 400)
extension AppTextSizes on TextTheme {
  TextStyle get h1 => headlineLarge!;
  TextStyle get h2 => headlineMedium!;
  TextStyle get h3 => titleLarge!;
  TextStyle get h4 => titleMedium!;
  TextStyle get h5 => bodyLarge!;
  TextStyle get h6 => bodySmall!;
  TextStyle get h7 => labelSmall!;
}

// Weight extensions - apply only if deviating from default (400)
extension AppTextWeights on TextStyle {
  TextStyle get w300 => copyWith(fontWeight: FontWeight.w300);
  TextStyle get w500 => copyWith(fontWeight: FontWeight.w500);
}

// Muted text example (unchanged)
extension AppMutedText on BuildContext {
  TextStyle get bodySmallMuted {
    final t = Theme.of(this).textTheme;
    final on = Theme.of(this).colorScheme.onSurface;
    return t.bodySmall!.copyWith(color: on.withOpacity(0.56));
  }
}
