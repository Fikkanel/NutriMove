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

  // ─── Surface Colors (Light Theme) ───────────────────
  static const Color background = Color(0xFFFAFAFA); // Off-white
  static const Color surface = Color(0xFFFFFFFF);    // Pure white
  static const Color surfaceLight = Color(0xFFF0F0F0); // Very light grey
  static const Color surfaceCard = Color(0xFFFFFFFF);
  static const Color surfaceElevated = Color(0xFFF8F9FA);

  // ─── Text Colors ────────────────────────────────────
  static const Color textPrimary = Color(0xFF1E1E1E);   // Near black
  static const Color textSecondary = Color(0xFF5A5A5A); // Dark grey
  static const Color textTertiary = Color(0xFF787878);  // Medium grey
  static const Color textDisabled = Color(0xFFB4B4B4);

  // ─── Border / Divider ───────────────────────────────
  static const Color border = Color(0xFFE6E6E6);
  static const Color borderLight = Color(0xFFF0F0F0);
  static const Color divider = Color(0xFFDCDCDC);

  // ─── Gradients ──────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF00B482), Color(0xFF00E5FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF8F9FA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient backgroundGradient = LinearGradient(
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
}
