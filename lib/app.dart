import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/config/env_config.dart';

/// Root application widget.
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'NutriMove',
      debugShowCheckedModeBanner: EnvConfig.enableDebugBanner,
      theme: AppTheme.lightTheme,
      routerConfig: _router,
    );
  }
}
