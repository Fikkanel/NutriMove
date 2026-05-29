import '../../domain/repositories/gamification_repository.dart';
import '../models/streak_data_model.dart';
import '../models/achievement_model.dart';
import '../../../../core/storage/local_storage_service.dart';

/// Offline SharedPreferences-based implementation of GamificationRepository.
class GamificationRepositoryImpl implements GamificationRepository {
  StreakDataModel _cachedStreak = StreakDataModel();

  @override
  Future<StreakDataModel> getStreak(String userId) async {
    try {
      final key = 'gamification_streak_$userId';
      final data = LocalStorageService.getMap(key);
      if (data != null) {
        _cachedStreak = StreakDataModel.fromMap(data);
      }
    } catch (e) {
      // ignore
    }
    return _cachedStreak;
  }

  @override
  Future<StreakDataModel> updateStreak(String userId) async {
    await getStreak(userId);
    if (!_cachedStreak.loggedToday) {
      _cachedStreak = _cachedStreak.incrementStreak();
      try {
        final key = 'gamification_streak_$userId';
        await LocalStorageService.setMap(key, _cachedStreak.toMap());
      } catch (e) {
        // ignore
      }
    }
    return _cachedStreak;
  }

  @override
  Future<void> saveStreak(String userId, StreakDataModel streak) async {
    _cachedStreak = streak;
    try {
      final key = 'gamification_streak_$userId';
      await LocalStorageService.setMap(key, streak.toMap());
    } catch (e) {
      // ignore
    }
  }

  @override
  Future<List<AchievementModel>> getAchievements(String userId) async {
    final streak = await getStreak(userId);
    final scanCount = LocalStorageService.getInt('gamification_scans_$userId') ?? 0;
    final gradeACount = LocalStorageService.getInt('gamification_grade_a_$userId') ?? 0;

    return [
      AchievementModel(
        id: '1',
        title: 'First Scan',
        description: 'Scan makanan pertamamu!',
        type: AchievementType.scan,
        targetValue: 1,
        currentValue: scanCount,
        unlocked: scanCount >= 1,
      ),
      AchievementModel(
        id: '2',
        title: '7-Day Streak',
        description: '7 hari berturut-turut',
        type: AchievementType.streak,
        targetValue: 7,
        currentValue: streak.currentStreak,
        unlocked: streak.currentStreak >= 7,
      ),
      AchievementModel(
        id: '3',
        title: '30-Day Streak',
        description: '30 hari berturut-turut',
        type: AchievementType.streak,
        targetValue: 30,
        currentValue: streak.currentStreak,
        unlocked: streak.currentStreak >= 30,
      ),
      AchievementModel(
        id: '4',
        title: 'NutriMaster',
        description: '50x Grade A',
        type: AchievementType.grade,
        targetValue: 50,
        currentValue: gradeACount,
        unlocked: gradeACount >= 50,
      ),
    ];
  }

  @override
  Future<void> unlockAchievement(String userId, String achievementId) async {
    // Computed dynamically based on progress
  }
}
