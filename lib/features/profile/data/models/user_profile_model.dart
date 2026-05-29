class UserProfileModel {
  final String uid;
  final String displayName;
  final String email;
  final String? photoUrl;
  final double height;
  final double weight;
  final double targetCalories;
  final double targetProtein;
  final double targetCarbs;
  final double targetFat;
  final List<String> allergens;
  final String dietGoal;
  final bool notificationsEnabled;
  final String language;

  UserProfileModel({
    required this.uid, required this.displayName, required this.email,
    this.photoUrl, this.height = 0, this.weight = 0,
    this.targetCalories = 2000, this.targetProtein = 50,
    this.targetCarbs = 250, this.targetFat = 65,
    this.allergens = const [], this.dietGoal = 'maintain',
    this.notificationsEnabled = true, this.language = 'id',
  });

  double get bmi => height > 0 ? weight / ((height / 100) * (height / 100)) : 0;
  String get bmiCategory {
    if (bmi < 18.5) return 'Underweight';
    if (bmi < 25) return 'Normal';
    if (bmi < 30) return 'Overweight';
    return 'Obese';
  }

  Map<String, dynamic> toMap() => {
    'uid': uid, 'displayName': displayName, 'email': email, 'photoUrl': photoUrl,
    'height': height, 'weight': weight, 'targetCalories': targetCalories,
    'targetProtein': targetProtein, 'targetCarbs': targetCarbs, 'targetFat': targetFat,
    'allergens': allergens, 'dietGoal': dietGoal,
    'notificationsEnabled': notificationsEnabled, 'language': language,
  };

  factory UserProfileModel.fromMap(Map<String, dynamic> map) => UserProfileModel(
    uid: map['uid'] ?? '', displayName: map['displayName'] ?? '', email: map['email'] ?? '',
    photoUrl: map['photoUrl'], height: (map['height'] ?? 0).toDouble(),
    weight: (map['weight'] ?? 0).toDouble(), targetCalories: (map['targetCalories'] ?? 2000).toDouble(),
    targetProtein: (map['targetProtein'] ?? 50).toDouble(),
    targetCarbs: (map['targetCarbs'] ?? 250).toDouble(),
    targetFat: (map['targetFat'] ?? 65).toDouble(),
    allergens: List<String>.from(map['allergens'] ?? []),
    dietGoal: map['dietGoal'] ?? 'maintain',
    notificationsEnabled: map['notificationsEnabled'] ?? true,
    language: map['language'] ?? 'id',
  );
}
