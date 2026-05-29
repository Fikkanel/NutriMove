# Maintenance Guide — NutriMove

## 1. Regular Maintenance

### Dependencies Update
```bash
# Check outdated packages
flutter pub outdated

# Update to latest compatible
flutter pub upgrade

# Major version update (review breaking changes)
flutter pub upgrade --major-versions
```

### Code Quality
```bash
# Run analyzer
flutter analyze

# Run tests
flutter test

# Format code
dart format .
```

## 2. Firebase Maintenance

### Firestore Rules
- Review security rules quarterly
- Test rules changes in Firebase Emulator first
- Never allow public write access

### Database
- Monitor Firestore usage in Firebase Console
- Set up billing alerts
- Index queries yang sering digunakan

## 3. AI Model Update

### TFLite Model
1. Retrain model dengan data baru
2. Export ke `.tflite` format
3. Replace file di `assets/models/`
4. Update labels di `assets/models/food_labels.txt`
5. Test accuracy sebelum release

## 4. Release Process

```bash
# 1. Update version in pubspec.yaml
# 2. Run tests
flutter test

# 3. Build
flutter build apk --release
flutter build appbundle --release

# 4. Upload to Play Console / App Store Connect
```

## 5. Monitoring

| Aspect | Tool |
|---|---|
| Crashes | Firebase Crashlytics |
| Analytics | Firebase Analytics |
| Performance | Firebase Performance |
| Backend | Firebase Console |

## 6. Backup Strategy

- Firestore: Enable automated backups
- Source code: Git repository
- Release builds: Archive in CI/CD artifacts
