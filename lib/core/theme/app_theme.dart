import 'package:flutter/material.dart';

// ─── Brand Colors ──────────────────────────────────────────────────────────
class AppColors {
  AppColors._();

  // Primary — Biru Navy
  static const Color primary = Color(0xFF1A2E4A);
  static const Color primaryLight = Color(0xFF2A4A72);
  static const Color primaryDark = Color(0xFF0D1E32);

  // Accent — Oranye
  static const Color accent = Color(0xFFE8701A);
  static const Color accentLight = Color(0xFFF08C3A);
  static const Color accentDark = Color(0xFFBF5A10);

  // Highlight — Kuning
  static const Color highlight = Color(0xFFF5C518);
  static const Color highlightLight = Color(0xFFF7D14A);

  // Neutral
  static const Color white = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFF8F9FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color grey50 = Color(0xFFF8F9FA);
  static const Color grey100 = Color(0xFFF1F3F4);
  static const Color grey200 = Color(0xFFE8EAED);
  static const Color grey400 = Color(0xFFBDC1C6);
  static const Color grey600 = Color(0xFF80868B);
  static const Color grey800 = Color(0xFF3C4043);
  static const Color grey900 = Color(0xFF202124);

  // Semantic
  static const Color success = Color(0xFF34A853);
  static const Color warning = Color(0xFFFBBC04);
  static const Color error = Color(0xFFEA4335);
  static const Color info = Color(0xFF4285F4);

  // Specific UI
  static const Color cardShadow = Color(0x1A000000);
  static const Color divider = Color(0xFFE8EAED);
  static const Color shimmerBase = Color(0xFFE0E0E0);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);
}

// ─── App Theme ─────────────────────────────────────────────────────────────
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primary,
        onPrimary: AppColors.white,
        primaryContainer: AppColors.primaryLight,
        onPrimaryContainer: AppColors.white,
        secondary: AppColors.accent,
        onSecondary: AppColors.white,
        secondaryContainer: AppColors.accentLight,
        onSecondaryContainer: AppColors.white,
        tertiary: AppColors.highlight,
        onTertiary: AppColors.grey900,
        tertiaryContainer: AppColors.highlightLight,
        onTertiaryContainer: AppColors.grey900,
        error: AppColors.error,
        onError: AppColors.white,
        errorContainer: Color(0xFFFCE8E6),
        onErrorContainer: AppColors.error,
        surface: AppColors.surface,
        onSurface: AppColors.grey900,
        surfaceContainerHighest: AppColors.grey100,
        onSurfaceVariant: AppColors.grey600,
        outline: AppColors.grey200,
        outlineVariant: AppColors.grey400,
        shadow: AppColors.cardShadow,
        scrim: Color(0x80000000),
        inverseSurface: AppColors.grey900,
        onInverseSurface: AppColors.white,
        inversePrimary: AppColors.primaryLight,
      ),
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: 'Poppins',

      // AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.white,
        foregroundColor: AppColors.grey900,
        elevation: 0,
        scrolledUnderElevation: 1,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 18,
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
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        shadowColor: AppColors.cardShadow,
        margin: EdgeInsets.zero,
      ),

      // ElevatedButton — CTA utama (hitam/navy)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          minimumSize: const Size(double.infinity, 52),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          elevation: 0,
        ),
      ),

      // OutlinedButton
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          minimumSize: const Size(double.infinity, 52),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          textStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // TextButton
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.accent,
          textStyle: const TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // InputDecoration
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.grey50,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.grey200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.grey200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        hintStyle: const TextStyle(
          fontFamily: 'Poppins',
          color: AppColors.grey400,
          fontSize: 14,
        ),
        labelStyle: const TextStyle(
          fontFamily: 'Poppins',
          color: AppColors.grey600,
          fontSize: 14,
        ),
      ),

      // BottomNavigationBar
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.white,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.grey400,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 11,
        ),
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.grey100,
        selectedColor: AppColors.primary,
        labelStyle: const TextStyle(
          fontFamily: 'Poppins',
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      ),

      // Text
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: AppColors.grey900,
        ),
        displayMedium: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: AppColors.grey900,
        ),
        displaySmall: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: AppColors.grey900,
        ),
        headlineLarge: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: AppColors.grey900,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.grey900,
        ),
        headlineSmall: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.grey900,
        ),
        titleLarge: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: AppColors.grey900,
        ),
        titleMedium: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.grey900,
        ),
        titleSmall: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.grey800,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.grey900,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.grey800,
        ),
        bodySmall: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppColors.grey600,
        ),
        labelLarge: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.grey900,
        ),
        labelMedium: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.grey800,
        ),
        labelSmall: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: AppColors.grey600,
        ),
      ),

      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 0,
      ),
    );
  }
}
