# 📘 Panduan Kode & Contekan Presentasi UAS NutriMove

Dokumen ini adalah panduan lengkap peta kode proyek **NutriMove**. Gunakan dokumen ini sebagai referensi cepat atau "contekan" sebelum dan selama presentasi UAS untuk menjawab pertanyaan dosen penguji mengenai letak file, logika fungsi, dan cara melakukan modifikasi.

---

## 📂 I. PETA STRUKTUR FOLDER PROYEK

Aplikasi ini menggunakan **Clean Architecture** yang terbagi secara modular per fitur:

```
lib/
├── core/                         # Konfigurasi & Utilitas Global Sistem
│   ├── config/                   #env_config.dart (API Key Gemini)
│   ├── constants/                #app_constants.dart (Batas target, nama collection)
│   ├── providers/                #app_providers.dart (Registrasi Provider/State Management)
│   ├── router/                   #app_router.dart (Navigasi GoRouter)
│   ├── storage/                  #local_storage_service.dart (Penyimpanan SharedPreferences)
│   └── theme/                    #app_theme.dart, app_colors.dart, app_typography.dart
│
├── features/                     # Fitur Modular Aplikasi (domain-data-presentation)
│   ├── auth/                     # Fitur Autentikasi & Onboarding (Login, Register, Reset)
│   ├── dashboard/                # Fitur Utama (Dashboard, List Makanan, Grafik Mingguan)
│   ├── scanner/                  # Fitur AI Scan & Input Manual Makanan
│   ├── nutribot/                 # Fitur Chatbot Asisten Gizi AI
│   ├── nutrigrade/               # Fitur Skoring TOPSIS & Rekomendasi Makanan Sehat
│   ├── gamification/             # Fitur Streak Harian & Achievements
│   └── profile/                  # Fitur Pengaturan Profil, Target Diet, Alergi
│
└── shared/                       # Komponen UI Global yang Dipakai Bersama
    └── widgets/                  # NutriMoveButton, NutriMoveTextField, AnimatedCard, dll.
```

---

## 🔍 II. LOKASI FUNGSI KUNCI (DI MANA LETAK KODE?)

Berikut adalah daftar fungsi utama yang sering ditanyakan penguji beserta lokasi kodenya:

### 1. Proses Autentikasi (Login & Register)
*   **Melakukan Panggilan ke Firebase Auth**:
    *   Letak file: [auth_repository_impl.dart](file:///c:/FIKKAN/project/Skills/NutriMove/nutrimove/lib/features/auth/data/repositories/auth_repository_impl.dart)
    *   Fungsi **Register**: `register(name, email, password)` di line 61.
    *   Fungsi **Login Email**: `signIn(email, password)` di line 27.
    *   Fungsi **Google Sign-In**: `signInWithGoogle()` di line 36.
    *   Fungsi **Sign Out**: `signOut()` di line 83.
*   **Manajemen State Autentikasi**:
    *   Letak file: [auth_provider.dart](file:///c:/FIKKAN/project/Skills/NutriMove/nutrimove/lib/features/auth/presentation/providers/auth_provider.dart)
    *   Logika validasi form login: di [login_screen.dart](file:///c:/FIKKAN/project/Skills/NutriMove/nutrimove/lib/features/auth/presentation/screens/login_screen.dart).

### 2. Logika CRUD Makanan (Database lokal & Firebase)
*   **Create (Tambah Makanan)**:
    *   Tambah manual: [manual_input_screen.dart](file:///c:/FIKKAN/project/Skills/NutriMove/nutrimove/lib/features/scanner/presentation/screens/manual_input_screen.dart#L56) (`_saveManual()`).
    *   Tambah otomatis setelah scan: [scan_result_screen.dart](file:///c:/FIKKAN/project/Skills/NutriMove/nutrimove/lib/features/scanner/presentation/screens/scan_result_screen.dart) (`_saveMeal()`).
    *   Penyimpanan ke local storage: [dashboard_repository_impl.dart](file:///c:/FIKKAN/project/Skills/NutriMove/nutrimove/lib/features/dashboard/data/repositories/dashboard_repository_impl.dart#L44) (`addMeal()`).
*   **Read (Tampilkan Log & List)**:
    *   Mengambil data log harian: `getTodayLog(userId)` di [dashboard_repository_impl.dart](file:///c:/FIKKAN/project/Skills/NutriMove/nutrimove/lib/features/dashboard/data/repositories/dashboard_repository_impl.dart#L13).
    *   Mengambil list makanan hari ini: `getTodayMeals(userId)` di [dashboard_repository_impl.dart](file:///c:/FIKKAN/project/Skills/NutriMove/nutrimove/lib/features/dashboard/data/repositories/dashboard_repository_impl.dart#L33).
*   **Update (Edit Makanan)**:
    *   Logika di: `updateMeal(userId, index, updatedMeal)` di [dashboard_repository_impl.dart](file:///c:/FIKKAN/project/Skills/NutriMove/nutrimove/lib/features/dashboard/data/repositories/dashboard_repository_impl.dart#L87).
*   **Delete (Hapus Makanan)**:
    *   Logika di: `deleteMeal(userId, index)` di [dashboard_repository_impl.dart](file:///c:/FIKKAN/project/Skills/NutriMove/nutrimove/lib/features/dashboard/data/repositories/dashboard_repository_impl.dart#L120).

### 3. Logika Perhitungan Gizi & Skoring NutriGrade (A/B/C/D)
*   Penilaian kualitas gizi makanan dihitung secara dinamis berdasarkan formula kandungan Protein vs Kalori, Lemak, dan Karbohidrat:
    *   Letak file: [edit_meal_screen.dart](file:///c:/FIKKAN/project/Skills/NutriMove/nutrimove/lib/features/dashboard/presentation/screens/edit_meal_screen.dart#L69) (`_calculateGrade()`) dan [scanner_provider.dart](file:///c:/FIKKAN/project/Skills/NutriMove/nutrimove/lib/features/scanner/presentation/providers/scanner_provider.dart#L77) (`saveManualMeal()`).
    *   Metode skoring: Skor maksimal 100 didapat dari asupan Protein (40%), Kalori rendah (20%), Lemak rendah (20%), dan Karbohidrat rendah (20%). Skor >= 80 mendapat **Grade A**, >= 60 **Grade B**, >= 40 **Grade C**, di bawah itu **Grade D**.

### 4. Integrasi AI (Gemini AI)
*   **NutriBot (Chatbot)**:
    *   Panggilan API Gemini: [nutribot_service.dart](file:///c:/FIKKAN/project/Skills/NutriMove/nutrimove/lib/features/nutribot/data/services/nutribot_service.dart).
    *   State & Manajemen pesan: [nutribot_provider.dart](file:///c:/FIKKAN/project/Skills/NutriMove/nutrimove/lib/features/nutribot/presentation/providers/nutribot_provider.dart).
*   **AI Food Scanner (Hybrid Scan)**:
    *   Pemindaian foto menggunakan Gemini Vision API: [food_recognition_service.dart](file:///c:/FIKKAN/project/Skills/NutriMove/nutrimove/lib/features/scanner/data/services/food_recognition_service.dart#L14) (`recognizeFoodImage()`).
    *   Logika fallback (jika kuota API Gemini habis): Mengambil data gizi dari database master lokal di [scanner_repository_impl.dart](file:///c:/FIKKAN/project/Skills/NutriMove/nutrimove/lib/features/scanner/data/repositories/scanner_repository_impl.dart).

### 5. Mode Gelap Dinamis (Dark Mode)
*   Menggunakan skema deteksi platform brightness di [app.dart](file:///c:/FIKKAN/project/Skills/NutriMove/nutrimove/lib/app.dart#L28):
    `final isDark = MediaQuery.platformBrightnessOf(context) == Brightness.dark;`
    `AppColors.updateTheme(isDark);`
    `AppTypography.updateTheme(isDark);`
*   Skema warna gelap diatur penuh di [app_theme.dart](file:///c:/FIKKAN/project/Skills/NutriMove/nutrimove/lib/core/theme/app_theme.dart) dan [app_colors.dart](file:///c:/FIKKAN/project/Skills/NutriMove/nutrimove/lib/core/theme/app_colors.dart).

---

## 🧠 III. SKENARIO MODIFIKASI CEPAT (PANDUAN MENJAWAB PERTANYAAN DOSEN)

### Skenario 1: "Bagaimana cara mengubah Target Kalori bawaan (Default)?"
*   **Jawaban Anda**: "Semua nilai konfigurasi bawaan aplikasi disimpan terpusat di berkas konstanta. Saya bisa mengubah nilai `defaultCalorieTarget` di dalam berkas [app_constants.dart](file:///c:/FIKKAN/project/Skills/NutriMove/nutrimove/lib/core/constants/app_constants.dart#L31)."

### Skenario 2: "Bagaimana cara memperbarui / mengganti API Key Gemini?"
*   **Jawaban Anda**: "API Key Gemini tersimpan di satu file konfigurasi lingkungan, yaitu pada [env_config.dart](file:///c:/FIKKAN/project/Skills/NutriMove/nutrimove/lib/core/config/env_config.dart). Saya hanya perlu memperbarui string `geminiApiKey` di sana dengan key baru dari Google AI Studio."

### Skenario 3: "Di mana data Offline disimpan dan bagaimana strukturnya?"
*   **Jawaban Anda**: "Data offline disimpan menggunakan **Shared Preferences** di HP pengguna melalui pembungkus (wrapper) kelas [local_storage_service.dart](file:///c:/FIKKAN/project/Skills/NutriMove/nutrimove/lib/core/storage/local_storage_service.dart). Strukturnya berupa JSON Map dengan kunci unik yang digabungkan dari ID user dan tanggal hari itu, contohnya `dashboard_meals_${userId}_${dateStr}`."

### Skenario 4: "Bagaimana jika kita ingin memindahkan penyimpanan data Makanan dari SharedPreferences ke Firestore penuh?"
*   **Jawaban Anda**: "Karena kami menggunakan **Clean Architecture & Repository Pattern**, perubahan ini sangat mudah dan aman tanpa merusak UI. Kami hanya perlu:
    1. Membuat kelas baru bernama `DashboardRepositoryFirestoreImpl` yang mengimplementasikan kontrak interface `DashboardRepository`.
    2. Mengubah inisialisasi instansi repository di provider [dashboard_provider.dart](file:///c:/FIKKAN/project/Skills/NutriMove/nutrimove/lib/features/dashboard/presentation/providers/dashboard_provider.dart) untuk menunjuk ke kelas baru tersebut.
    Seluruh halaman UI (seperti HomeScreen dan EditMealScreen) akan tetap bekerja normal tanpa memerlukan perubahan baris kode apa pun."

### Skenario 5: "Bagaimana kriteria skor NutriGrade dinilai dan di mana logic-nya?"
*   **Jawaban Anda**: "Logic-nya berada di dalam fungsi `_calculateGrade` pada [edit_meal_screen.dart](file:///c:/FIKKAN/project/Skills/NutriMove/nutrimove/lib/features/dashboard/presentation/screens/edit_meal_screen.dart#L69). Skor dihitung secara proporsional berdasarkan makronutrisi. Kandungan protein tinggi menaikkan skor, sedangkan kalori, lemak, dan karbohidrat yang berlebihan menurunkan skor. Nilai skor akhir dikonversi ke predikat huruf A/B/C/D."

### Skenario 6: "Di mana Anda menambahkan animasi Hero dan bagaimana kinerjanya?"
*   **Jawaban Anda**: "Animasi Hero ditambahkan pada badge Grade Makanan. Di [home_screen.dart](file:///c:/FIKKAN/project/Skills/NutriMove/nutrimove/lib/features/dashboard/presentation/screens/home_screen.dart#L138), saya membungkus badge dengan widget `Hero` menggunakan tag unik per indeks makanan. Di [edit_meal_screen.dart](file:///c:/FIKKAN/project/Skills/NutriMove/nutrimove/lib/features/dashboard/presentation/screens/edit_meal_screen.dart#L208), saya menggunakan widget `Hero` dengan tag yang sama. Saat kartu makanan ditekan, Flutter secara otomatis menganimasikan badge tersebut melayang, berpindah posisi, dan membesar secara alami."

---

## 📈 IV. DIAGRAM ALUR PROSES UTAMA (CARA KERJA APLIKASI)

### 1. Alur Autentikasi Pengguna
```
[Halaman Login/Daftar] ────> Validasi Input Form ────> Panggilan AuthRepository ────> [Firebase Auth]
                                                                                            │
[Home Screen / Dashboard] <──── Ambil/Inisialisasi Profil <──── Dapatkan Auth UID <─────────┘
```

### 2. Alur Hybrid Food Scanning (Kamera AI)
```
[Foto Makanan Diambil]
         │
         ▼
[Coba Pindai dengan Gemini Vision API]
         │
         ├───> [SUKSES] ─> Tampilkan hasil gizi dari AI Gemini ─> Simpan ke Log
         │
         └───> [GAGAL/LIMIT] ─> Fallback ke Database Lokal offline ─> Cari kecocokan kata kunci ─> Simpan ke Log
```
