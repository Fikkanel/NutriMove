import '../../data/models/streak_data_model.dart';
import '../../data/models/achievement_model.dart';

/// Gamification repository interface.
abstract class GamificationRepository {
  Future<StreakDataModel> getStreak(String userId);
  Future<StreakDataModel> updateStreak(String userId);
  Future<void> saveStreak(String userId, StreakDataModel streak);
  Future<List<AchievementModel>> getAchievements(String userId);
  Future<void> unlockAchievement(String userId, String achievementId);
}
