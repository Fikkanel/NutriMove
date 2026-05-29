# NutriMove — Smart Nutrition Assistant

> **Version:** 1.0.0
> **Platform:** Android & iOS (Flutter)
> **Architecture:** Clean Architecture + Provider

## 📋 Deskripsi

NutriMove adalah aplikasi mobile asisten diet pintar yang mengintegrasikan **AI Computer Vision** untuk food scanning, **Fuzzy AHP-TOPSIS** untuk rekomendasi menu berbasis nutrisi, dan **gamifikasi** untuk mendorong kebiasaan makan sehat.

## ✨ Fitur Utama

| Fitur | Deskripsi |
|---|---|
| 📷 **AI Food Scanner** | Scan makanan menggunakan kamera → identifikasi otomatis + estimasi nutrisi |
| ⭐ **NutriGrade (A-D)** | Penilaian kualitas nutrisi makanan menggunakan Fuzzy AHP + TOPSIS |
| 📊 **Dashboard Personal** | Tracking kalori harian, macronutrient (protein/karbo/lemak) |
| 🔥 **Daily Streak** | Gamifikasi streak harian + achievement badges |
| 🤖 **NutriBot** | Chatbot AI untuk konsultasi nutrisi |
| ⚠️ **Allergen Alert** | Peringatan otomatis untuk alergi pengguna |
| 📈 **Rekomendasi Menu** | Rekomendasi makanan sehat berbasis TOPSIS ranking |

## 🚀 Quick Start

```bash
# Clone & install
cd nutrimove
flutter pub get

# Run (mobile)
flutter run

# Run (web/testing)
flutter run -d chrome

# Run tests
flutter test
```

## 🏗️ Tech Stack

- **Flutter** 3.41.1 (Dart 3.11.0)
- **State Management:** Provider
- **Routing:** GoRouter
- **Backend:** Firebase (Auth, Firestore, Storage)
- **AI/CV:** TensorFlow Lite (on-device)
- **Decision System:** Fuzzy AHP + TOPSIS

## 📁 Folder Structure

```
lib/
├── main.dart                   # Entry point
├── app.dart                    # MaterialApp.router
├── core/                       # Shared infrastructure
│   ├── config/                 # Environment config
│   ├── constants/              # App constants
│   ├── providers/              # Provider registration
│   ├── router/                 # GoRouter routes
│   └── theme/                  # Design system (colors, typography, theme)
├── features/                   # Feature modules (Clean Architecture)
│   ├── auth/                   # Authentication
│   ├── dashboard/              # Home dashboard
│   ├── scanner/                # AI Food Scanner
│   ├── nutrigrade/             # NutriGrade system + engines
│   ├── gamification/           # Streak + achievements
│   ├── nutribot/               # AI Chatbot
│   └── profile/                # User profile & settings
└── shared/                     # Reusable widgets
    └── widgets/
```

## 📚 Dokumentasi Lengkap

- [Architecture](ARCHITECTURE.md)
- [Database Schema](DATABASE_SCHEMA.md)
- [Environment Setup](ENVIRONMENT.md)
- [Deployment Guide](DEPLOYMENT.md)
- [SRS (Software Requirements)](SRS.md)
- [FRS (Functional Requirements)](FRS.md)
- [User Manual](USER_MANUAL.md)
