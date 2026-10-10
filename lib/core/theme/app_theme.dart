import 'package:flutter/material.dart';

// ─── Design System Mockup Match ─────────────────────────────────────────────
class AppColors {
  AppColors._();

  // Background Theme — Mint pastel khas mockup
  static const Color background = Color(0xFFEBF4EE); // mint pastel soft
  static const Color backgroundLight = Color(0xFFF3F8F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color white = Color(0xFFFFFFFF);

  // CTA & Action — Black Pill Button khas mockup
  static const Color primary = Color(0xFF16181B); // deep black for CTA pill
  static const Color primaryDark = Color(0xFF000000);
  static const Color primaryLight = Color(0xFF2E3330);

  // Price Badge — Emerald Mint Green
  static const Color emerald = Color(0xFF00B67A);
  static const Color emeraldLight = Color(0xFFE2F7EE);

  // Accent & Offer Badges khas mockup
  static const Color accent = Color(0xFF00B67A);
  static const Color badgeMemberBg = Color(0xFFDDF0FD); // soft sky blue
  static const Color badgeMemberText = Color(0xFF1E78C2);
  static const Color badgeValueBg = Color(0xFFEFE5FC); // soft lavender
  static const Color badgeValueText = Color(0xFF7A45C4);
  static const Color badgeOrangeBg = Color(0xFFFFECE0);
  static const Color badgeOrangeText = Color(0xFFDE641C);

  // Neutral tones
  static const Color grey50 = Color(0xFFF8F9FA);
  static const Color grey100 = Color(0xFFF1F3F4);
  static const Color grey200 = Color(0xFFE5E9E7);
  static const Color grey400 = Color(0xFFA6ACA9);
  static const Color grey600 = Color(0xFF6F7673);
  static const Color grey800 = Color(0xFF2C322F);
  static const Color grey900 = Color(0xFF171A19);

  // Star & Highlight
  static const Color highlight = Color(0xFFFFAE00);
  static const Color star = Color(0xFFFFAE00);
  static const Color success = Color(0xFF00B67A);
  static const Color error = Color(0xFFEA4335);
  static const Color cardShadow = Color(0x0C000000);
  static const Color divider = Color(0xFFE8ECE9);
}

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: 'Poppins',
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.white,
        surface: AppColors.surface,
        onSurface: AppColors.grey900,
        secondary: AppColors.emerald,
        onSecondary: AppColors.white,
      ),

      // AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: AppColors.grey900,
        ),
        iconTheme: IconThemeData(color: AppColors.grey900),
      ),

      // Card
      cardTheme: CardThemeData(
        color: AppColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        margin: EdgeInsets.zero,
      ),

      // ElevatedButton — Black pill CTA khas mockup
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // TextTheme
      textTheme: const TextTheme(
        displaySmall: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: AppColors.grey900,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.grey900,
        ),
        titleLarge: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: AppColors.grey900,
        ),
        titleMedium: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppColors.grey900,
        ),
        titleSmall: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.grey900,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.grey800,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: AppColors.grey600,
        ),
        bodySmall: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 11,
          fontWeight: FontWeight.w400,
          color: AppColors.grey600,
        ),
      ),
    );
  }
}
