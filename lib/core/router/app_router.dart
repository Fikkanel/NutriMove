import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/profile_setup_screen.dart';
import '../../features/dashboard/presentation/screens/home_screen.dart';
import '../../features/dashboard/presentation/screens/weekly_report_screen.dart';
import '../../features/dashboard/presentation/screens/edit_meal_screen.dart';
import '../../features/scanner/presentation/screens/camera_screen.dart';
import '../../features/scanner/presentation/screens/scan_result_screen.dart';
import '../../features/scanner/presentation/screens/manual_input_screen.dart';
import '../../features/nutribot/presentation/screens/chat_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../features/profile/presentation/screens/allergen_settings_screen.dart';
import '../../features/profile/presentation/screens/diet_goal_screen.dart';
import '../../features/profile/presentation/screens/settings_screen.dart';
import '../../features/nutrigrade/presentation/screens/food_detail_screen.dart';
import '../../features/nutrigrade/presentation/screens/recommendation_screen.dart';
import '../../features/gamification/presentation/screens/achievements_screen.dart';
import '../../shared/widgets/bottom_nav_bar.dart';

// NutriMove — Router Navigasi Utama Aplikasi (GoRouter)
class AppRouter {
  AppRouter._();

  static GoRouter createRouter() {
    final shellNavigatorKey = GlobalKey<NavigatorState>();

    return GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    routes: [
      // ─── Rute Autentikasi (tanpa navigasi bawah) ──────────────
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/profile-setup',
        builder: (context, state) => const ProfileSetupScreen(),
      ),

      // ─── Shell Utama (dengan navigasi bawah) ─────────────
      ShellRoute(
        navigatorKey: shellNavigatorKey,
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: '/home',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HomeScreen(),
            ),
          ),
          GoRoute(
            path: '/scan',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: CameraScreen(),
            ),
          ),
          GoRoute(
            path: '/chat',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ChatScreen(),
            ),
          ),
          GoRoute(
            path: '/reports',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: WeeklyReportScreen(),
            ),
          ),
          GoRoute(
            path: '/profile',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ProfileScreen(),
            ),
          ),
        ],
      ),

      // ─── Rute Detail (ditumpuk di atas halaman utama) ────────────
      GoRoute(
        path: '/scan/result',
        builder: (context, state) => const ScanResultScreen(),
      ),
      GoRoute(
        path: '/scan/manual',
        builder: (context, state) => const ManualInputScreen(),
      ),
      GoRoute(
        path: '/food/:id',
        builder: (context, state) {
          final foodId = state.pathParameters['id'] ?? '';
          return FoodDetailScreen(foodId: foodId);
        },
      ),
      GoRoute(
        path: '/recommendations',
        builder: (context, state) => const RecommendationScreen(),
      ),
      GoRoute(
        path: '/achievements',
        builder: (context, state) => const AchievementsScreen(),
      ),
      GoRoute(
        path: '/profile/edit',
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/profile/allergens',
        builder: (context, state) => const AllergenSettingsScreen(),
      ),
      GoRoute(
        path: '/profile/goals',
        builder: (context, state) => const DietGoalScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/meal/edit',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return EditMealScreen(
            mealIndex: extra['index'] as int,
            mealData: extra['meal'] as Map<String, dynamic>,
          );
        },
      ),
    ],
  );
  }
}

// Widget shell utama yang membungkus halaman dengan navigasi bawah.
class MainShell extends StatelessWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: const NutriMoveBottomNavBar(),
    );
  }
}
