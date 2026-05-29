import '../../data/models/daily_log_model.dart';
import '../../data/models/nutrition_summary_model.dart';
import '../../../scanner/data/models/food_item_model.dart';

/// Dashboard repository interface.
abstract class DashboardRepository {
  Future<DailyLogModel> getTodayLog(String userId);
  Future<List<Map<String, dynamic>>> getTodayMeals(String userId);
  Future<void> addMeal(String userId, FoodItemModel meal);
  Future<void> updateMeal(String userId, int index, Map<String, dynamic> updatedMeal);
  Future<void> deleteMeal(String userId, int index);
  Future<NutritionSummaryModel> getWeeklySummary(String userId);
  Future<List<DailyLogModel>> getLogHistory(String userId, int days);
}
