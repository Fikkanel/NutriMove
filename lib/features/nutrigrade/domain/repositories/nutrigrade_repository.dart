import '../../data/models/nutrigrade_model.dart';

/// NutriGrade repository interface.
abstract class NutriGradeRepository {
  Future<NutriGradeModel> calculateGrade(Map<String, double> nutritionData, List<String> userAllergens);
  Future<List<Map<String, dynamic>>> getRecommendations(Map<String, double> currentNutrition, List<String> allergens);
}
