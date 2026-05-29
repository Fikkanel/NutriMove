class NutritionDataModel {
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final double fiber;
  final double sugar;
  final double sodium;
  final double servingSize; // grams

  NutritionDataModel({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.fiber = 0,
    this.sugar = 0,
    this.sodium = 0,
    this.servingSize = 100,
  });

  double get totalMacros => protein + carbs + fat;
  double get proteinPercent => totalMacros > 0 ? (protein / totalMacros) * 100 : 0;
  double get carbsPercent => totalMacros > 0 ? (carbs / totalMacros) * 100 : 0;
  double get fatPercent => totalMacros > 0 ? (fat / totalMacros) * 100 : 0;

  Map<String, dynamic> toMap() => {
    'calories': calories, 'protein': protein, 'carbs': carbs, 'fat': fat,
    'fiber': fiber, 'sugar': sugar, 'sodium': sodium, 'servingSize': servingSize,
  };

  factory NutritionDataModel.fromMap(Map<String, dynamic> map) => NutritionDataModel(
    calories: (map['calories'] ?? 0).toDouble(),
    protein: (map['protein'] ?? 0).toDouble(),
    carbs: (map['carbs'] ?? 0).toDouble(),
    fat: (map['fat'] ?? 0).toDouble(),
    fiber: (map['fiber'] ?? 0).toDouble(),
    sugar: (map['sugar'] ?? 0).toDouble(),
    sodium: (map['sodium'] ?? 0).toDouble(),
    servingSize: (map['servingSize'] ?? 100).toDouble(),
  );
}
