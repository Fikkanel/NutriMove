import '../../data/models/user_profile_model.dart';

/// Profile repository interface.
abstract class ProfileRepository {
  Future<UserProfileModel> getProfile(String userId);
  Future<void> updateProfile(String userId, Map<String, dynamic> data);
  Future<void> updateAllergens(String userId, List<String> allergens);
  Future<void> updateDietGoal(String userId, String goal, double targetCalories);
}
