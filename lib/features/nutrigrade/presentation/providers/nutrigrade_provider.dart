import 'package:flutter/material.dart';

/// Manages NutriGrade scoring and allergen warnings.
class NutriGradeProvider extends ChangeNotifier {
  bool _isLoading = false;
  String _currentGrade = '';
  double _score = 0;
  List<String> _allergenWarnings = [];

  bool get isLoading => _isLoading;
  String get currentGrade => _currentGrade;
  double get score => _score;
  List<String> get allergenWarnings => _allergenWarnings;

  Future<void> calculateGrade(Map<String, dynamic> foodData, List<String> userAllergens) async {
    _isLoading = true;
    notifyListeners();

    try {
      double cal = (foodData['calories'] ?? 0).toDouble();
      double pro = (foodData['protein'] ?? 0).toDouble();
      double carb = (foodData['carbs'] ?? 0).toDouble();
      double fat = (foodData['fat'] ?? 0).toDouble();
      
      double proteinScore = (pro / 50.0).clamp(0.0, 1.0) * 40;
      double calScore = cal < 500 ? 20 : (cal < 800 ? 10 : 0);
      double fatScore = fat < 15 ? 20 : (fat < 30 ? 10 : 0);
      double carbScore = carb < 60 ? 20 : (carb < 100 ? 10 : 0);

      _score = proteinScore + calScore + fatScore + carbScore;
      if (_score > 100) _score = 100.0;
      
      _currentGrade = _getGradeFromScore(_score);
      
      _allergenWarnings = [];
      String name = (foodData['name'] ?? '').toString().toLowerCase();
      for (var allergen in userAllergens) {
        if (name.contains(allergen.toLowerCase())) {
          _allergenWarnings.add("Peringatan: Mengandung $allergen");
        }
      }
    } catch (e) {
      debugPrint('Error calculating grade: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  String _getGradeFromScore(double score) {
    if (score >= 80) return 'A';
    if (score >= 60) return 'B';
    if (score >= 40) return 'C';
    return 'D';
  }
}
