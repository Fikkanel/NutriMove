import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/config/env_config.dart';
import '../../../../core/services/groq_service.dart';
import '../models/chat_message_model.dart';

/// NutriBot AI service — Gemini/OpenAI integration.
class NutribotService {
  late GenerativeModel _model;
  ChatSession? _chatSession;
  
  static const String _systemPrompt = "Kamu adalah NutriBot, asisten gizi cerdas yang ramah, bersemangat, dan selalu siap membantu. Gunakan bahasa Indonesia sehari-hari, selalu tambahkan emoji yang relevan, dan jawablah dengan singkat tapi padat. Fokus pada topik gizi, diet, kalori, dan gaya hidup sehat.";

  NutribotService() {
    _model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: EnvConfig.geminiApiKey,
      systemInstruction: Content.system(_systemPrompt),
    );
    _chatSession = _model.startChat();
  }

  // Mengirim pesan pengguna beserta riwayat obrolan (chat context) ke model Gemini AI dan mengembalikan jawabannya
  Future<String> getResponse(String userMessage, List<ChatMessageModel> context) async {
    if (EnvConfig.geminiApiKey.isEmpty) {
      return await _fallbackToGroq(userMessage) ?? "Oops! 🤖 API Key Gemini belum dikonfigurasi. Silakan periksa file env_config.dart ya!";
    }

    try {
      final response = await _chatSession!.sendMessage(Content.text(userMessage));
      return response.text ?? 'Maaf, saya sedang bingung mencerna informasinya. 😅';
    } catch (e) {
      debugPrint("Gemini NutriBot Error: $e. Falling back to Groq.");
      final groqResponse = await _fallbackToGroq(userMessage);
      if (groqResponse != null) {
        return groqResponse;
      }
      return 'Waduh, terjadi kendala saat menyambung ke server AI nih. Coba lagi nanti ya! 🔌 ($e)';
    }
  }
  
  Future<String?> _fallbackToGroq(String userMessage) async {
    return await GroqService.chat(
      userMessage,
      systemInstruction: _systemPrompt,
    );
  }
}
