class NutriGradeModel {
  final String foodName;
  final String grade; // A, B, C, D
  final double score; // 0-100
  final double proteinScore;
  final double fiberScore;
  final double sugarPenalty;
  final double sodiumPenalty;
  final double fatPenalty;
  final List<String> warnings;
  final String recommendation;

  NutriGradeModel({
    required this.foodName,
    required this.grade,
    required this.score,
    this.proteinScore = 0,
    this.fiberScore = 0,
    this.sugarPenalty = 0,
    this.sodiumPenalty = 0,
    this.fatPenalty = 0,
    this.warnings = const [],
    this.recommendation = '',
  });

  bool get isHealthy => score >= 60;
  bool get hasWarnings => warnings.isNotEmpty;

  Map<String, dynamic> toMap() => {
    'foodName': foodName, 'grade': grade, 'score': score,
    'proteinScore': proteinScore, 'fiberScore': fiberScore,
    'sugarPenalty': sugarPenalty, 'sodiumPenalty': sodiumPenalty,
    'fatPenalty': fatPenalty, 'warnings': warnings, 'recommendation': recommendation,
  };

  factory NutriGradeModel.fromMap(Map<String, dynamic> map) => NutriGradeModel(
    foodName: map['foodName'] ?? '', grade: map['grade'] ?? 'D',
    score: (map['score'] ?? 0).toDouble(),
    proteinScore: (map['proteinScore'] ?? 0).toDouble(),
    fiberScore: (map['fiberScore'] ?? 0).toDouble(),
    sugarPenalty: (map['sugarPenalty'] ?? 0).toDouble(),
    sodiumPenalty: (map['sodiumPenalty'] ?? 0).toDouble(),
    fatPenalty: (map['fatPenalty'] ?? 0).toDouble(),
    warnings: List<String>.from(map['warnings'] ?? []),
    recommendation: map['recommendation'] ?? '',
  );
}
