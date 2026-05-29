import '../../domain/repositories/profile_repository.dart';
import '../models/user_profile_model.dart';
import '../../../../core/storage/local_storage_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Offline SharedPreferences-based implementation of ProfileRepository.
class ProfileRepositoryImpl implements ProfileRepository {
  @override
  Future<UserProfileModel> getProfile(String userId) async {
    final key = 'profile_$userId';
    final data = LocalStorageService.getMap(key);
    final user = FirebaseAuth.instance.currentUser;
    final defaultName = user?.displayName ?? 'NutriUser';
    final defaultEmail = user?.email ?? 'user@nutrimove.com';
    
    if (data != null) {
      return UserProfileModel(
        uid: userId,
        displayName: data['displayName'] ?? defaultName,
        email: data['email'] ?? defaultEmail,
        photoUrl: data['photoUrl'] ?? user?.photoURL,
        height: (data['height'] as num?)?.toDouble() ?? 170,
        weight: (data['weight'] as num?)?.toDouble() ?? 65,
        allergens: (data['allergens'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
        targetCalories: (data['targetCalories'] as num?)?.toDouble() ?? 2000,
        dietGoal: data['goal'] ?? 'maintain',
      );
    }
    
    return UserProfileModel(
      uid: userId,
      displayName: defaultName,
      email: defaultEmail,
      photoUrl: user?.photoURL,
      height: 170,
      weight: 65,
      allergens: [],
    );
  }

  @override
  Future<void> updateProfile(String userId, Map<String, dynamic> data) async {
    final key = 'profile_$userId';
    final current = LocalStorageService.getMap(key) ?? {};
    final merged = <String, dynamic>{...current, ...data};
    await LocalStorageService.setMap(key, merged);
  }

  @override
  Future<void> updateAllergens(String userId, List<String> allergens) async {
    await updateProfile(userId, {'allergens': allergens});
  }

  @override
  Future<void> updateDietGoal(String userId, String goal, double targetCalories) async {
    await updateProfile(userId, {'goal': goal, 'targetCalories': targetCalories});
  }
}
