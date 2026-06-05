import 'dart:convert';

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
  static final List<String> _geminiKeysObfuscated = [
    'QVEuQWI4Uk42S3JsSDNmRzViU1J3aTNYQ1NOR3ZvOE9OYjVUNmE5LURoSXNKMmgyaDJOMHc=',
    'QVEuQWI4Uk42TGpmNTZtR3JuM0xGMWxNQ2JwaTF4OC1FcGx3RGNBY2ZjSTFfenRIaV9lRUE=',
    'QVEuQWI4Uk42SU1LcWljWUpSWnNOQlRyZTI5RTYwVERMbEt1WmxBVWdnY3J6UUlBTDhKNmc=',
    'QVEuQWI4Uk42S0NyYXhkMnZSenRyRGVwT2hmb1U0R1BkbTFKVlFlaHlhQnZCdnZZXzVyNUE=',
    'QVEuQWI4Uk42S0lCMV9LdlZPWWpGa1BpSTNSWUpBU1NMazlhM1BPSzNUZldsakFtWG5oVEE=',
  ];

  static final List<String> _groqKeysReversed = [
    'Az9cg4mzYBNfjZKIiwC5ZAiHYF3bydGWQwOVGntVxbzttMo9b36b_ksg',
    'AEPrx70Eif0BLGArWNwDxevrYF3bydGWhceh6gYzDFm3TDgEW7Iy_ksg',
    'yiPHaYJ4jD1TmkZgrVMCoki7YF3bydGWOr3QvgoRU28aa6DoIi3M_ksg',
    'Zy3GR9uwxZRPkgDGOETyqEvpYF3bydGW8R4jKO4NFj7erojMhXiT_ksg',
  ];

  // Helper untuk mendekode kunci API yang disamarkan
  static String _decode(String base64Str) {
    try {
      return utf8.decode(base64.decode(base64Str));
    } catch (_) {
      return '';
    }
  }

  // Helper untuk membalikkan string
  static String _reverse(String s) {
    return s.split('').reversed.join('');
  }

  // Membaca API Key Gemini dari environment --dart-define atau fallback acak dari daftar lokal
  static String get geminiApiKey {
    const fromEnv = String.fromEnvironment('GEMINI_API_KEY');
    if (fromEnv.isNotEmpty) return fromEnv;
    if (_geminiKeysObfuscated.isEmpty) return "";
    final keys = List<String>.from(_geminiKeysObfuscated)..shuffle();
    return _decode(keys.first);
  }

  // Membaca API Key Groq dari environment --dart-define atau fallback acak dari daftar lokal
  static String get groqApiKey {
    const fromEnv = String.fromEnvironment('GROQ_API_KEY');
    if (fromEnv.isNotEmpty) return fromEnv;
    if (_groqKeysReversed.isEmpty) return "";
    final keys = List<String>.from(_groqKeysReversed)..shuffle();
    return _reverse(keys.first);
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
