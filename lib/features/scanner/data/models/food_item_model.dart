class FoodItemModel {
  final String id;
  final String name;
  final String? category;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;
  final String grade;
  final List<String> allergens;
  final String? imageUrl;
  final double confidence;
  final DateTime scannedAt;

  FoodItemModel({
    required this.id,
    required this.name,
    this.category,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.grade = '',
    this.allergens = const [],
    this.imageUrl,
    this.confidence = 0,
    DateTime? scannedAt,
  }) : scannedAt = scannedAt ?? DateTime.now();

  Map<String, dynamic> toMap() => {
    'id': id, 'name': name, 'category': category,
    'calories': calories, 'protein': protein, 'carbs': carbs, 'fat': fat,
    'grade': grade, 'allergens': allergens, 'imageUrl': imageUrl,
    'confidence': confidence, 'scannedAt': scannedAt.toIso8601String(),
  };

  factory FoodItemModel.fromMap(Map<String, dynamic> map) => FoodItemModel(
    id: map['id'] ?? '', name: map['name'] ?? '', category: map['category'],
    calories: (map['calories'] ?? 0).toDouble(),
    protein: (map['protein'] ?? 0).toDouble(),
    carbs: (map['carbs'] ?? 0).toDouble(),
    fat: (map['fat'] ?? 0).toDouble(),
    grade: map['grade'] ?? '',
    allergens: List<String>.from(map['allergens'] ?? []),
    imageUrl: map['imageUrl'], confidence: (map['confidence'] ?? 0).toDouble(),
    scannedAt: map['scannedAt'] != null ? DateTime.parse(map['scannedAt']) : null,
  );
}
