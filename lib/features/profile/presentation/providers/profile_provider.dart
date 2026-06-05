import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../../../core/storage/local_storage_service.dart';

/// Manages user profile data and preferences.
class ProfileProvider extends ChangeNotifier {
  final ProfileRepository _repository = ProfileRepositoryImpl();

  bool _isLoading = false;
  String _displayName = '';
  String _email = '';
  String? _photoUrl;
  double _height = 0;
  double _weight = 0;
  double _targetCalories = 2000;
  List<String> _allergens = [];
  String _dietGoal = 'maintain'; // lose, maintain, gain
  bool _hasConfiguredAllergens = false;

  bool get isLoading => _isLoading;
  String get displayName => _displayName;
  String get email => _email;
  String? get photoUrl => _photoUrl;
  double get height => _height;
  double get weight => _weight;
  double get targetCalories => _targetCalories;
  List<String> get allergens => _allergens;
  String get dietGoal => _dietGoal;
  bool get hasConfiguredAllergens => _hasConfiguredAllergens;
  double get bmi => _height > 0 ? _weight / ((_height / 100) * (_height / 100)) : 0;

  Future<void> loadProfile() async {
    _isLoading = true;
    notifyListeners();

    try {
      final userId = FirebaseAuth.instance.currentUser?.uid ?? 'local_user';

      final profile = await _repository.getProfile(userId);
      _displayName = profile.displayName;
      _email = profile.email;
      _photoUrl = profile.photoUrl;
      _height = profile.height;
      _weight = profile.weight;
      _allergens = profile.allergens;
      _dietGoal = profile.dietGoal;
      _targetCalories = profile.targetCalories;

      final key = 'profile_$userId';
      final data = LocalStorageService.getMap(key);
      _hasConfiguredAllergens = data != null && data.containsKey('allergens');
    } catch (e) {
      debugPrint('Error loading profile: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateProfile({
    String? displayName,
    double? height,
    double? weight,
    double? targetCalories,
    List<String>? allergens,
    String? dietGoal,
  }) async {
    if (displayName != null) _displayName = displayName;
    if (height != null) _height = height;
    if (weight != null) _weight = weight;
    if (targetCalories != null) _targetCalories = targetCalories;
    if (allergens != null) {
      _allergens = allergens;
      _hasConfiguredAllergens = true;
    }
    if (dietGoal != null) _dietGoal = dietGoal;
    
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid ?? 'local_user';
      final data = <String, dynamic>{};
      if (displayName != null) data['displayName'] = displayName;
      if (height != null) data['height'] = height;
      if (weight != null) data['weight'] = weight;
      if (targetCalories != null) data['targetCalories'] = targetCalories;
      if (allergens != null) data['allergens'] = allergens;
      if (dietGoal != null) data['goal'] = dietGoal;
      
      await _repository.updateProfile(userId, data);
    } catch (e) {
      debugPrint('Error updating profile: $e');
    }
    notifyListeners();
  }
}
