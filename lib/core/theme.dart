import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Primary palette
  static const Color primary = Color(0xFF006D37);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFF2EC66E);
  static const Color onPrimaryContainer = Color(0xFF004C24);
  static const Color primaryFixed = Color(0xFF6FFD9E);
  static const Color primaryFixedDim = Color(0xFF50E085);

  // Secondary palette
  static const Color secondary = Color(0xFF515D85);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryFixed = Color(0xFFDBE1FF);
  static const Color onSecondaryFixed = Color(0xFF0B193E);

  // Tertiary palette
  static const Color tertiary = Color(0xFF865300);
  static const Color tertiaryContainer = Color(0xFFF19B10);
  static const Color onTertiaryContainer = Color(0xFF5E3900);

  // Background & Surface
  static const Color background = Color(0xFFF4FCF1);
  static const Color surface = Color(0xFFF4FCF1);
  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFEEF6EB);
  static const Color surfaceContainer = Color(0xFFE8F0E5);
  static const Color surfaceContainerHigh = Color(0xFFE2EAE0);
  static const Color surfaceContainerHighest = Color(0xFFDDE5DA);
  static const Color surfaceDim = Color(0xFFD4DCD2);
  static const Color surfaceVariant = Color(0xFFDDE5DA);

  // On Surface
  static const Color onSurface = Color(0xFF161D17);
  static const Color onSurfaceVariant = Color(0xFF3D4A3E);
  static const Color outline = Color(0xFF6D7B6D);
  static const Color outlineVariant = Color(0xFFBCCABB);

  // Inverse
  static const Color inverseSurface = Color(0xFF2B322B);
  static const Color inverseOnSurface = Color(0xFFEBF3E8);
  static const Color inversePrimary = Color(0xFF50E085);

  // Error
  static const Color error = Color(0xFFBA1A1A);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onError = Color(0xFFFFFFFF);
}

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: AppColors.primary,
        onPrimary: AppColors.onPrimary,
        primaryContainer: AppColors.primaryContainer,
        onPrimaryContainer: AppColors.onPrimaryContainer,
        secondary: AppColors.secondary,
        onSecondary: AppColors.onSecondary,
        secondaryContainer: AppColors.secondaryFixed,
        onSecondaryContainer: AppColors.onSecondaryFixed,
        tertiary: AppColors.tertiary,
        onTertiary: AppColors.onPrimary,
        tertiaryContainer: AppColors.tertiaryContainer,
        onTertiaryContainer: AppColors.onTertiaryContainer,
        error: AppColors.error,
        onError: AppColors.onError,
        errorContainer: AppColors.errorContainer,
        onErrorContainer: Color(0xFF93000A),
        surface: AppColors.surface,
        onSurface: AppColors.onSurface,
        onSurfaceVariant: AppColors.onSurfaceVariant,
        outline: AppColors.outline,
        outlineVariant: AppColors.outlineVariant,
        inverseSurface: AppColors.inverseSurface,
        onInverseSurface: AppColors.inverseOnSurface,
        inversePrimary: AppColors.inversePrimary,
        surfaceTint: AppColors.primary,
      ),
      scaffoldBackgroundColor: AppColors.background,
      textTheme: GoogleFonts.plusJakartaSansTextTheme().copyWith(
        headlineLarge: GoogleFonts.plusJakartaSans(
          fontSize: 30,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.6,
          color: AppColors.onSurface,
        ),
        headlineMedium: GoogleFonts.plusJakartaSans(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.24,
          color: AppColors.onSurface,
        ),
        headlineSmall: GoogleFonts.plusJakartaSans(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: AppColors.onSurface,
        ),
        bodyLarge: GoogleFonts.plusJakartaSans(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.onSurface,
        ),
        bodyMedium: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppColors.onSurface,
        ),
        labelLarge: GoogleFonts.plusJakartaSans(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.onSurface,
        ),
        labelSmall: GoogleFonts.plusJakartaSans(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.onSurface,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.onPrimary,
        elevation: 4,
        centerTitle: false,
        titleTextStyle: GoogleFonts.plusJakartaSans(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          color: AppColors.onPrimary,
          letterSpacing: -0.24,
        ),
      ),
      cardTheme: const CardThemeData(
        color: AppColors.surfaceContainerLowest,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
          elevation: 0,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceContainerLowest,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryContainer, width: 2),
        ),
        hintStyle: GoogleFonts.plusJakartaSans(
          color: AppColors.outline,
          fontSize: 14,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.onSurfaceVariant,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
