# Project Handover — NutriMove

> **Date:** 2026-05-15 | **From:** AI Dev Team | **To:** Development Team

## 1. Project Overview

NutriMove adalah aplikasi asisten nutrisi berbasis Flutter yang sudah **fully functional** untuk demo. Semua UI, state management, routing, dan arsitektur sudah diimplementasikan.

## 2. Deliverables

| Item | Status | Notes |
|---|---|---|
| Source Code | ✅ Complete | 75+ Dart files, clean architecture |
| Design System | ✅ Complete | Dark theme, Material 3 |
| Navigation | ✅ Complete | GoRouter, 20 routes |
| State Management | ✅ Complete | 7 providers |
| Fuzzy AHP Engine | ✅ Complete | Tested |
| TOPSIS Engine | ✅ Complete | Tested |
| Unit Tests | ✅ Complete | Auth, AHP, TOPSIS, Gamification |
| Documentation | ✅ Complete | 13 docs |
| Firebase Integration | ⏳ Pending | Requires Firebase Console |
| TFLite Model | ⏳ Pending | Requires trained model |

## 3. Pending Items

### 3.1 Firebase Configuration
1. Buat project di Firebase Console
2. Download `google-services.json` (Android)
3. Download `GoogleService-Info.plist` (iOS)
4. Tambahkan `firebase_core`, `firebase_auth`, `cloud_firestore` ke pubspec.yaml
5. Replace TODO stubs di semua repository implementations

### 3.2 AI Model
1. Train/obtain TFLite food recognition model
2. Place at `assets/models/food_model.tflite`
3. Update `TFLiteService` di `lib/features/scanner/data/services/tflite_service.dart`

### 3.3 NutriBot API
1. Get Gemini API key
2. Update `NutribotService` di `lib/features/nutribot/data/services/nutribot_service.dart`

## 4. How to Run

```bash
cd nutrimove
flutter pub get
flutter run -d chrome    # Web
flutter run              # Mobile (requires device/emulator)
flutter test             # Run tests
flutter analyze          # Code analysis
```

## 5. Known Issues

| Issue | Severity | Workaround |
|---|---|---|
| Hot restart provider error | Low | Refresh browser (F5) |
| Splash delay 3s on web | Low | Normal behavior |
| Firebase not configured | High | Use demo mode (current) |

## 6. Recommended Next Steps

1. Firebase integration (highest priority)
2. TFLite model integration
3. Gemini API for NutriBot
4. Play Store / App Store submission
5. Automated CI/CD pipeline
