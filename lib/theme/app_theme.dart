import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Fitly Design System
  static const Color background = Color(0xFFF7F3ED); // Warm Ivory
  static const Color surface = Color(0xFFFFFFFF); // White
  static const Color card = Color(0xFFFFFFFF);
  static const Color softSurface = Color(0xFFF0ECE4); // Warm soft fill
  static const Color border = Color(0xFFE8E3DC); // Soft Ivory Border

  static const Color primaryPurple = Color(0xFF6C4CF6); // Fitly Purple
  static const Color primaryPurpleDark = Color(0xFF5836E6);
  static const Color primaryPurpleLight = Color(0xFFEFEAFF); // Purple tint container
  static const Color aiGradientStart = Color(0xFF8B5CF6);
  static const Color aiGradientEnd = Color(0xFF6C4CF6);

  static const Color primaryText = Color(0xFF1F1C1A); // Charcoal
  static const Color secondaryText = Color(0xFF77716A); // Muted Gray
  static const Color tertiaryText = Color(0xFFA09B94);

  static const Color success = Color(0xFF16A34A); // Soft Green
  static const Color warning = Color(0xFFF97316); // Soft Orange
  static const Color error = Color(0xFFEF4444); // Soft Red
  static const Color discountBadge = Color(0xFFE11D48);

  // Backward-compatibility aliases
  static const Color primaryGreen = primaryPurple;
  static const Color lightGreen = primaryPurpleLight;
  static const Color primaryGreenLight = Color(0xFFDCFCE7);
  static const Color ratingAmber = Color(0xFFF59E0B);
  static const Color primary = primaryPurple;
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onSurface = primaryText;
  static const Color onSurfaceVariant = secondaryText;
  static const Color primaryContainer = primaryPurpleLight;
  static const Color onPrimaryContainer = primaryPurple;

  static const LinearGradient purpleAiGradient = LinearGradient(
    colors: [aiGradientStart, aiGradientEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.light(
        surface: AppColors.surface,
        onSurface: AppColors.primaryText,
        primary: AppColors.primaryPurple,
        onPrimary: Colors.white,
        primaryContainer: AppColors.primaryPurpleLight,
        onPrimaryContainer: AppColors.primaryPurple,
        secondary: AppColors.secondaryText,
        surfaceContainerLow: AppColors.softSurface,
        outline: AppColors.border,
        error: AppColors.error,
      ),
      textTheme: TextTheme(
        headlineLarge: GoogleFonts.fraunces(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryText,
          letterSpacing: -0.5,
        ),
        headlineMedium: GoogleFonts.fraunces(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryText,
          letterSpacing: -0.3,
        ),
        headlineSmall: GoogleFonts.fraunces(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryText,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryText,
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: 15,
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
          fontWeight: FontWeight.w700,
          color: AppColors.primaryText,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryPurple,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryPurple,
          side: const BorderSide(color: AppColors.primaryPurple, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
