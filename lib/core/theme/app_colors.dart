import 'package:flutter/material.dart';

/// NutriMove Design System — Color Palette
/// Clean, modern light mode with vibrant health-tech green/teal accents.
class AppColors {
  AppColors._();

  // ─── Primary Brand Colors ───────────────────────────
  static const Color primary = Color(0xFF00B482); // Vibrant Teal/Mint
  static const Color primaryLight = Color(0xFF4EE8B6);
  static const Color primaryDark = Color(0xFF00825B);

  // ─── Secondary / Accent ─────────────────────────────
  static const Color secondary = Color(0xFFFF9F43); // Energetic Orange
  static const Color secondaryLight = Color(0xFFFFC076);
  static const Color secondaryDark = Color(0xFFC67015);

  // ─── Tertiary / Accent ──────────────────────────────
  static const Color tertiary = Color(0xFF7BF8FF); // Bright Cyan
  static const Color tertiaryLight = Color(0xFFA6FAFF);
  static const Color tertiaryDark = Color(0xFF4AC2C9);

  // ─── NutriGrade Colors ──────────────────────────────
  static const Color gradeA = Color(0xFF00E676);
  static const Color gradeB = Color(0xFFFFEA00);
  static const Color gradeC = Color(0xFFFF9100);
  static const Color gradeD = Color(0xFFFF1744);

  // ─── Streak / Gamification ──────────────────────────
  static const Color streakFire = Color(0xFFFF6D00);
  static const Color streakFireGlow = Color(0xFFFFAB40);
  static const Color achievementGold = Color(0xFFFFD600);

  // ─── Semantic Colors ────────────────────────────────
  static const Color success = Color(0xFF00C853);
  static const Color warning = Color(0xFFFFAB00);
  static const Color error = Color(0xFFFF3B30);
  static const Color info = Color(0xFF00B0FF);

  // ─── Surface Colors (Dinamis: Diperbarui via updateTheme) ───────────────────
  static Color background = const Color(0xFFFAFAFA); // Off-white
  static Color surface = const Color(0xFFFFFFFF);    // Pure white
  static Color surfaceLight = const Color(0xFFF0F0F0); // Very light grey
  static Color surfaceCard = const Color(0xFFFFFFFF);
  static Color surfaceElevated = const Color(0xFFF8F9FA);

  // ─── Text Colors (Dinamis) ────────────────────────────────────
  static Color textPrimary = const Color(0xFF1E1E1E);   // Near black
  static Color textSecondary = const Color(0xFF5A5A5A); // Dark grey
  static Color textTertiary = const Color(0xFF787878);  // Medium grey
  static Color textDisabled = const Color(0xFFB4B4B4);

  // ─── Border / Divider (Dinamis) ───────────────────────────────
  static Color border = const Color(0xFFE6E6E6);
  static Color borderLight = const Color(0xFFF0F0F0);
  static Color divider = const Color(0xFFDCDCDC);

  // ─── Gradients ──────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF00B482), Color(0xFF00E5FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient cardGradient = const LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF8F9FA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient backgroundGradient = const LinearGradient(
    colors: [Color(0xFFFAFAFA), Color(0xFFF0FAFA)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cyanGradient = LinearGradient(
    colors: [Color(0xFF7BF8FF), Color(0x007BF8FF)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient streakGradient = LinearGradient(
    colors: [streakFire, streakFireGlow, achievementGold],
    begin: Alignment.bottomLeft,
    end: Alignment.topRight,
  );

  // ─── Metode Pembaruan Tema Dinamis ───────────────────
  // Mengubah warna tema aplikasi secara dinamis di runtime berdasarkan deteksi Mode Gelap sistem HP
  static void updateTheme(bool isDark) {
    if (isDark) {
      // Skema Warna Gelap (Dark Mode)
      background = const Color(0xFF121212);
      surface = const Color(0xFF1E1E1E);
      surfaceLight = const Color(0xFF2D2D2D);
      surfaceCard = const Color(0xFF1E1E1E);
      surfaceElevated = const Color(0xFF242424);

      textPrimary = const Color(0xFFFFFFFF);
      textSecondary = const Color(0xFFE0E0E0);
      textTertiary = const Color(0xFFB0B0B0);
      textDisabled = const Color(0xFF666666);

      border = const Color(0xFF2D2D2D);
      borderLight = const Color(0xFF242424);
      divider = const Color(0xFF2A2A2A);

      cardGradient = const LinearGradient(
        colors: [Color(0xFF1E1E1E), Color(0xFF242424)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

      backgroundGradient = const LinearGradient(
        colors: [Color(0xFF121212), Color(0xFF1A1F1E)], // Dark green-ish tint background
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else {
      // Skema Warna Terang (Light Mode)
      background = const Color(0xFFFAFAFA);
      surface = const Color(0xFFFFFFFF);
      surfaceLight = const Color(0xFFF0F0F0);
      surfaceCard = const Color(0xFFFFFFFF);
      surfaceElevated = const Color(0xFFF8F9FA);

      textPrimary = const Color(0xFF1E1E1E);
      textSecondary = const Color(0xFF5A5A5A);
      textTertiary = const Color(0xFF787878);
      textDisabled = const Color(0xFFB4B4B4);

      border = const Color(0xFFE6E6E6);
      borderLight = const Color(0xFFF0F0F0);
      divider = const Color(0xFFDCDCDC);

      cardGradient = const LinearGradient(
        colors: [Color(0xFFFFFFFF), Color(0xFFF8F9FA)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

      backgroundGradient = const LinearGradient(
        colors: [Color(0xFFFAFAFA), Color(0xFFF0FAFA)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    }
  }
}
