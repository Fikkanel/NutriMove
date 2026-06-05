import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../config/env_config.dart';

/// Service untuk memanggil API Groq sebagai fallback (cadangan) ketika Gemini melampaui kuota.
class GroqService {
  static const String _baseUrl = 'https://api.groq.com/openai/v1/chat/completions';
  
  static Map<String, String> get _headers => {
    'Authorization': 'Bearer ${EnvConfig.groqApiKey}',
    'Content-Type': 'application/json',
  };

  /// Memanggil model Chat (LLaMA 3.3) untuk percakapan atau analisis nutrisi/rekomendasi.
  static Future<String?> chat(
    String prompt, {
    String systemInstruction = "",
    String model = "llama-3.3-70b-versatile",
    bool jsonMode = false,
  }) async {
    if (EnvConfig.groqApiKey.isEmpty) {
      debugPrint("Groq API Key kosong!");
      return null;
    }

    try {
      final messages = [];
      if (systemInstruction.isNotEmpty) {
        messages.add({"role": "system", "content": systemInstruction});
      }
      messages.add({"role": "user", "content": prompt});

      final Map<String, dynamic> body = {
        "model": model,
        "messages": messages,
      };

      if (jsonMode) {
        body["response_format"] = {"type": "json_object"};
      }

      debugPrint("Groq API Request: model=$model, prompt=${prompt.substring(0, prompt.length > 50 ? 50 : prompt.length)}...");

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: _headers,
        body: jsonEncode(body),
      ).timeout(const Duration(seconds: 30));

      debugPrint("Groq API Response status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'];
        debugPrint("Groq API Success: ${content.toString().substring(0, content.toString().length > 80 ? 80 : content.toString().length)}...");
        return content;
      } else {
        debugPrint("Groq API Error: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      debugPrint("Groq Exception: $e");
      return null;
    }
  }

  /// Memanggil model Vision (LLaMA 3.2 Vision) untuk klasifikasi gambar.
  static Future<String?> classifyImage(
    String base64Image, {
    String prompt = "Identifikasi makanan pada gambar ini. Jika gambar bukan berupa makanan, jawab HANYA dengan kata 'BUKAN_MAKANAN'. Jika makanan, berikan HANYA nama makanan dalam Bahasa Indonesia.",
    String model = "llama-3.2-11b-vision-preview",
  }) async {
    if (EnvConfig.groqApiKey.isEmpty) {
      debugPrint("Groq API Key kosong!");
      return null;
    }

    try {
      final body = {
        "model": model,
        "messages": [
          {
            "role": "user",
            "content": [
              {
                "type": "text",
                "text": prompt
              },
              {
                "type": "image_url",
                "image_url": {
                  "url": "data:image/jpeg;base64,$base64Image"
                }
              }
            ]
          }
        ]
      };

      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: _headers,
        body: jsonEncode(body),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        debugPrint("Groq Vision API Error: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      debugPrint("Groq Vision Exception: $e");
      return null;
    }
  }
}
