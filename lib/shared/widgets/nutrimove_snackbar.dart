import 'package:flutter/material.dart';
import '../../core/theme/app_typography.dart';

enum SnackbarType { success, error, info }

/// Modern, premium SnackBar helper for NutriMove.
class NutriMoveSnackbar {
  NutriMoveSnackbar._();

  static void show(
    BuildContext context, {
    required String message,
    required SnackbarType type,
    String? title,
  }) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    
    // Clear existing snackbars to avoid queue lag
    scaffoldMessenger.clearSnackBars();

    Color iconBgColor;
    IconData iconData;
    List<Color> gradientColors;
    Color shadowColor;

    switch (type) {
      case SnackbarType.success:
        iconData = Icons.check_circle_outline_rounded;
        iconBgColor = Colors.white.withValues(alpha: 0.2);
        gradientColors = [
          const Color(0xFF0D9488), // Teal 600
          const Color(0xFF10B981), // Emerald 500
        ];
        shadowColor = const Color(0xFF0D9488).withValues(alpha: 0.3);
        title ??= 'Sukses';
        break;
      case SnackbarType.error:
        iconData = Icons.error_outline_rounded;
        iconBgColor = Colors.white.withValues(alpha: 0.2);
        gradientColors = [
          const Color(0xFFEF4444), // Red 500
          const Color(0xFFDC2626), // Red 600
        ];
        shadowColor = const Color(0xFFDC2626).withValues(alpha: 0.3);
        title ??= 'Gagal';
        break;
      case SnackbarType.info:
        iconData = Icons.info_outline_rounded;
        iconBgColor = Colors.white.withValues(alpha: 0.2);
        gradientColors = [
          const Color(0xFF2563EB), // Blue 600
          const Color(0xFF0ea5e9), // Sky 500
        ];
        shadowColor = const Color(0xFF2563EB).withValues(alpha: 0.3);
        title ??= 'Informasi';
        break;
    }

    scaffoldMessenger.showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 4),
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: shadowColor,
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  iconData,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.titleSmall.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      message,
                      style: AppTypography.bodySmall.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
