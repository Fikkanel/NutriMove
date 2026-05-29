import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/repositories/dashboard_repository_impl.dart';
import '../../domain/repositories/dashboard_repository.dart';

/// Manages dashboard data: daily logs, calorie progress, macronutrients.
class DashboardProvider extends ChangeNotifier {
  final DashboardRepository _repository = DashboardRepositoryImpl();

  bool _isLoading = false;
  double _caloriesConsumed = 0;
  final double _calorieTarget = 2000;
  double _protein = 0;
  double _carbs = 0;
  double _fat = 0;
  List<Map<String, dynamic>> _todayMeals = [];

  bool get isLoading => _isLoading;
  double get caloriesConsumed => _caloriesConsumed;
  double get calorieTarget => _calorieTarget;
  double get protein => _protein;
  double get carbs => _carbs;
  double get fat => _fat;
  double get calorieProgress => _calorieTarget > 0 ? (_caloriesConsumed / _calorieTarget).clamp(0.0, 1.5) : 0;
  List<Map<String, dynamic>> get todayMeals => _todayMeals;

  Future<void> loadDashboardData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final userId = FirebaseAuth.instance.currentUser?.uid ?? 'local_user';

      final log = await _repository.getTodayLog(userId);
      _caloriesConsumed = log.totalCalories;
      _protein = log.totalProtein;
      _carbs = log.totalCarbs;
      _fat = log.totalFat;

      _todayMeals = await _repository.getTodayMeals(userId);
    } catch (e) {
      debugPrint('Error loading dashboard: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  void addMeal(Map<String, dynamic> meal) {
    _todayMeals.insert(0, meal);
    _caloriesConsumed += (meal['calories'] as num).toDouble();
    _protein += (meal['protein'] as num? ?? 0).toDouble();
    _carbs += (meal['carbs'] as num? ?? 0).toDouble();
    _fat += (meal['fat'] as num? ?? 0).toDouble();
    notifyListeners();
  }

  Future<void> updateMeal(int index, Map<String, dynamic> updatedMeal) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid ?? 'local_user';
      await _repository.updateMeal(userId, index, updatedMeal);
      await loadDashboardData();
    } catch (e) {
      debugPrint('Error updating meal: $e');
    }
  }

  Future<void> deleteMeal(int index) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid ?? 'local_user';
      await _repository.deleteMeal(userId, index);
      await loadDashboardData();
    } catch (e) {
      debugPrint('Error deleting meal: $e');
    }
  }
}
