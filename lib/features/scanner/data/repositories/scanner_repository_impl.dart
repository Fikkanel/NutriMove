import 'package:firebase_auth/firebase_auth.dart';
import '../../../dashboard/data/repositories/dashboard_repository_impl.dart';
import '../../domain/repositories/scanner_repository.dart';
import '../models/food_item_model.dart';
import '../services/food_recognition_service.dart';
import '../../../../core/storage/local_storage_service.dart';

/// Scanner repository with food recognition and local offline storage integration.
class ScannerRepositoryImpl implements ScannerRepository {
  final _foodRecognition = FoodRecognitionService();

  bool get lastScanQuotaExceeded => _foodRecognition.lastScanQuotaExceeded;

  Map<String, dynamic> getLocalNutrition(String foodName) {
    return _foodRecognition.getLocalNutritionFacts(foodName);
  }

  List<String> getLocalFoodNames() {
    return _foodRecognition.getLocalFoodNames();
  }

  @override
  Future<FoodItemModel> scanFood(String imagePath) async {
    final results = await _foodRecognition.classify(imagePath);
    String foodName = results.isNotEmpty ? results[0]['label'] : 'Unknown';
    double confidence = results.isNotEmpty ? results[0]['confidence'] : 0.0;
    
    final nutrition = await _foodRecognition.getNutritionFromGemini(foodName);
    
    final cal = (nutrition['calories'] ?? 0).toDouble();
    final pro = (nutrition['protein'] ?? 0).toDouble();
    final carb = (nutrition['carbs'] ?? 0).toDouble();
    final fat = (nutrition['fat'] ?? 0).toDouble();
    
    // Calculate grade dynamically (same logic as NutriGradeProvider)
    final proteinScore = (pro / 50.0).clamp(0.0, 1.0) * 40;
    final calScore = cal < 500 ? 20 : (cal < 800 ? 10 : 0);
    final fatScore = fat < 15 ? 20 : (fat < 30 ? 10 : 0);
    final carbScore = carb < 60 ? 20 : (carb < 100 ? 10 : 0);

    final score = proteinScore + calScore + fatScore + carbScore;
    String grade = 'D';
    if (score >= 80) {
      grade = 'A';
    } else if (score >= 60) {
      grade = 'B';
    } else if (score >= 40) {
      grade = 'C';
    }
    
    return FoodItemModel(
      id: 'scan_${DateTime.now().millisecondsSinceEpoch}',
      name: foodName,
      calories: cal,
      protein: pro,
      carbs: carb,
      fat: fat,
      grade: grade,
      confidence: confidence
    );
  }

  @override
  Future<FoodItemModel> manualInput(Map<String, dynamic> data) async {
    return FoodItemModel(
      id: 'manual_${DateTime.now().millisecondsSinceEpoch}',
      name: data['name'] ?? '', calories: (data['calories'] ?? 0).toDouble(),
      protein: (data['protein'] ?? 0).toDouble(), carbs: (data['carbs'] ?? 0).toDouble(),
      fat: (data['fat'] ?? 0).toDouble(),
    );
  }

  @override
  Future<List<FoodItemModel>> searchFood(String query) async {
    try {
      final names = getLocalFoodNames();
      final matches = names.where((name) => name.toLowerCase().contains(query.toLowerCase())).toList();
      return matches.map((name) {
        final facts = getLocalNutrition(name);
        return FoodItemModel(
          id: 'local_${name.toLowerCase().replaceAll(' ', '_')}',
          name: name,
          calories: (facts['calories'] ?? 0).toDouble(),
          protein: (facts['protein'] ?? 0).toDouble(),
          carbs: (facts['carbs'] ?? 0).toDouble(),
          fat: (facts['fat'] ?? 0).toDouble(),
        );
      }).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> saveMealToLog(FoodItemModel food) async {
    final user = FirebaseAuth.instance.currentUser;
    final userId = user?.uid ?? 'local_user';
    try {
      final dashboardRepo = DashboardRepositoryImpl();
      await dashboardRepo.addMeal(userId, food);

      if (food.id.startsWith('scan_')) {
        final key = 'gamification_scans_$userId';
        final current = LocalStorageService.getInt(key) ?? 0;
        await LocalStorageService.setInt(key, current + 1);
      }
    } catch (e) {
      // ignore
    }
  }
}
