# Environment Setup — NutriMove

## Prerequisites

| Requirement | Version |
|---|---|
| Flutter SDK | 3.41.1+ |
| Dart SDK | 3.11.0+ |
| Android Studio | Latest |
| Xcode (macOS) | Latest |
| Firebase CLI | Latest |
| Node.js | 18+ (for Firebase) |

## Installation

### 1. Flutter SDK

```bash
# Verify installation
flutter doctor

# Path yang digunakan di project ini:
# C:\FIKKAN\FLUTTER\flutter
```

### 2. Clone & Dependencies

```bash
cd nutrimove
flutter pub get
```

### 3. Firebase Setup

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login
firebase login

# Initialize Firebase project
firebase init

# Add platforms
flutterfire configure
```

### 4. Required Files

| File | Platform | How to get |
|---|---|---|
| `android/app/google-services.json` | Android | Firebase Console → Project Settings → Android app |
| `ios/Runner/GoogleService-Info.plist` | iOS | Firebase Console → Project Settings → iOS app |

### 5. Environment Variables

Variables defined via `--dart-define`:

```bash
flutter run \
  --dart-define=ENV=dev \
  --dart-define=FIREBASE_API_KEY=your_key \
  --dart-define=GEMINI_API_KEY=your_key
```

| Variable | Description | Default |
|---|---|---|
| `ENV` | Environment (dev/staging/prod) | dev |
| `FIREBASE_API_KEY` | Firebase Web API Key | - |
| `GEMINI_API_KEY` | Gemini API Key for NutriBot | - |
| `ENABLE_DEBUG_BANNER` | Show debug banner | true |

### 6. TFLite Model

Place food recognition model at:
```
assets/models/food_model.tflite
assets/models/food_labels.txt
```

## Run Commands

```bash
# Development
flutter run

# Web (Chrome)
flutter run -d chrome

# Release build (Android)
flutter build apk --release

# Release build (iOS)
flutter build ios --release

# Run tests
flutter test

# Analyze code
flutter analyze
```
