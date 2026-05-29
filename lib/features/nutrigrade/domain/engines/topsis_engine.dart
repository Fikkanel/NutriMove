import 'dart:math';

/// TOPSIS Engine for food recommendation ranking.
///
/// Technique for Order of Preference by Similarity to Ideal Solution.
/// Ranks food alternatives based on weighted nutrition criteria.
class TOPSISEngine {
  /// Rank food alternatives using TOPSIS method.
  ///
  /// [alternatives] — List of food items, each a map of criteria -> value.
  /// [weights] — Criteria weights from Fuzzy AHP (sum = 1).
  /// [benefitCriteria] — Criteria where higher is better (e.g., protein, fiber).
  /// [costCriteria] — Criteria where lower is better (e.g., sugar, sodium).
  ///
  /// Returns list of (index, score) sorted by score descending.
  static List<RankedAlternative> rank({
    required List<Map<String, double>> alternatives,
    required Map<String, double> weights,
    List<String> benefitCriteria = const ['protein', 'fiber', 'vitamins'],
    List<String> costCriteria = const ['sugar', 'sodium', 'saturatedFat'],
  }) {
    if (alternatives.isEmpty) return [];

    final allCriteria = [...benefitCriteria, ...costCriteria];
    final n = alternatives.length;

    // Step 1: Normalize the decision matrix
    final Map<String, double> norms = {};
    for (final criterion in allCriteria) {
      double sumSquares = 0;
      for (final alt in alternatives) {
        final val = alt[criterion] ?? 0;
        sumSquares += val * val;
      }
      norms[criterion] = sqrt(sumSquares);
    }

    final List<Map<String, double>> normalized = [];
    for (final alt in alternatives) {
      final Map<String, double> normAlt = {};
      for (final criterion in allCriteria) {
        final norm = norms[criterion]!;
        normAlt[criterion] = norm > 0 ? (alt[criterion] ?? 0) / norm : 0;
      }
      normalized.add(normAlt);
    }

    // Step 2: Weighted normalized matrix
    final List<Map<String, double>> weighted = [];
    for (final normAlt in normalized) {
      final Map<String, double> wAlt = {};
      for (final criterion in allCriteria) {
        wAlt[criterion] = normAlt[criterion]! * (weights[criterion] ?? 0);
      }
      weighted.add(wAlt);
    }

    // Step 3: Determine ideal best (A+) and ideal worst (A-)
    final Map<String, double> idealBest = {};
    final Map<String, double> idealWorst = {};

    for (final criterion in allCriteria) {
      final values = weighted.map((w) => w[criterion]!).toList();
      if (benefitCriteria.contains(criterion)) {
        idealBest[criterion] = values.reduce(max);
        idealWorst[criterion] = values.reduce(min);
      } else {
        idealBest[criterion] = values.reduce(min);
        idealWorst[criterion] = values.reduce(max);
      }
    }

    // Step 4: Calculate separation measures
    final List<double> dPlus = [];
    final List<double> dMinus = [];

    for (final wAlt in weighted) {
      double sumPlus = 0, sumMinus = 0;
      for (final criterion in allCriteria) {
        sumPlus += pow(wAlt[criterion]! - idealBest[criterion]!, 2);
        sumMinus += pow(wAlt[criterion]! - idealWorst[criterion]!, 2);
      }
      dPlus.add(sqrt(sumPlus));
      dMinus.add(sqrt(sumMinus));
    }

    // Step 5: Calculate relative closeness to ideal solution
    final List<RankedAlternative> results = [];
    for (int i = 0; i < n; i++) {
      final total = dPlus[i] + dMinus[i];
      final score = total > 0 ? dMinus[i] / total : 0.0;
      results.add(RankedAlternative(index: i, score: score));
    }

    // Sort by score descending (higher = better)
    results.sort((a, b) => b.score.compareTo(a.score));

    return results;
  }
}

class RankedAlternative {
  final int index;
  final double score;

  RankedAlternative({required this.index, required this.score});

  /// Convert score to NutriGrade (A-D)
  String get grade {
    if (score >= 0.75) return 'A';
    if (score >= 0.50) return 'B';
    if (score >= 0.25) return 'C';
    return 'D';
  }
}
