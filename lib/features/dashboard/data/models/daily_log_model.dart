import '../../../scanner/data/models/food_item_model.dart';

class DailyLogModel {
  final String id;
  final DateTime date;
  final double totalCalories;
  final double totalProtein;
  final double totalCarbs;
  final double totalFat;
  final List<FoodItemModel> meals;
  final int streakDay;

  DailyLogModel({
    required this.id,
    required this.date,
    this.totalCalories = 0,
    this.totalProtein = 0,
    this.totalCarbs = 0,
    this.totalFat = 0,
    this.meals = const [],
    this.streakDay = 0,
  });

  int get mealCount => meals.length;

  Map<String, dynamic> toMap() => {
    'id': id, 'date': date.toIso8601String(),
    'totalCalories': totalCalories, 'totalProtein': totalProtein,
    'totalCarbs': totalCarbs, 'totalFat': totalFat,
    'streakDay': streakDay,
  };

  factory DailyLogModel.fromMap(Map<String, dynamic> map, [List<FoodItemModel>? meals]) => DailyLogModel(
    id: map['id'] ?? '',
    date: DateTime.parse(map['date'] ?? DateTime.now().toIso8601String()),
    totalCalories: (map['totalCalories'] ?? 0).toDouble(),
    totalProtein: (map['totalProtein'] ?? 0).toDouble(),
    totalCarbs: (map['totalCarbs'] ?? 0).toDouble(),
    totalFat: (map['totalFat'] ?? 0).toDouble(),
    meals: meals ?? [],
    streakDay: map['streakDay'] ?? 0,
  );
}
