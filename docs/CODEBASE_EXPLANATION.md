# 📖 Dokumentasi Lengkap & Peta Kode Source Code NutriMove (Folder `lib/`)

Dokumen ini memuat penjelasan lengkap untuk setiap file yang ada di dalam folder `lib/`. Dokumen ini dirancang untuk membantu Anda memahami struktur kode, menjelaskan cara kerjanya kepada dosen penguji, serta menunjukkan letak cuplikan kode (*source code*) kunci.

---

## 📂 1. STRUKTUR GLOBAL `lib/`

NutriMove menggunakan arsitektur **Clean Architecture (MVVM / Repository Pattern)** secara modular. Setiap fitur di dalam folder `features/` dibagi menjadi 3 lapisan:
1.  **Data Layer (`data/`)**: Mengelola data mentah, model data (serialisasi JSON), repositori konkret (implementasi penyimpanan), dan layanan API/layanan eksternal.
2.  **Domain Layer (`domain/`)**: Mendefinisikan kontrak interface repositori dan model entitas bisnis inti aplikasi. Bebas dari dependensi UI atau database luar.
3.  **Presentation Layer (`presentation/`)**: Mengelola tampilan antarmuka (Screens & Widgets) dan manajemen state (Provider) yang menghubungkan UI dengan domain logika bisnis.

---

## ⚙️ 2. FOLDER `lib/core/` (Logika & Konfigurasi Sistem)

Folder ini berisi seluruh pondasi utama dan utilitas global aplikasi.

### `lib/core/config/env_config.dart`
*   **Fungsi**: Menyimpan kunci API (Gemini API Key) secara terpusat.
*   **Penting**: Digunakan saat inisialisasi model chatbot dan scanner.
*   **Source Code**:
    ```dart
    class EnvConfig {
      // Membaca API Key secara dinamis dari --dart-define atau daftar cadangan lokal
      static String get geminiApiKey {
        const fromEnv = String.fromEnvironment('GEMINI_API_KEY');
        if (fromEnv.isNotEmpty) return fromEnv;
        return _geminiKeys.first;
      }
    }
    ```

### `lib/core/constants/app_constants.dart`
*   **Fungsi**: Menyimpan nilai konstanta aplikasi (seperti batas kalori default, nama koleksi Firestore, durasi animasi, dll.).
*   **Source Code**:
    ```dart
    class AppConstants {
      static const double defaultCalorieTarget = 2000.0;
      static const String usersCollection = 'users';
      static const String dailyLogsCollection = 'daily_logs';
    }
    ```

### `lib/core/providers/app_providers.dart`
*   **Fungsi**: Mendaftarkan semua `ChangeNotifierProvider` secara global agar state dapat dibaca dari halaman manapun di aplikasi.
*   **Source Code**:
    ```dart
    static List<SingleChildWidget> get providers => [
          ChangeNotifierProvider<AuthProvider>(create: (_) => AuthProvider()),
          ChangeNotifierProvider<DashboardProvider>(create: (_) => DashboardProvider()),
          ChangeNotifierProvider<ScannerProvider>(create: (_) => ScannerProvider()),
          // ... provider lainnya
        ];
    ```

### `lib/core/router/app_router.dart`
*   **Fungsi**: Konfigurasi routing menggunakan `GoRouter`. Mengatur transisi halaman dan navigasi menggunakan shell route (dengan Bottom Navigation Bar).

### `lib/core/storage/local_storage_service.dart`
*   **Fungsi**: Kelas utilitas pembungkus `SharedPreferences` untuk menyimpan data secara persisten dan offline dalam bentuk key-value lokal.
*   **Source Code**:
    ```dart
    class LocalStorageService {
      static late SharedPreferences _prefs;
      static Future<void> init() async => _prefs = await SharedPreferences.getInstance();
      static Future<void> setMap(String key, Map<String, dynamic> value) async => _prefs.setString(key, json.encode(value));
      static Map<String, dynamic>? getMap(String key) {
        final raw = _prefs.getString(key);
        return raw != null ? json.decode(raw) : null;
      }
    }
    ```

### `lib/core/theme/` (Sistem Tema & Warna Dinamis)
*   **`app_colors.dart`**: Menyimpan token warna dinamis (terang/gelap) serta metode `updateTheme(bool isDark)` untuk mendeteksi dan mengubah warna secara *real-time* saat sistem HP berubah mode.
*   **`app_theme.dart`**: Membuat konfigurasi `ThemeData` Flutter untuk `lightTheme` dan `darkTheme`.
*   **`app_typography.dart`**: Mengonfigurasi gaya huruf global (font *Outfit* dan *Inter*) dan warna teks yang dinamis menyesuaikan tema gelap/terang.

---

## 🏃 3. FOLDER `lib/features/` (Fitur Aplikasi Modular)

### 🔑 A. Fitur Autentikasi (`lib/features/auth/`)
Mengelola alur registrasi, login email, login Google, reset sandi, dan setup profil awal.

1.  **`data/models/user_model.dart`**: Model data user yang menerima data UID dan nama profil dari Firebase Auth.
2.  **`domain/repositories/auth_repository.dart`**: Deklarasi interface (kontrak) fungsi-fungsi autentikasi.
3.  **`data/repositories/auth_repository_impl.dart`**: Kode konkret yang menghubungkan ke Firebase Auth SDK.
    *   **Source Code (Login Email & Sandi)**:
        ```dart
        @override
        Future<UserModel> signIn(String email, String password) async {
          final credential = await _firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password,
          );
          return _userFromFirebase(credential.user)!;
        }
        ```
    *   **Source Code (Google Sign-In)**:
        ```dart
        @override
        Future<UserModel> signInWithGoogle() async {
          final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
          final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
          final OAuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken, idToken: googleAuth.idToken,
          );
          final UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
          return _userFromFirebase(userCredential.user)!;
        }
        ```
4.  **`presentation/providers/auth_provider.dart`**: Mengelola state loading saat login, menjaga session user aktif, dan memeriksa status autentikasi di startup.
5.  **`presentation/screens/`**:
    *   **`splash_screen.dart`**: Halaman pemuat pertama kali dengan animasi logo membesar (ElasticOut) dan perpindahan rute otomatis.
    *   **`login_screen.dart`**: Halaman login email dengan Form Validation dan tombol Google Sign-In.
    *   **`register_screen.dart`**: Halaman pembuatan akun Firebase baru.
    *   **`forgot_password_screen.dart`**: Halaman untuk mengirim email pemulihan sandi via Firebase.
    *   **`profile_setup_screen.dart`**: Halaman setup tinggi/berat badan awal bagi pengguna baru (data disimpan di Firestore).

---

### 📊 B. Fitur Dashboard (`lib/features/dashboard/`)
Menampilkan ringkasan kalori harian, macronutrient, daftar makanan hari ini, dan visualisasi grafik mingguan.

1.  **`data/models/daily_log_model.dart`**: Menyimpan total asupan gizi per tanggal (protein, kalori, karbo, lemak).
2.  **`data/repositories/dashboard_repository_impl.dart`**: Mengelola database log makanan harian berbasis local storage (offline-first).
    *   **Source Code (Menambah data makanan baru)**:
        ```dart
        @override
        Future<void> addMeal(String userId, FoodItemModel meal) async {
          final today = _getTodayString();
          final currentLog = await getTodayLog(userId);
          // Tambahkan nilai gizi makanan ke log hari ini
          await LocalStorageService.setMap('dashboard_log_${userId}_$today', {
            'totalCalories': currentLog.totalCalories + meal.calories,
            'totalProtein': currentLog.totalProtein + meal.protein,
            'totalCarbs': currentLog.totalCarbs + meal.carbs,
            'totalFat': currentLog.totalFat + meal.fat,
          });
        }
        ```
3.  **`presentation/providers/dashboard_provider.dart`**: Memanggil repositori untuk menghitung kemajuan asupan harian (persentase target kalori) dan memicu pembaruan antarmuka.
4.  **`presentation/screens/`**:
    *   **`home_screen.dart`**: Layar dashboard utama. Menampilkan progress bar lingkaran kalori harian dan daftar makanan dengan **Hero Animation** pada kartu Grade Gizi.
    *   **`edit_meal_screen.dart`**: Form detail untuk mengubah kandungan gizi makanan yang dicatat atau menghapusnya. Dilengkapi transisi Hero yang tersinkronisasi.
    *   **`weekly_report_screen.dart`**: Menampilkan riwayat gizi mingguan dalam bentuk grafik batang (BarChart) interaktif menggunakan library `fl_chart`.

---

### 📸 C. Fitur Scanner AI & Manual (`lib/features/scanner/`)
Mengidentifikasi makanan berbasis foto/kamera (Gemini AI Vision) dan menyediakan fallback database lokal jika offline.

1.  **`data/services/food_recognition_service.dart`**: Logika pemanggilan Gemini Vision API untuk mendeteksi makanan dari gambar.
    *   **Source Code (Gemini Vision API)**:
        ```dart
        Future<FoodItemModel> recognizeFoodImage(String imagePath) async {
          final bytes = await File(imagePath).readAsBytes();
          final content = [
            Content.multi([
              TextPart("Identifikasi nama makanan ini serta estimasikan nilai kalorinya..."),
              DataPart('image/jpeg', bytes),
            ])
          ];
          final model = GenerativeModel(model: 'gemini-2.5-flash', apiKey: EnvConfig.geminiApiKey);
          final response = await model.generateContent(content);
          // Parsing response teks JSON dari Gemini ke model FoodItemModel
          return parseGeminiResponse(response.text);
        }
        ```
2.  **`presentation/providers/scanner_provider.dart`**: Menyimpan state pemrosesan gambar, mengontrol nilai pengali porsi makanan (*portionMultiplier*), dan menyimpan makanan ke log harian.
3.  **`presentation/screens/`**:
    *   **`camera_screen.dart`**: Membuka kamera perangkat menggunakan paket `camera` untuk mengambil foto makanan.
    *   **`scan_result_screen.dart`**: Menampilkan hasil identifikasi AI Gemini berupa nama makanan, kalori, makronutrisi, skoring *NutriGrade*, dan slider untuk mengatur ukuran porsi makanan secara interaktif.
    *   **`manual_input_screen.dart`**: Form input manual apabila pengguna ingin mencatat makanan sendiri secara instan tanpa kamera.

---

### 🤖 D. Fitur NutriBot Chat AI (`lib/features/nutribot/`)
Menyediakan asisten chatbot konsultasi gizi interaktif ditenagai LLM Gemini AI.

1.  **`data/services/nutribot_service.dart`**: Kelas pembungkus untuk memanggil percakapan multi-turn (chat session) menggunakan `GenerativeModel`.
2.  **`presentation/providers/nutribot_provider.dart`**: Menyimpan daftar riwayat obrolan (`ChatMessageModel`) dan mengalirkan teks dari Gemini secara dinamis.
3.  **`presentation/screens/chat_screen.dart`**: Tampilan UI chat dengan gelembung obrolan yang mendukung rendering **Markdown** (bold, bullet points, headers) menggunakan paket `flutter_markdown` agar visual percakapan rapi dan nyaman dibaca.

---

### 🏆 E. Fitur Gamifikasi (`lib/features/gamification/`)
Mendorong kebiasaan mencatat harian melalui pelacakan Streak dan pembukaan lencana Achievements.

1.  **`data/repositories/gamification_repository_impl.dart`**: Menyimpan dan memuat data streak (beruntun hari) dan status lencana yang terbuka secara lokal.
2.  **`presentation/providers/gamification_provider.dart`**: Memeriksa apakah pengguna berhak mendapatkan lencana baru (misal: sukses mencatat makanan selama 7 hari berturut-turut) dan memicu notifikasi pencapaian.
3.  **`presentation/screens/achievements_screen.dart`**: Daftar grid berisi lencana pencapaian (contoh: *NutriMaster*, *First Scan*) yang ditandai berwarna jika sudah diraih (unlocked) atau abu-abu jika belum terbuka.

---

### 🥗 F. Fitur NutriGrade & Rekomendasi (`lib/features/nutrigrade/`)
Menyaring makanan berdasarkan profil alergi pribadi dan memberikan saran alternatif makanan yang lebih sehat menggunakan skoring TOPSIS.

1.  **`domain/engines/topsis_engine.dart`**: Implementasi metode matematika **TOPSIS** (Technique for Order of Preference by Similarity to Ideal Solution) untuk mengurutkan rekomendasi makanan berdasarkan kedekatan dengan kriteria gizi ideal pengguna.
2.  **`presentation/screens/recommendation_screen.dart`**: Layar yang menampilkan saran alternatif hidangan sehat berdasarkan target nutrisi diet user hari itu.
3.  **`presentation/widgets/allergen_warning_widget.dart`**: Widget peringatan warna merah mencolok yang muncul jika makanan yang di-scan mengandung alergen yang dihindari oleh profil pengguna (misalnya: mengandung susu/kacang).

---

## 🎨 4. FOLDER `lib/shared/` (Komponen UI Reusable)

Folder ini berisi komponen global yang dapat dipakai berulang-ulang di berbagai layar untuk menjamin konsistensi visual:

1.  **`widgets/animated_card.dart`**: Kartu kontainer premium yang membungkus konten dengan animasi transisi memudar & membesar (*fade & scale transition*) serta animasi meredam skala (shrink scale) saat di-tap.
2.  **`widgets/custom_app_bar.dart`**: Desain bar bagian atas aplikasi dengan tombol kembali.
3.  **`widgets/nutrimove_button.dart`**: Tombol utama aplikasi yang mendukung state loading (loading indicator) bawaan.
4.  **`widgets/nutrimove_text_field.dart`**: Kotak input teks kustom dengan ikon pembuka, penutup, dan validasi form yang konsisten.
5.  **`widgets/nutrimove_snackbar.dart`**: Pop-up pemberitahuan kustom di bagian atas layar untuk sukses/error.
6.  **`widgets/empty_state_widget.dart`**: Ilustrasi menarik dan teks informatif jika data riwayat makanan atau pencapaian masih kosong (mencegah layar kosong/blank).
