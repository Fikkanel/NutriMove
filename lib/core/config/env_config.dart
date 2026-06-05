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

  // ─── API Keys (loaded from dart-define or fallback lists) ─────────────
  static final List<String> _geminiKeys = [];

  static final List<String> _groqKeys = [];

  // Membaca API Key Gemini dari environment --dart-define atau fallback acak dari daftar lokal
  static String get geminiApiKey {
    const fromEnv = String.fromEnvironment('GEMINI_API_KEY');
    if (fromEnv.isNotEmpty) return fromEnv;
    if (_geminiKeys.isEmpty) return "";
    final keys = List<String>.from(_geminiKeys)..shuffle();
    return keys.first;
  }

  // Membaca API Key Groq dari environment --dart-define atau fallback acak dari daftar lokal
  static String get groqApiKey {
    const fromEnv = String.fromEnvironment('GROQ_API_KEY');
    if (fromEnv.isNotEmpty) return fromEnv;
    if (_groqKeys.isEmpty) return "";
    final keys = List<String>.from(_groqKeys)..shuffle();
    return keys.first;
  }

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
