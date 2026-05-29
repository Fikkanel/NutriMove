import '../../data/repositories/gamification_repository_impl.dart';
import '../../data/models/streak_data_model.dart';

/// Use case: Update daily streak when user logs a meal.
class UpdateStreakUseCase {
  final GamificationRepositoryImpl _repository;

  UpdateStreakUseCase(this._repository);

  /// Call this when a user logs their first meal of the day.
  /// Checks if already logged today, increments streak if not.
  /// Handles midnight reset logic.
  Future<StreakDataModel> execute(String userId) async {
    final current = await _repository.getStreak(userId);

    // Already logged today
    if (current.loggedToday) return current;

    // Check if streak should reset (missed yesterday)
    if (current.lastLogDate != null) {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final lastLog = current.lastLogDate!;
      final missedDay = lastLog.year != yesterday.year || lastLog.month != yesterday.month || lastLog.day != yesterday.day;

      if (missedDay && !current.loggedToday) {
        // Streak broken — reset then increment
        final reset = current.resetStreak();
        // Save reset, then increment
        return reset.incrementStreak();
      }
    }

    // Normal increment
    return await _repository.updateStreak(userId);
  }
}
