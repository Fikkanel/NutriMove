# Architecture — NutriMove

## Clean Architecture

NutriMove mengimplementasikan **Clean Architecture** dengan pembagian layer:

```
┌─────────────────────────────────────────────────┐
│              Presentation Layer                  │
│  (Screens, Widgets, Providers)                   │
├─────────────────────────────────────────────────┤
│                Domain Layer                      │
│  (Repositories Interface, Use Cases, Engines)    │
├─────────────────────────────────────────────────┤
│                 Data Layer                       │
│  (Models, Repository Impl, Services)             │
└─────────────────────────────────────────────────┘
```

## Feature Module Structure

Setiap feature mengikuti pola:

```
features/{feature_name}/
├── data/
│   ├── models/            # Data models (Firestore serialization)
│   ├── repositories/      # Repository implementations
│   └── services/          # External service integrations
├── domain/
│   ├── repositories/      # Repository interfaces (contracts)
│   ├── usecases/          # Business logic use cases
│   └── engines/           # Algorithm engines (AHP, TOPSIS)
└── presentation/
    ├── providers/          # State management (ChangeNotifier)
    ├── screens/            # Full page widgets
    └── widgets/            # Feature-specific widgets
```

## Navigation Architecture

```
GoRouter
├── Auth Routes (no bottom nav)
│   ├── /splash          → SplashScreen
│   ├── /onboarding      → OnboardingScreen
│   ├── /login           → LoginScreen
│   ├── /register        → RegisterScreen
│   ├── /forgot-password → ForgotPasswordScreen
│   └── /profile-setup   → ProfileSetupScreen
│
├── ShellRoute (with BottomNavBar)
│   ├── /home    → HomeScreen
│   ├── /scan    → CameraScreen
│   ├── /chat    → ChatScreen
│   └── /profile → ProfileScreen
│
└── Detail Routes (pushed on top)
    ├── /scan/result      → ScanResultScreen
    ├── /scan/manual      → ManualInputScreen
    ├── /food/:id         → FoodDetailScreen
    ├── /recommendations  → RecommendationScreen
    ├── /reports          → WeeklyReportScreen
    ├── /achievements     → AchievementsScreen
    └── /settings         → SettingsScreen
```

## Decision Engine Architecture

### Fuzzy AHP (Criteria Weighting)

```
Input: Pairwise comparison matrix (6 criteria)
  ↓
Step 1: Triangular Fuzzy Numbers (TFN)
  ↓
Step 2: Fuzzy Geometric Mean per criterion
  ↓
Step 3: Center of Area Defuzzification
  ↓
Output: Normalized weights {protein: 0.28, fiber: 0.22, ...}
```

### TOPSIS (Food Ranking)

```
Input: Food alternatives + AHP weights
  ↓
Step 1: Normalize decision matrix
  ↓
Step 2: Apply weighted normalization
  ↓
Step 3: Determine ideal best (A+) & worst (A-)
  ↓
Step 4: Calculate Euclidean distances
  ↓
Step 5: Relative closeness score → Grade (A/B/C/D)
```

## State Management

Provider pattern digunakan dengan `MultiProvider` di root:

| Provider | Scope | Responsibility |
|---|---|---|
| AuthProvider | Global | Auth lifecycle, user state |
| DashboardProvider | Global | Daily nutrition tracking |
| ScannerProvider | Global | Scan workflow & results |
| NutriGradeProvider | Global | Grade calculation |
| GamificationProvider | Global | Streak & achievements |
| NutribotProvider | Global | Chat messages |
| ProfileProvider | Global | User profile data |
