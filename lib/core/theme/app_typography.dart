import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// NutriMove Design System — Typography
/// Uses Google Fonts (Outfit for headings, Inter for body).
class AppTypography {
  AppTypography._();

  // ─── Display ────────────────────────────────────────
  static TextStyle displayLarge = GoogleFonts.outfit(
    fontSize: 40,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -1.5,
    height: 1.15,
  );

  static TextStyle displayMedium = GoogleFonts.outfit(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -1.0,
    height: 1.2,
  );

  static TextStyle displaySmall = GoogleFonts.outfit(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
    height: 1.25,
  );

  // ─── Headline ───────────────────────────────────────
  static TextStyle headlineLarge = GoogleFonts.outfit(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static TextStyle headlineMedium = GoogleFonts.outfit(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.35,
  );

  static TextStyle headlineSmall = GoogleFonts.outfit(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  // ─── Title ──────────────────────────────────────────
  static TextStyle titleLarge = GoogleFonts.inter(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  static TextStyle titleMedium = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.45,
  );

  static TextStyle titleSmall = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  // ─── Body ───────────────────────────────────────────
  static TextStyle bodyLarge = GoogleFonts.inter(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  static TextStyle bodyMedium = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.55,
  );

  static TextStyle bodySmall = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textTertiary,
    height: 1.6,
  );

  // ─── Label ──────────────────────────────────────────
  static TextStyle labelLarge = GoogleFonts.inter(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 0.5,
    height: 1.4,
  );

  static TextStyle labelMedium = GoogleFonts.inter(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
    letterSpacing: 0.4,
    height: 1.45,
  );

  static TextStyle labelSmall = GoogleFonts.inter(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.textTertiary,
    letterSpacing: 0.3,
    height: 1.5,
  );

  // ─── Special ────────────────────────────────────────
  static TextStyle gradeLabel = GoogleFonts.outfit(
    fontSize: 48,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    height: 1.0,
  );

  static TextStyle streakCounter = GoogleFonts.outfit(
    fontSize: 36,
    fontWeight: FontWeight.w700,
    color: AppColors.streakFire,
    height: 1.1,
  );

  static TextStyle calorieCount = GoogleFonts.outfit(
    fontSize: 44,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
    height: 1.1,
  );

  static TextStyle nutriValue = GoogleFonts.inter(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  // ─── Metode Pembaruan Tema Dinamis ───────────────────
  static void updateTheme(bool isDark) {
    final textColor = isDark ? const Color(0xFFFFFFFF) : const Color(0xFF1E1E1E);
    final textSecColor = isDark ? const Color(0xFFE0E0E0) : const Color(0xFF5A5A5A);
    final textTertColor = isDark ? const Color(0xFFB0B0B0) : const Color(0xFF787878);

    displayLarge = displayLarge.copyWith(color: textColor);
    displayMedium = displayMedium.copyWith(color: textColor);
    displaySmall = displaySmall.copyWith(color: textColor);
    
    headlineLarge = headlineLarge.copyWith(color: textColor);
    headlineMedium = headlineMedium.copyWith(color: textColor);
    headlineSmall = headlineSmall.copyWith(color: textColor);
    
    titleLarge = titleLarge.copyWith(color: textColor);
    titleMedium = titleMedium.copyWith(color: textColor);
    titleSmall = titleSmall.copyWith(color: textColor);
    
    bodyLarge = bodyLarge.copyWith(color: textSecColor);
    bodyMedium = bodyMedium.copyWith(color: textSecColor);
    bodySmall = bodySmall.copyWith(color: textTertColor);
    
    labelLarge = labelLarge.copyWith(color: textColor);
    labelMedium = labelMedium.copyWith(color: textSecColor);
    labelSmall = labelSmall.copyWith(color: textTertColor);
    
    gradeLabel = gradeLabel.copyWith(color: textColor);
    nutriValue = nutriValue.copyWith(color: textColor);
  }
}
