class NutritionSummaryModel {
  final DateTime startDate;
  final DateTime endDate;
  final double avgCalories;
  final double avgProtein;
  final double avgCarbs;
  final double avgFat;
  final int totalMeals;
  final int daysLogged;
  final Map<String, int> gradeDistribution; // {'A': 5, 'B': 3, ...}

  NutritionSummaryModel({
    required this.startDate,
    required this.endDate,
    this.avgCalories = 0,
    this.avgProtein = 0,
    this.avgCarbs = 0,
    this.avgFat = 0,
    this.totalMeals = 0,
    this.daysLogged = 0,
    this.gradeDistribution = const {},
  });

  double get consistency => daysLogged > 0 ? (daysLogged / 7) * 100 : 0;

  Map<String, dynamic> toMap() => {
    'startDate': startDate.toIso8601String(), 'endDate': endDate.toIso8601String(),
    'avgCalories': avgCalories, 'avgProtein': avgProtein,
    'avgCarbs': avgCarbs, 'avgFat': avgFat,
    'totalMeals': totalMeals, 'daysLogged': daysLogged,
    'gradeDistribution': gradeDistribution,
  };
}
