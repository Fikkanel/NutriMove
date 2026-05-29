/// NutriMove — Application Constants
class AppConstants {
  AppConstants._();

  // ─── App Info ───────────────────────────────────────
  static const String appName = 'NutriMove';
  static const String appTagline = 'Smart Nutrition Assistant';
  static const String appVersion = '1.0.0';

  // ─── Spacing ────────────────────────────────────────
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;
  static const double spacingXxl = 48.0;

  // ─── Border Radius ──────────────────────────────────
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 24.0;
  static const double radiusFull = 100.0;

  // ─── Animation Durations ────────────────────────────
  static const Duration animFast = Duration(milliseconds: 200);
  static const Duration animNormal = Duration(milliseconds: 350);
  static const Duration animSlow = Duration(milliseconds: 500);

  // ─── Nutrition Defaults ─────────────────────────────
  static const double defaultCalorieTarget = 2000.0;
  static const double defaultProteinTarget = 50.0; // grams
  static const double defaultCarbsTarget = 250.0; // grams
  static const double defaultFatTarget = 65.0; // grams

  // ─── NutriGrade Thresholds ──────────────────────────
  static const double gradeAMin = 80.0;
  static const double gradeBMin = 60.0;
  static const double gradeCMin = 40.0;
  // Below 40 = Grade D

  // ─── Firestore Collections ─────────────────────────
  static const String usersCollection = 'users';
  static const String dailyLogsCollection = 'daily_logs';
  static const String mealsCollection = 'meals';
  static const String streaksCollection = 'streaks';
  static const String achievementsCollection = 'achievements';
  static const String chatHistoryCollection = 'chat_history';
  static const String foodDatabaseCollection = 'food_database';

  // ─── Assets Paths ──────────────────────────────────
  static const String assetsImages = 'assets/images/';
  static const String assetsIcons = 'assets/icons/';
  static const String assetsModels = 'assets/models/';
  static const String assetsAnimations = 'assets/animations/';
}
