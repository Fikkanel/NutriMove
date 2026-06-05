import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Layanan penyimpanan lokal persisten menggunakan SharedPreferences (Offline-First Cache)
class LocalStorageService {
  static SharedPreferences? _prefs;

  // Inisialisasi instansi SharedPreferences saat startup aplikasi
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

  // Menyimpan data Map ke penyimpanan lokal.
  static Future<void> setMap(String key, Map<String, dynamic> val) async {
    try {
      await prefs.setString(key, jsonEncode(val));
    } catch (e) {
      debugPrint("Error saving map for key $key: $e");
    }
  }

  // Membaca data Map dari memori lokal HP berdasarkan key (JSON decode)
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

  // Menyimpan data List ke penyimpanan lokal.
  static Future<void> setList(String key, List<dynamic> val) async {
    try {
      await prefs.setString(key, jsonEncode(val));
    } catch (e) {
      debugPrint("Error saving list for key $key: $e");
    }
  }

  // Membaca data List dari penyimpanan lokal.
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

  // Menyimpan data integer ke penyimpanan lokal.
  static Future<void> setInt(String key, int val) async {
    try {
      await prefs.setInt(key, val);
    } catch (e) {
      debugPrint("Error saving int for key $key: $e");
    }
  }

  // Membaca data integer dari penyimpanan lokal.
  static int? getInt(String key) {
    try {
      return prefs.getInt(key);
    } catch (e) {
      debugPrint("Error reading int for key $key: $e");
      return null;
    }
  }
}
