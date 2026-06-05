import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../../../core/config/env_config.dart';
import '../../../../core/services/groq_service.dart';

/// Manages NutriBot chat state.
class NutribotProvider extends ChangeNotifier {
  bool _isLoading = false;
  final List<Map<String, dynamic>> _messages = [];

  bool get isLoading => _isLoading;
  List<Map<String, dynamic>> get messages => _messages;

  Future<void> sendMessage(String text) async {
    _messages.add({
      'text': text,
      'isUser': true,
      'timestamp': DateTime.now().toIso8601String(),
    });
    notifyListeners();

    _isLoading = true;
    notifyListeners();

    try {
      if (EnvConfig.geminiApiKey.isEmpty) throw Exception("API Key missing");
      final model = GenerativeModel(
        model: 'gemini-2.5-flash',
        apiKey: EnvConfig.geminiApiKey,
        systemInstruction: Content.system("Anda adalah NutriBot, ahli gizi virtual. Berikan jawaban ringkas, informatif, dan ramah dalam bahasa Indonesia terkait nutrisi dan kesehatan.")
      );
      final response = await model.generateContent([Content.text(text)]);
      _messages.add({
        'text': response.text ?? 'Maaf saya tidak bisa menjawab saat ini.',
        'isUser': false,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      debugPrint('Gemini Chat error: $e. Falling back to Groq.');
      final groqResponse = await GroqService.chat(
        text,
        systemInstruction: "Anda adalah NutriBot, ahli gizi virtual. Berikan jawaban ringkas, informatif, dan ramah dalam bahasa Indonesia terkait nutrisi dan kesehatan.",
      );
      
      if (groqResponse != null) {
        _messages.add({
          'text': groqResponse,
          'isUser': false,
          'timestamp': DateTime.now().toIso8601String(),
        });
      } else {
        _messages.add({
          'text': 'Maaf, terjadi kesalahan. Silakan coba lagi. ($e)',
          'isUser': false,
          'timestamp': DateTime.now().toIso8601String(),
        });
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  void clearChat() {
    _messages.clear();
    notifyListeners();
  }
}
