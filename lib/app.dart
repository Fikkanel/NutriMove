import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/app_colors.dart';
import 'core/theme/app_typography.dart';
import 'core/router/app_router.dart';
import 'core/config/env_config.dart';

// Widget root utama untuk aplikasi NutriMove.
class NutriMoveApp extends StatefulWidget {
  const NutriMoveApp({super.key});

  @override
  State<NutriMoveApp> createState() => _NutriMoveAppState();
}

class _NutriMoveAppState extends State<NutriMoveApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = AppRouter.createRouter();
  }

  // Fungsi build utama untuk me-render MaterialApp.router, mendeteksi tema, dan mengonfigurasi tema sistem
  @override
  Widget build(BuildContext context) {
    // Deteksi kecerahan layar sistem HP secara dinamis dan update token warna/teks
    final isDark = MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    AppColors.updateTheme(isDark);
    AppTypography.updateTheme(isDark);

    return MaterialApp.router(
      title: 'NutriMove',
      debugShowCheckedModeBanner: EnvConfig.enableDebugBanner,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: _router,
    );
  }
}
