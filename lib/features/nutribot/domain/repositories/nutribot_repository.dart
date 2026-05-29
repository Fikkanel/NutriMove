import '../../data/models/chat_message_model.dart';

/// NutriBot repository interface.
abstract class NutribotRepository {
  Future<ChatMessageModel> sendMessage(String text, List<ChatMessageModel> history);
  Future<List<ChatMessageModel>> getChatHistory(String userId);
  Future<void> clearHistory(String userId);
}
