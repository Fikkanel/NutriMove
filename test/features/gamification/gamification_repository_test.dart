import 'package:flutter_test/flutter_test.dart';
import 'package:nutrimove/features/gamification/data/models/streak_data_model.dart';

void main() {
  group('StreakDataModel', () {
    test('initial streak is 0', () {
      final streak = StreakDataModel();
      expect(streak.currentStreak, 0);
      expect(streak.longestStreak, 0);
      expect(streak.loggedToday, isFalse);
    });

    test('incrementStreak increases current streak by 1', () {
      final streak = StreakDataModel(currentStreak: 5, longestStreak: 10);
      final updated = streak.incrementStreak();
      expect(updated.currentStreak, 6);
      expect(updated.longestStreak, 10);
    });

    test('incrementStreak updates longest when exceeding record', () {
      final streak = StreakDataModel(currentStreak: 10, longestStreak: 10);
      final updated = streak.incrementStreak();
      expect(updated.currentStreak, 11);
      expect(updated.longestStreak, 11);
    });

    test('resetStreak sets current to 0 but keeps longest', () {
      final streak = StreakDataModel(currentStreak: 5, longestStreak: 15);
      final reset = streak.resetStreak();
      expect(reset.currentStreak, 0);
      expect(reset.longestStreak, 15);
    });

    test('loggedToday returns true when lastLogDate is today', () {
      final streak = StreakDataModel(currentStreak: 1, lastLogDate: DateTime.now());
      expect(streak.loggedToday, isTrue);
    });

    test('loggedToday returns false when lastLogDate is yesterday', () {
      final streak = StreakDataModel(currentStreak: 1, lastLogDate: DateTime.now().subtract(const Duration(days: 1)));
      expect(streak.loggedToday, isFalse);
    });

    test('toMap and fromMap round-trip', () {
      final original = StreakDataModel(currentStreak: 7, longestStreak: 14, lastLogDate: DateTime(2026, 5, 15));
      final map = original.toMap();
      final restored = StreakDataModel.fromMap(map);
      expect(restored.currentStreak, original.currentStreak);
      expect(restored.longestStreak, original.longestStreak);
    });
  });
}
