class AllergenProfileModel {
  final List<String> userAllergens;
  final List<AllergenMatch> detectedAllergens;

  AllergenProfileModel({
    required this.userAllergens,
    this.detectedAllergens = const [],
  });

  bool get hasDanger => detectedAllergens.any((a) => a.severity == AllergenSeverity.high);
  bool get hasWarning => detectedAllergens.isNotEmpty;

  Map<String, dynamic> toMap() => {
    'userAllergens': userAllergens,
    'detectedAllergens': detectedAllergens.map((a) => a.toMap()).toList(),
  };
}

class AllergenMatch {
  final String name;
  final AllergenSeverity severity;
  final String source;

  AllergenMatch({required this.name, required this.severity, required this.source});

  Map<String, dynamic> toMap() => {
    'name': name, 'severity': severity.name, 'source': source,
  };
}

enum AllergenSeverity { low, medium, high }
