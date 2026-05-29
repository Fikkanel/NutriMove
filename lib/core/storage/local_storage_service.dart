import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Local Storage Service for saving application data offline.
class LocalStorageService {
  static SharedPreferences? _prefs;

  /// Initialize SharedPreferences instance.
  static Future<void> init() async {
    if (_prefs != null) return;
    try {
      _prefs = await SharedPreferences.getInstance();
      debugPrint("LocalStorageService initialized successfully.");
    } catch (e) {
      debugPrint("Error initializing LocalStorageService: $e");
    }
  }

  static SharedPreferences get prefs {
    if (_prefs == null) {
      throw Exception("LocalStorageService not initialized. Call init() first.");
    }
    return _prefs!;
  }

  /// Save map to local storage.
  static Future<void> setMap(String key, Map<String, dynamic> val) async {
    try {
      await prefs.setString(key, jsonEncode(val));
    } catch (e) {
      debugPrint("Error saving map for key $key: $e");
    }
  }

  /// Get map from local storage.
  static Map<String, dynamic>? getMap(String key) {
    try {
      final data = prefs.getString(key);
      if (data == null) return null;
      return jsonDecode(data) as Map<String, dynamic>;
    } catch (e) {
      debugPrint("Error reading map for key $key: $e");
      return null;
    }
  }

  /// Save list to local storage.
  static Future<void> setList(String key, List<dynamic> val) async {
    try {
      await prefs.setString(key, jsonEncode(val));
    } catch (e) {
      debugPrint("Error saving list for key $key: $e");
    }
  }

  /// Get list from local storage.
  static List<dynamic>? getList(String key) {
    try {
      final data = prefs.getString(key);
      if (data == null) return null;
      return jsonDecode(data) as List<dynamic>;
    } catch (e) {
      debugPrint("Error reading list for key $key: $e");
      return null;
    }
  }

  /// Save integer to local storage.
  static Future<void> setInt(String key, int val) async {
    try {
      await prefs.setInt(key, val);
    } catch (e) {
      debugPrint("Error saving int for key $key: $e");
    }
  }

  /// Get integer from local storage.
  static int? getInt(String key) {
    try {
      return prefs.getInt(key);
    } catch (e) {
      debugPrint("Error reading int for key $key: $e");
      return null;
    }
  }
}
