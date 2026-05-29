import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/repositories/gamification_repository_impl.dart';
import '../../domain/usecases/update_streak.dart';

/// Manages daily streak and achievements.
class GamificationProvider extends ChangeNotifier {
  final _repo = GamificationRepositoryImpl();
  late final UpdateStreakUseCase _updateStreakUseCase;

  int _currentStreak = 0;
  int _longestStreak = 0;
  bool _loggedToday = false;
  List<Map<String, dynamic>> _achievements = [];

  int get currentStreak => _currentStreak;
  int get longestStreak => _longestStreak;
  bool get loggedToday => _loggedToday;
  List<Map<String, dynamic>> get achievements => _achievements;

  GamificationProvider() {
    _updateStreakUseCase = UpdateStreakUseCase(_repo);
  }

  String _getUserId() {
    return FirebaseAuth.instance.currentUser?.uid ?? 'local_user';
  }

  Future<void> loadStreakData() async {
    final userId = _getUserId();
    try {
      final streak = await _repo.getStreak(userId);
      _currentStreak = streak.currentStreak;
      _longestStreak = streak.longestStreak;
      _loggedToday = streak.loggedToday;
      
      final achs = await _repo.getAchievements(userId);
      _achievements = achs.map((a) => a.toMap()).toList();
    } catch (e) {
      debugPrint('Error loading streak: $e');
    }
    notifyListeners();
  }

  /// Call this when a meal is saved (scan or manual).
  /// Uses UpdateStreakUseCase which handles:
  /// - Skip if already logged today
  /// - Reset streak if missed a day
  /// - Increment streak otherwise
  Future<void> incrementStreak() async {
    final userId = _getUserId();
    try {
      final streak = await _updateStreakUseCase.execute(userId);

      // Persist the result from the use case
      await _repo.saveStreak(userId, streak);

      _currentStreak = streak.currentStreak;
      _longestStreak = streak.longestStreak;
      _loggedToday = streak.loggedToday;

      // Check and unlock streak-based achievements
      await _checkStreakAchievements(userId);

      notifyListeners();
    } catch (e) {
      debugPrint('Error incrementing streak: $e');
    }
  }

  Future<void> _checkStreakAchievements(String userId) async {
    try {
      final achs = await _repo.getAchievements(userId);
      bool updated = false;

      for (int i = 0; i < achs.length; i++) {
        final a = achs[i];
        // Update currentValue for streak-type achievements
        if (a.type.name == 'streak' && a.currentValue < _currentStreak) {
          achs[i] = a.copyWithProgress(_currentStreak);
          updated = true;
        }
        // Auto-unlock if target reached
        if (!a.unlocked && a.currentValue >= a.targetValue) {
          await _repo.unlockAchievement(userId, a.id);
          updated = true;
        }
      }

      if (updated) {
        _achievements = achs.map((a) => a.toMap()).toList();
      }
    } catch (e) {
      debugPrint('Error checking achievements: $e');
    }
  }
}
