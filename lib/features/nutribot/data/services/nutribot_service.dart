import 'package:google_generative_ai/google_generative_ai.dart';
import '../../../../core/config/env_config.dart';
import '../models/chat_message_model.dart';

/// NutriBot AI service — Gemini/OpenAI integration.
class NutribotService {
  late GenerativeModel _model;
  ChatSession? _chatSession;

  NutribotService() {
    _model = GenerativeModel(
      model: 'gemini-3.5-flash',
      apiKey: EnvConfig.geminiApiKey,
      systemInstruction: Content.system(
          "Kamu adalah NutriBot, asisten gizi cerdas yang ramah, bersemangat, dan selalu siap membantu. Gunakan bahasa Indonesia sehari-hari, selalu tambahkan emoji yang relevan, dan jawablah dengan singkat tapi padat. Fokus pada topik gizi, diet, kalori, dan gaya hidup sehat."),
    );
    _chatSession = _model.startChat();
  }

  Future<String> getResponse(String userMessage, List<ChatMessageModel> context) async {
    if (EnvConfig.geminiApiKey.isEmpty) {
      return "Oops! 🤖 API Key Gemini belum dikonfigurasi. Silakan periksa file env_config.dart ya!";
    }

    try {
      final response = await _chatSession!.sendMessage(Content.text(userMessage));
      return response.text ?? 'Maaf, saya sedang bingung mencerna informasinya. 😅';
    } catch (e) {
      return 'Waduh, terjadi kendala saat menyambung ke server AI nih. Coba lagi nanti ya! 🔌 ($e)';
    }
  }
}
