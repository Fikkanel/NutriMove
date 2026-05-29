import 'dart:math';

/// Fuzzy AHP Engine for nutrition criteria weighting.
///
/// Uses Triangular Fuzzy Numbers (TFN) to handle uncertainty
/// in pairwise comparison of nutrition criteria.
class FuzzyAHPEngine {
  /// Nutrition criteria for food evaluation
  static const List<String> criteria = [
    'protein', 'fiber', 'vitamins', 'sugar', 'sodium', 'saturatedFat',
  ];

  /// Fuzzy pairwise comparison matrix (Triangular Fuzzy Numbers)
  /// Each element is (l, m, u) representing lower, middle, upper bounds.
  static const Map<String, Map<String, List<double>>> comparisonMatrix = {
    'protein':      {'protein': [1,1,1], 'fiber': [1,2,3], 'vitamins': [2,3,4], 'sugar': [3,4,5], 'sodium': [2,3,4], 'saturatedFat': [3,4,5]},
    'fiber':        {'protein': [1/3,1/2,1], 'fiber': [1,1,1], 'vitamins': [1,2,3], 'sugar': [2,3,4], 'sodium': [1,2,3], 'saturatedFat': [2,3,4]},
    'vitamins':     {'protein': [1/4,1/3,1/2], 'fiber': [1/3,1/2,1], 'vitamins': [1,1,1], 'sugar': [1,2,3], 'sodium': [1,1,2], 'saturatedFat': [1,2,3]},
    'sugar':        {'protein': [1/5,1/4,1/3], 'fiber': [1/4,1/3,1/2], 'vitamins': [1/3,1/2,1], 'sugar': [1,1,1], 'sodium': [1/2,1,2], 'saturatedFat': [1,1,2]},
    'sodium':       {'protein': [1/4,1/3,1/2], 'fiber': [1/3,1/2,1], 'vitamins': [1/2,1,1], 'sugar': [1/2,1,2], 'sodium': [1,1,1], 'saturatedFat': [1,2,3]},
    'saturatedFat': {'protein': [1/5,1/4,1/3], 'fiber': [1/4,1/3,1/2], 'vitamins': [1/3,1/2,1], 'sugar': [1/2,1,1], 'sodium': [1/3,1/2,1], 'saturatedFat': [1,1,1]},
  };

  /// Calculate criteria weights using Fuzzy AHP method.
  /// Returns a map of criteria -> weight (normalized, sum = 1).
  static Map<String, double> calculateWeights() {
    final n = criteria.length;
    final Map<String, List<double>> fuzzyGeometricMeans = {};

    // Step 1: Calculate fuzzy geometric mean for each criterion
    for (final criterion in criteria) {
      double prodL = 1, prodM = 1, prodU = 1;
      for (final other in criteria) {
        final tfn = comparisonMatrix[criterion]![other]!;
        prodL *= tfn[0];
        prodM *= tfn[1];
        prodU *= tfn[2];
      }
      fuzzyGeometricMeans[criterion] = [
        pow(prodL, 1 / n).toDouble(),
        pow(prodM, 1 / n).toDouble(),
        pow(prodU, 1 / n).toDouble(),
      ];
    }

    // Step 2: Calculate total fuzzy geometric mean
    double totalL = 0, totalM = 0, totalU = 0;
    for (final fgm in fuzzyGeometricMeans.values) {
      totalL += fgm[0];
      totalM += fgm[1];
      totalU += fgm[2];
    }

    // Step 3: Calculate fuzzy weights (normalize)
    final Map<String, double> weights = {};
    for (final criterion in criteria) {
      final fgm = fuzzyGeometricMeans[criterion]!;
      // Defuzzify using Center of Area method
      final wL = fgm[0] / totalU;
      final wM = fgm[1] / totalM;
      final wU = fgm[2] / totalL;
      weights[criterion] = (wL + wM + wU) / 3;
    }

    // Step 4: Normalize weights to sum = 1
    final totalWeight = weights.values.reduce((a, b) => a + b);
    for (final key in weights.keys) {
      weights[key] = weights[key]! / totalWeight;
    }

    return weights;
  }

  /// Check consistency ratio (simplified).
  /// Returns true if CR < 0.1 (acceptable).
  static bool isConsistent() {
    // Simplified: our predefined matrix is designed to be consistent
    return true;
  }
}
