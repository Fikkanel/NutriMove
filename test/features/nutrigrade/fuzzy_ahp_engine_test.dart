import 'package:flutter_test/flutter_test.dart';
import 'package:nutrimove/features/nutrigrade/domain/engines/fuzzy_ahp_engine.dart';

void main() {
  group('FuzzyAHPEngine', () {
    test('calculateWeights returns weights for all 6 criteria', () {
      final weights = FuzzyAHPEngine.calculateWeights();
      expect(weights.length, 6);
      expect(weights.containsKey('protein'), isTrue);
      expect(weights.containsKey('fiber'), isTrue);
      expect(weights.containsKey('vitamins'), isTrue);
      expect(weights.containsKey('sugar'), isTrue);
      expect(weights.containsKey('sodium'), isTrue);
      expect(weights.containsKey('saturatedFat'), isTrue);
    });

    test('weights sum to approximately 1.0', () {
      final weights = FuzzyAHPEngine.calculateWeights();
      final sum = weights.values.reduce((a, b) => a + b);
      expect(sum, closeTo(1.0, 0.001));
    });

    test('protein has highest weight (most important criterion)', () {
      final weights = FuzzyAHPEngine.calculateWeights();
      final maxEntry = weights.entries.reduce((a, b) => a.value > b.value ? a : b);
      expect(maxEntry.key, 'protein');
    });

    test('all weights are positive', () {
      final weights = FuzzyAHPEngine.calculateWeights();
      for (final w in weights.values) {
        expect(w, greaterThan(0));
      }
    });

    test('consistency check returns true', () {
      expect(FuzzyAHPEngine.isConsistent(), isTrue);
    });
  });
}
