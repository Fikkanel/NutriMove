class StreakDataModel {
  final int currentStreak;
  final int longestStreak;
  final DateTime? lastLogDate;

  StreakDataModel({this.currentStreak = 0, this.longestStreak = 0, this.lastLogDate});

  bool get loggedToday {
    if (lastLogDate == null) return false;
    final now = DateTime.now();
    return lastLogDate!.year == now.year && lastLogDate!.month == now.month && lastLogDate!.day == now.day;
  }

  StreakDataModel incrementStreak() {
    final newStreak = currentStreak + 1;
    return StreakDataModel(
      currentStreak: newStreak,
      longestStreak: newStreak > longestStreak ? newStreak : longestStreak,
      lastLogDate: DateTime.now(),
    );
  }

  StreakDataModel resetStreak() => StreakDataModel(currentStreak: 0, longestStreak: longestStreak, lastLogDate: lastLogDate);

  Map<String, dynamic> toMap() => {
    'currentStreak': currentStreak, 'longestStreak': longestStreak,
    'lastLogDate': lastLogDate?.toIso8601String(),
  };

  factory StreakDataModel.fromMap(Map<String, dynamic> map) => StreakDataModel(
    currentStreak: map['currentStreak'] ?? 0, longestStreak: map['longestStreak'] ?? 0,
    lastLogDate: map['lastLogDate'] != null ? DateTime.parse(map['lastLogDate']) : null,
  );
}
