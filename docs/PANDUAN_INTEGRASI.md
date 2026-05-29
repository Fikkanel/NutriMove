# Panduan Eksekusi Item Terdefer (Blocking Items) — NutriMove

Dokumen ini berisi panduan teknis langkah demi langkah untuk menyelesaikan sisa tugas yang berstatus **DEFERRED** atau **BLOCKED** agar aplikasi NutriMove siap dirilis ke Production (Play Store & App Store).

---

## 1. Integrasi Cloud (Firebase)

Aplikasi NutriMove membutuhkan Firebase untuk Autentikasi dan Database (Firestore). Saat ini, aplikasi masih berjalan menggunakan data *mock* lokal.

### Langkah-langkah:
1. **Buat Project di Firebase Console**:
   - Buka [Firebase Console](https://console.firebase.google.com/).
   - Buat project baru bernama `NutriMove`.
   - Aktifkan layanan: **Authentication** (Email/Password & Google) dan **Cloud Firestore**.

2. **Konfigurasi Android**:
   - Daftarkan aplikasi Android dengan package name yang sesuai (contoh: `com.fikkan.nutrimove`).
   - Unduh file `google-services.json`.
   - Letakkan file tersebut di: `nutrimove/android/app/google-services.json`.

3. **Konfigurasi iOS**:
   - Daftarkan aplikasi iOS dengan Bundle ID yang sesuai.
   - Unduh file `GoogleService-Info.plist`.
   - Buka folder `ios` menggunakan Xcode, lalu *drag and drop* file tersebut ke dalam folder `Runner`.

4. **Update Kode (Inisialisasi & Auth)**:
   - Buka `lib/main.dart` dan aktifkan inisialisasi Firebase:
     ```dart
     import 'package:firebase_core/firebase_core.dart';
     
     void main() async {
       WidgetsFlutterBinding.ensureInitialized();
       await Firebase.initializeApp(); // Tambahkan baris ini
       // ... kode lainnya
     }
     ```
   - Buka `lib/features/auth/presentation/screens/splash_screen.dart` dan hapus komentar (uncomment) pada bagian `_checkAuth()` untuk mengaktifkan routing otomatis berdasarkan status login.

---

## 2. Konfigurasi Hardware (Kamera & Galeri)

Fitur pemindai makanan (Food Scanner) membutuhkan akses kamera. Karena saat ini dikembangkan di Web, permission untuk *mobile* harus ditambahkan.

### Langkah-langkah:
1. **Android (`android/app/src/main/AndroidManifest.xml`)**:
   Tambahkan permission berikut sebelum tag `<application>`:
   ```xml
   <uses-permission android:name="android.permission.CAMERA" />
   <uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
   <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
   ```

2. **iOS (`ios/Runner/Info.plist`)**:
   Tambahkan *Usage Description* di dalam dict:
   ```xml
   <key>NSCameraUsageDescription</key>
   <string>NutriMove membutuhkan akses kamera untuk memindai makanan Anda.</string>
   <key>NSPhotoLibraryUsageDescription</key>
   <string>NutriMove membutuhkan akses galeri untuk menganalisis foto makanan yang tersimpan.</string>
   ```

---

## 3. Integrasi Model AI Fisik (TensorFlow Lite)

Logika untuk pemindai makanan menggunakan TFLite sudah ada di repositori, tetapi membutuhkan file model yang sebenarnya.

### Langkah-langkah:
1. Siapkan model `.tflite` hasil *training* Anda (contoh: untuk mendeteksi ayam, nasi, sayur).
2. Buat folder `assets/models/` di dalam root project.
3. Masukkan file `food_model.tflite` dan `labels.txt` ke dalam folder tersebut.
4. Daftarkan aset tersebut di `pubspec.yaml`:
   ```yaml
   flutter:
     assets:
       - assets/images/
       - assets/models/
   ```
5. Sesuaikan nama file di dalam `lib/features/scanner/data/services/tflite_service.dart`.

---

## 4. Konfigurasi API Key Generative AI (NutriBot)

Chatbot cerdas NutriBot membutuhkan API Key dari layanan LLM (misalnya Gemini API atau OpenAI).

### Langkah-langkah:
1. Dapatkan API Key dari [Google AI Studio](https://aistudio.google.com/) (untuk Gemini) atau platform lain.
2. Buka `lib/core/config/env_config.dart`.
3. Masukkan API Key Anda secara aman menggunakan `String.fromEnvironment`:
   ```dart
   static const String geminiApiKey = String.fromEnvironment(
     'GEMINI_API_KEY',
     defaultValue: 'MASUKKAN_KEY_SEMENTARA_DI_SINI_JIKA_DEBUG',
   );
   ```
4. Saat *build* untuk *production*, pastikan *compile* menggunakan flag:
   `flutter build apk --dart-define=GEMINI_API_KEY=KunciRahasiaAnda123`

---

## 5. Menjalankan Skrip & Testing (Opsional namun Sangat Direkomendasikan)

Setelah semua konfigurasi selesai, jalankan perintah ini untuk memastikan aplikasi siap didistribusikan:

1. **Bersihkan dan Install Ulang Dependensi**:
   ```bash
   flutter clean
   flutter pub get
   ```
2. **Jalankan Uji Coba Lintas Platform**:
   Pastikan Anda men-deploy ke *Emulator* Android atau *Simulator* iOS alih-alih Chrome, karena kamera fisik dan TFLite tidak akan berjalan optimal di web.
   ```bash
   flutter run -d emulator-5554
   ```
3. **Integration Testing** (Untuk melengkapi status QA-005 s/d QA-008 yang *SKIPPED*):
   Jalankan seluruh tes terpadu:
   ```bash
   flutter test integration_test
   ```
