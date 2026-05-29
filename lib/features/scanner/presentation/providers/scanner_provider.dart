import 'package:flutter/material.dart';
import '../../data/models/food_item_model.dart';
import '../../data/repositories/scanner_repository_impl.dart';

/// Manages food scanning state.
class ScannerProvider extends ChangeNotifier {
  final _repo = ScannerRepositoryImpl();
  bool _isScanning = false;
  bool _isProcessing = false;
  Map<String, dynamic>? _scanResult;
  String? _errorMessage;
  double _portionMultiplier = 1.0;

  bool get isScanning => _isScanning;
  bool get isProcessing => _isProcessing;
  Map<String, dynamic>? get scanResult => _scanResult;
  String? get errorMessage => _errorMessage;
  double get portionMultiplier => _portionMultiplier;

  void startScanning() {
    _isScanning = true;
    _scanResult = null;
    _errorMessage = null;
    _portionMultiplier = 1.0;
    notifyListeners();
  }

  Future<void> processImage(String imagePath) async {
    _isProcessing = true;
    notifyListeners();

    try {
      final food = await _repo.scanFood(imagePath);
      _scanResult = {
        'foodName': food.name,
        'confidence': food.confidence,
        'calories': food.calories,
        'protein': food.protein,
        'carbs': food.carbs,
        'fat': food.fat,
        'grade': food.grade,
        'isQuotaExceeded': _repo.lastScanQuotaExceeded,
      };
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isProcessing = false;
    _isScanning = false;
    notifyListeners();
  }

  Future<void> saveScannedMeal() async {
    if (_scanResult == null) return;
    
    String finalName = _scanResult!['foodName'] ?? 'Unknown';
    if (_portionMultiplier != 1.0) {
      finalName = '$finalName (${_portionMultiplier.toStringAsFixed(1)} Porsi)';
    }

    final food = FoodItemModel(
      id: 'scan_${DateTime.now().millisecondsSinceEpoch}',
      name: finalName,
      calories: (_scanResult!['calories'] ?? 0).toDouble(),
      protein: (_scanResult!['protein'] ?? 0).toDouble(),
      carbs: (_scanResult!['carbs'] ?? 0).toDouble(),
      fat: (_scanResult!['fat'] ?? 0).toDouble(),
      grade: _scanResult!['grade'] ?? 'B',
      confidence: (_scanResult!['confidence'] ?? 0).toDouble(),
    );
    await _repo.saveMealToLog(food);
  }

  Future<void> saveManualMeal(Map<String, dynamic> data) async {
    final food = await _repo.manualInput(data);
    
    // Calculate grade dynamically
    final pro = food.protein;
    final cal = food.calories;
    final fat = food.fat;
    final carb = food.carbs;
    
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

    final finalFood = FoodItemModel(
      id: food.id,
      name: food.name,
      calories: food.calories,
      protein: food.protein,
      carbs: food.carbs,
      fat: food.fat,
      grade: grade,
    );
    
    await _repo.saveMealToLog(finalFood);
  }

  List<String> getLocalFoodNames() {
    return _repo.getLocalFoodNames();
  }

  void updatePortion(double newPortion) {
    _portionMultiplier = newPortion;
    if (_scanResult != null) {
      final currentName = _scanResult!['foodName'] ?? 'Unknown';
      _updateNutritionForFoodAndPortion(currentName, _portionMultiplier);
    }
  }

  void updateScannedFoodName(String newName) {
    if (_scanResult == null) return;
    _updateNutritionForFoodAndPortion(newName, _portionMultiplier);
  }

  void _updateNutritionForFoodAndPortion(String foodName, double portion) {
    // 1. Get nutrition locally
    final nutrition = _repo.getLocalNutrition(foodName);
    
    final baseCal = (nutrition['calories'] ?? 0).toDouble();
    final basePro = (nutrition['protein'] ?? 0).toDouble();
    final baseCarb = (nutrition['carbs'] ?? 0).toDouble();
    final baseFat = (nutrition['fat'] ?? 0).toDouble();
    
    // Scale by portion multiplier
    final cal = baseCal * portion;
    final pro = basePro * portion;
    final carb = baseCarb * portion;
    final fat = baseFat * portion;
    
    // 2. Recalculate grade dynamically
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
    
    _scanResult = {
      ..._scanResult!,
      'foodName': foodName,
      'calories': cal,
      'protein': pro,
      'carbs': carb,
      'fat': fat,
      'grade': grade,
    };
    notifyListeners();
  }

  void reset() {
    _isScanning = false;
    _isProcessing = false;
    _scanResult = null;
    _errorMessage = null;
    _portionMultiplier = 1.0;
    notifyListeners();
  }
}
