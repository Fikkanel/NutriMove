# Deployment Guide — NutriMove

## Android (Google Play Store)

### 1. Signing Key

```bash
keytool -genkey -v -keystore nutrimove-release-key.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias nutrimove
```

### 2. key.properties

Buat file `android/key.properties`:
```properties
storePassword=<password>
keyPassword=<password>
keyAlias=nutrimove
storeFile=<path>/nutrimove-release-key.jks
```

### 3. Build APK/AAB

```bash
# APK
flutter build apk --release

# App Bundle (recommended)
flutter build appbundle --release
```

### 4. Upload ke Play Console

1. Buka [Google Play Console](https://play.google.com/console)
2. Create App → NutriMove
3. Upload AAB ke Production/Internal Testing
4. Isi Store Listing (screenshots, deskripsi)
5. Submit for Review

## iOS (App Store)

### 1. Apple Developer Account

Register di [Apple Developer](https://developer.apple.com)

### 2. Xcode Configuration

```bash
open ios/Runner.xcworkspace
```

- Set Bundle Identifier: `com.nutrimove.app`
- Set Signing Team
- Set Deployment Target: iOS 15.0+

### 3. Build

```bash
flutter build ios --release
```

### 4. Upload via Xcode

1. Product → Archive
2. Distribute App → App Store Connect
3. Lengkapi metadata di App Store Connect
4. Submit for Review

## Firebase Deployment

```bash
# Deploy Firestore rules
firebase deploy --only firestore:rules

# Deploy Cloud Functions (jika ada)
firebase deploy --only functions
```

## CI/CD (GitHub Actions)

```yaml
name: NutriMove CI
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.41.1'
      - run: flutter pub get
      - run: flutter analyze
      - run: flutter test
```
