class AchievementModel {
  final String id;
  final String title;
  final String description;
  final String iconName;
  final bool unlocked;
  final DateTime? unlockedAt;
  final AchievementType type;
  final int targetValue;
  final int currentValue;

  AchievementModel({
    required this.id, required this.title, required this.description,
    this.iconName = 'emoji_events', this.unlocked = false, this.unlockedAt,
    this.type = AchievementType.streak, this.targetValue = 0, this.currentValue = 0,
  });

  double get progress => targetValue > 0 ? (currentValue / targetValue).clamp(0, 1) : 0;

  Map<String, dynamic> toMap() => {
    'id': id, 'title': title, 'description': description, 'iconName': iconName,
    'unlocked': unlocked, 'unlockedAt': unlockedAt?.toIso8601String(),
    'type': type.name, 'targetValue': targetValue, 'currentValue': currentValue,
  };

  factory AchievementModel.fromMap(Map<String, dynamic> map) => AchievementModel(
    id: map['id'] ?? '', title: map['title'] ?? '', description: map['description'] ?? '',
    iconName: map['iconName'] ?? 'emoji_events', unlocked: map['unlocked'] ?? false,
    unlockedAt: map['unlockedAt'] != null ? DateTime.parse(map['unlockedAt']) : null,
    type: AchievementType.values.firstWhere((e) => e.name == map['type'], orElse: () => AchievementType.streak),
    targetValue: map['targetValue'] ?? 0, currentValue: map['currentValue'] ?? 0,
  );
  AchievementModel copyWithProgress(int newCurrentValue) => AchievementModel(
    id: id, title: title, description: description, iconName: iconName,
    unlocked: newCurrentValue >= targetValue ? true : unlocked,
    unlockedAt: (newCurrentValue >= targetValue && !unlocked) ? DateTime.now() : unlockedAt,
    type: type, targetValue: targetValue, currentValue: newCurrentValue,
  );
}

enum AchievementType { streak, scan, grade, meals }
