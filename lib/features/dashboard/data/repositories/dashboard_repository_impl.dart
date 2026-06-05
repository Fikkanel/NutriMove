import 'package:intl/intl.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../models/daily_log_model.dart';
import '../models/nutrition_summary_model.dart';
import '../../../scanner/data/models/food_item_model.dart';
import '../../../../core/storage/local_storage_service.dart';

// Implementasi repositori dashboard offline berbasis SharedPreferences.
class DashboardRepositoryImpl implements DashboardRepository {
  String _getTodayString() => DateFormat('yyyy-MM-dd').format(DateTime.now());

  @override
  // Mengambil ringkasan total kalori dan makronutrisi hari ini dari penyimpanan lokal
  @override
  Future<DailyLogModel> getTodayLog(String userId) async {
    final today = _getTodayString();
    final key = 'dashboard_log_${userId}_$today';
    final data = LocalStorageService.getMap(key);

    if (data != null) {
      return DailyLogModel(
        id: today,
        date: DateTime.now(),
        totalCalories: (data['totalCalories'] as num?)?.toDouble() ?? 0,
        totalProtein: (data['totalProtein'] as num?)?.toDouble() ?? 0,
        totalCarbs: (data['totalCarbs'] as num?)?.toDouble() ?? 0,
        totalFat: (data['totalFat'] as num?)?.toDouble() ?? 0,
      );
    }
    
    return DailyLogModel(id: today, date: DateTime.now(), totalCalories: 0, totalProtein: 0, totalCarbs: 0, totalFat: 0);
  }

  @override
  // Membaca semua daftar makanan yang dikonsumsi hari ini dari penyimpanan lokal
  @override
  Future<List<Map<String, dynamic>>> getTodayMeals(String userId) async {
    final today = _getTodayString();
    final key = 'dashboard_meals_${userId}_$today';
    final list = LocalStorageService.getList(key);
    if (list != null) {
      return list.map((item) => Map<String, dynamic>.from(item)).toList();
    }
    return [];
  }

  @override
  // Menyimpan makanan baru ke log harian, mengakumulasikan total nutrisi, dan mengupdate streak
  @override
  Future<void> addMeal(String userId, FoodItemModel meal) async {
    final today = _getTodayString();
    final logKey = 'dashboard_log_${userId}_$today';
    final mealsKey = 'dashboard_meals_${userId}_$today';

    // 1. Hitung dan perbarui akumulasi total gizi harian
    final currentLog = await getTodayLog(userId);
    final double calories = currentLog.totalCalories + meal.calories;
    final double protein = currentLog.totalProtein + meal.protein;
    final double carbs = currentLog.totalCarbs + meal.carbs;
    final double fat = currentLog.totalFat + meal.fat;

    await LocalStorageService.setMap(logKey, {
      'totalCalories': calories,
      'totalProtein': protein,
      'totalCarbs': carbs,
      'totalFat': fat,
      'lastUpdated': DateTime.now().toIso8601String(),
    });

    // 2. Tambahkan makanan ke dalam daftar log harian
    final meals = await getTodayMeals(userId);
    final mealGrade = meal.grade.isNotEmpty ? meal.grade : 'B';
    if (mealGrade.toUpperCase() == 'A') {
      final key = 'gamification_grade_a_$userId';
      final current = LocalStorageService.getInt(key) ?? 0;
      await LocalStorageService.setInt(key, current + 1);
    }

    meals.insert(0, {
      'name': meal.name,
      'calories': meal.calories,
      'protein': meal.protein,
      'carbs': meal.carbs,
      'fat': meal.fat,
      'grade': mealGrade,
      'timestamp': DateTime.now().toIso8601String(),
    });

    await LocalStorageService.setList(mealsKey, meals);
  }

  @override
  // Memperbarui kandungan nutrisi makanan yang telah dicatat dan menghitung ulang total harian
  @override
  Future<void> updateMeal(String userId, int index, Map<String, dynamic> updatedMeal) async {
    final today = _getTodayString();
    final logKey = 'dashboard_log_${userId}_$today';
    final mealsKey = 'dashboard_meals_${userId}_$today';

    final meals = await getTodayMeals(userId);
    if (index < 0 || index >= meals.length) return;

    final oldMeal = meals[index];
    final oldGrade = (oldMeal['grade'] ?? 'B').toString().toUpperCase();
    final newGrade = (updatedMeal['grade'] ?? 'B').toString().toUpperCase();

    if (oldGrade != 'A' && newGrade == 'A') {
      final key = 'gamification_grade_a_$userId';
      final current = LocalStorageService.getInt(key) ?? 0;
      await LocalStorageService.setInt(key, current + 1);
    } else if (oldGrade == 'A' && newGrade != 'A') {
      final key = 'gamification_grade_a_$userId';
      final current = LocalStorageService.getInt(key) ?? 0;
      await LocalStorageService.setInt(key, (current - 1).clamp(0, 999999));
    }

    // Pertahankan waktu (timestamp) asli makanan
    updatedMeal['timestamp'] = meals[index]['timestamp'];
    meals[index] = updatedMeal;

    await LocalStorageService.setList(mealsKey, meals);

    // Hitung ulang total gizi dari semua makanan yang tersisa
    await _recalculateDailyTotals(logKey, meals);
  }

  @override
  // Menghapus data makanan dari log hari ini dan menghitung ulang total asupan gizi
  @override
  Future<void> deleteMeal(String userId, int index) async {
    final today = _getTodayString();
    final logKey = 'dashboard_log_${userId}_$today';
    final mealsKey = 'dashboard_meals_${userId}_$today';

    final meals = await getTodayMeals(userId);
    if (index < 0 || index >= meals.length) return;

    final deletedMeal = meals[index];
    final deletedGrade = (deletedMeal['grade'] ?? 'B').toString().toUpperCase();
    if (deletedGrade == 'A') {
      final key = 'gamification_grade_a_$userId';
      final current = LocalStorageService.getInt(key) ?? 0;
      await LocalStorageService.setInt(key, (current - 1).clamp(0, 999999));
    }

    meals.removeAt(index);
    await LocalStorageService.setList(mealsKey, meals);

    // Hitung ulang total gizi dari makanan yang tersisa
    await _recalculateDailyTotals(logKey, meals);
  }

  Future<void> _recalculateDailyTotals(String logKey, List<Map<String, dynamic>> meals) async {
    double totalCal = 0, totalPro = 0, totalCarb = 0, totalFat = 0;
    for (final m in meals) {
      totalCal += (m['calories'] as num?)?.toDouble() ?? 0;
      totalPro += (m['protein'] as num?)?.toDouble() ?? 0;
      totalCarb += (m['carbs'] as num?)?.toDouble() ?? 0;
      totalFat += (m['fat'] as num?)?.toDouble() ?? 0;
    }
    await LocalStorageService.setMap(logKey, {
      'totalCalories': totalCal,
      'totalProtein': totalPro,
      'totalCarbs': totalCarb,
      'totalFat': totalFat,
      'lastUpdated': DateTime.now().toIso8601String(),
    });
  }

  @override
  Future<NutritionSummaryModel> getWeeklySummary(String userId) async {
    final logs = await getLogHistory(userId, 7);
    double tCal = 0, tPro = 0, tCarb = 0, tFat = 0;
    int logged = 0;
    for (var log in logs) {
      if (log.totalCalories > 0) {
        logged++;
        tCal += log.totalCalories;
        tPro += log.totalProtein;
        tCarb += log.totalCarbs;
        tFat += log.totalFat;
      }
    }
    
    final now = DateTime.now();
    return NutritionSummaryModel(
      startDate: now.subtract(const Duration(days: 7)),
      endDate: now,
      avgCalories: logged > 0 ? tCal / logged : 0,
      avgProtein: logged > 0 ? tPro / logged : 0,
      avgCarbs: logged > 0 ? tCarb / logged : 0,
      avgFat: logged > 0 ? tFat / logged : 0,
      totalMeals: 0,
      daysLogged: logged,
    );
  }

  @override
  Future<List<DailyLogModel>> getLogHistory(String userId, int days) async {
    final now = DateTime.now();
    List<DailyLogModel> history = [];
    
    for (int i = days - 1; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dateStr = DateFormat('yyyy-MM-dd').format(date);
      final logKey = 'dashboard_log_${userId}_$dateStr';
      final data = LocalStorageService.getMap(logKey);

      if (data != null) {
        history.add(DailyLogModel(
          id: dateStr,
          date: date,
          totalCalories: (data['totalCalories'] as num?)?.toDouble() ?? 0,
          totalProtein: (data['totalProtein'] as num?)?.toDouble() ?? 0,
          totalCarbs: (data['totalCarbs'] as num?)?.toDouble() ?? 0,
          totalFat: (data['totalFat'] as num?)?.toDouble() ?? 0,
        ));
      } else {
        history.add(DailyLogModel(id: dateStr, date: date, totalCalories: 0, totalProtein: 0, totalCarbs: 0, totalFat: 0));
      }
    }
    
    return history;
  }
}
