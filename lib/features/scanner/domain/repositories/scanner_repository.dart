import '../../data/models/food_item_model.dart';

/// Scanner repository interface.
abstract class ScannerRepository {
  Future<FoodItemModel> scanFood(String imagePath);
  Future<FoodItemModel> manualInput(Map<String, dynamic> data);
  Future<List<FoodItemModel>> searchFood(String query);
  Future<void> saveMealToLog(FoodItemModel food);
}
