/// NutriMove — Environment Configuration
class EnvConfig {
  EnvConfig._();

  // ─── Environment Type ───────────────────────────────
  static const String environment = String.fromEnvironment(
    'ENV',
    defaultValue: 'development',
  );

  static bool get isDevelopment => environment == 'development';
  static bool get isStaging => environment == 'staging';
  static bool get isProduction => environment == 'production';

  // ─── API Keys (loaded from dart-define) ─────────────
  static const String geminiApiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: '',
  );

  // ─── Feature Flags ──────────────────────────────────
  static const bool enableNutriBot = bool.fromEnvironment(
    'ENABLE_NUTRIBOT',
    defaultValue: true,
  );

  static const bool enableFoodScanner = bool.fromEnvironment(
    'ENABLE_FOOD_SCANNER',
    defaultValue: true,
  );

  static const bool enableDebugBanner = bool.fromEnvironment(
    'ENABLE_DEBUG_BANNER',
    defaultValue: false,
  );
}
