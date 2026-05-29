class UserModel {
  final String uid;
  final String email;
  final String displayName;
  final String? photoUrl;
  final double height;
  final double weight;
  final double targetCalories;
  final List<String> allergens;
  final String dietGoal;
  final DateTime createdAt;
  final bool isNewUser;

  UserModel({
    required this.uid,
    required this.email,
    required this.displayName,
    this.photoUrl,
    this.height = 0,
    this.weight = 0,
    this.targetCalories = 2000,
    this.allergens = const [],
    this.dietGoal = 'maintain',
    this.isNewUser = false,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  double get bmi => height > 0 ? weight / ((height / 100) * (height / 100)) : 0;

  Map<String, dynamic> toMap() => {
    'uid': uid,
    'email': email,
    'displayName': displayName,
    'photoUrl': photoUrl,
    'height': height,
    'weight': weight,
    'targetCalories': targetCalories,
    'allergens': allergens,
    'dietGoal': dietGoal,
    'createdAt': createdAt.toIso8601String(),
  };

  factory UserModel.fromMap(Map<String, dynamic> map) => UserModel(
    uid: map['uid'] ?? '',
    email: map['email'] ?? '',
    displayName: map['displayName'] ?? '',
    photoUrl: map['photoUrl'],
    height: (map['height'] ?? 0).toDouble(),
    weight: (map['weight'] ?? 0).toDouble(),
    targetCalories: (map['targetCalories'] ?? 2000).toDouble(),
    allergens: List<String>.from(map['allergens'] ?? []),
    dietGoal: map['dietGoal'] ?? 'maintain',
    createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
  );

  UserModel copyWith({
    String? displayName,
    String? photoUrl,
    double? height,
    double? weight,
    double? targetCalories,
    List<String>? allergens,
    String? dietGoal,
  }) => UserModel(
    uid: uid,
    email: email,
    displayName: displayName ?? this.displayName,
    photoUrl: photoUrl ?? this.photoUrl,
    height: height ?? this.height,
    weight: weight ?? this.weight,
    targetCalories: targetCalories ?? this.targetCalories,
    allergens: allergens ?? this.allergens,
    dietGoal: dietGoal ?? this.dietGoal,
    createdAt: createdAt,
  );
}
