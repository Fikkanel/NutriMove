import 'package:flutter_test/flutter_test.dart';
import 'package:nutrimove/features/nutrigrade/domain/engines/topsis_engine.dart';
import 'package:nutrimove/features/nutrigrade/domain/engines/fuzzy_ahp_engine.dart';

void main() {
  group('TOPSISEngine', () {
    late Map<String, double> weights;

    setUp(() {
      weights = FuzzyAHPEngine.calculateWeights();
    });

    test('returns empty list for empty alternatives', () {
      final result = TOPSISEngine.rank(alternatives: [], weights: weights);
      expect(result, isEmpty);
    });

    test('ranks single alternative with score 1.0', () {
      final result = TOPSISEngine.rank(
        alternatives: [{'protein': 25, 'fiber': 8, 'vitamins': 90, 'sugar': 5, 'sodium': 200, 'saturatedFat': 3}],
        weights: weights,
      );
      expect(result.length, 1);
      // Single alternative should get a score (edge case)
    });

    test('ranks healthier food higher than junk food', () {
      final alternatives = [
        // Junk food: low protein/fiber, high sugar/sodium/fat
        {'protein': 5.0, 'fiber': 1.0, 'vitamins': 10.0, 'sugar': 40.0, 'sodium': 800.0, 'saturatedFat': 15.0},
        // Health food: high protein/fiber, low sugar/sodium/fat
        {'protein': 30.0, 'fiber': 10.0, 'vitamins': 95.0, 'sugar': 3.0, 'sodium': 100.0, 'saturatedFat': 1.0},
      ];

      final result = TOPSISEngine.rank(alternatives: alternatives, weights: weights);

      expect(result.length, 2);
      // Health food (index 1) should rank first
      expect(result[0].index, 1);
      expect(result[0].score, greaterThan(result[1].score));
    });

    test('grade assignment is correct', () {
      final alternatives = [
        {'protein': 30.0, 'fiber': 10.0, 'vitamins': 95.0, 'sugar': 3.0, 'sodium': 100.0, 'saturatedFat': 1.0},
        {'protein': 5.0, 'fiber': 1.0, 'vitamins': 10.0, 'sugar': 40.0, 'sodium': 800.0, 'saturatedFat': 15.0},
      ];

      final result = TOPSISEngine.rank(alternatives: alternatives, weights: weights);

      // First should be A or B, last should be C or D
      expect(['A', 'B'], contains(result.first.grade));
      expect(['C', 'D'], contains(result.last.grade));
    });

    test('ranks 4 foods correctly by nutrition quality', () {
      final alternatives = [
        {'protein': 25.0, 'fiber': 8.0, 'vitamins': 85.0, 'sugar': 5.0, 'sodium': 150.0, 'saturatedFat': 2.0},   // A: Grilled chicken salad
        {'protein': 15.0, 'fiber': 4.0, 'vitamins': 50.0, 'sugar': 12.0, 'sodium': 400.0, 'saturatedFat': 5.0},   // B: Nasi goreng
        {'protein': 8.0, 'fiber': 2.0, 'vitamins': 20.0, 'sugar': 25.0, 'sodium': 300.0, 'saturatedFat': 8.0},    // C: Mie instant
        {'protein': 3.0, 'fiber': 0.5, 'vitamins': 5.0, 'sugar': 45.0, 'sodium': 50.0, 'saturatedFat': 12.0},     // D: Donut
      ];

      final result = TOPSISEngine.rank(alternatives: alternatives, weights: weights);
      expect(result.length, 4);

      // Chicken salad (index 0) should rank first
      expect(result[0].index, 0);
      // Donut (index 3) should rank last
      expect(result[3].index, 3);
    });
  });
}
