import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color background = Color(0xFFF7F5F2);
  static const Color primaryText = Color(0xFF141414);
  static const Color secondaryText = Color(0xFF6F6B66);
  static const Color primaryGreen = Color(0xFF2E6140);
  static const Color lightGreen = Color(0xFFE7F0EA);
  static const Color card = Color(0xFFFFFFFF);
  static const Color softSurface = Color(0xFFEFEDE9);
  static const Color border = Color(0xFFE4E0DA);

  // Aliases for M3 compatibility
  static const Color surface = background;
  static const Color onSurface = primaryText;
  static const Color onSurfaceVariant = secondaryText;
  static const Color primary = primaryGreen;
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = lightGreen;
  static const Color onPrimaryContainer = primaryGreen;
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.light(
        surface: AppColors.background,
        onSurface: AppColors.primaryText,
        primary: AppColors.primaryGreen,
        onPrimary: Colors.white,
        primaryContainer: AppColors.lightGreen,
        onPrimaryContainer: AppColors.primaryGreen,
        secondary: AppColors.secondaryText,
        surfaceContainerLow: AppColors.softSurface,
        outline: AppColors.border,
      ),
      textTheme: TextTheme(
        headlineLarge: GoogleFonts.fraunces(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryText,
          letterSpacing: -0.5,
        ),
        headlineMedium: GoogleFonts.fraunces(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryText,
        ),
        headlineSmall: GoogleFonts.fraunces(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryText,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: AppColors.primaryText,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.secondaryText,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppColors.secondaryText,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        labelMedium: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        labelSmall: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primaryText),
        titleTextStyle: GoogleFonts.fraunces(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryText,
        ),
      ),
    );
  }
}
