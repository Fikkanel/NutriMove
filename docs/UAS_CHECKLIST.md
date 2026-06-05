# 📋 Hasil Audit Kriteria Kelulusan UAS Pemrograman Mobile

Dokumen ini memverifikasi keselarasan proyek **NutriMove** dengan seluruh kriteria teknis utama (wajib) dan poin bonus yang ditetapkan pada **[Panduan UAS Pemrograman Mobile](file:///c:/FIKKAN/project/Skills/NutriMove/nutrimove/docs/UAS_REQUIREMENTS.txt)**.

---

## ⚙️ I. VERIFIKASI REQUIREMENT UTAMA (WAJIB)

Aplikasi **NutriMove** telah memenuhi **100%** dari kriteria wajib yang ditentukan:

### 1. 🔄 Fungsionalitas CRUD (Create, Read, Update, Delete) — [Bobot: 25%]
Seluruh operasi manipulasi data log makanan harian berjalan secara offline-first dengan sinkronisasi lokal dan cloud:
*   **Create (Tambah Data)**: 
    *   Pengguna dapat menambahkan data makanan secara otomatis lewat pemindaian AI di [camera_screen.dart](file:///c:/FIKKAN/project/Skills/NutriMove/nutrimove/lib/features/scanner/presentation/screens/camera_screen.dart).
    *   Pengguna dapat memasukkan data nutrisi secara manual melalui form tervalidasi di [manual_input_screen.dart](file:///c:/FIKKAN/project/Skills/NutriMove/nutrimove/lib/features/scanner/presentation/screens/manual_input_screen.dart).
*   **Read (Tampilkan Data)**:
    *   Asupan kalori dan makronutrisi harian ditampilkan secara visual di dashboard utama [home_screen.dart](file:///c:/FIKKAN/project/Skills/NutriMove/nutrimove/lib/features/dashboard/presentation/screens/home_screen.dart).
    *   Riwayat makanan harian ditampilkan dalam bentuk list kartu interaktif di dashboard.
*   **Update (Ubah Data)**:
    *   Kartu makanan di dashboard dapat di-tap untuk membuka form edit di [edit_meal_screen.dart](file:///c:/FIKKAN/project/Skills/NutriMove/nutrimove/lib/features/dashboard/presentation/screens/edit_meal_screen.dart) untuk memperbarui nama, porsi, atau kandungan gizi makanan.
*   **Delete (Hapus Data)**:
    *   Data makanan dapat dihapus secara permanen dari log hari ini melalui tombol hapus dengan konfirmasi dialog di [edit_meal_screen.dart](file:///c:/FIKKAN/project/Skills/NutriMove/nutrimove/lib/features/dashboard/presentation/screens/edit_meal_screen.dart#L130).

### 2. 🎨 Animasi (Minimal 2 Bagian) — [Bobot: 10%]
Aplikasi menggunakan 3 jenis animasi halus untuk meningkatkan kepuasan pengguna (UX):
1.  **Splash Screen Animations** ([splash_screen.dart](file:///c:/FIKKAN/project/Skills/NutriMove/nutrimove/lib/features/auth/presentation/screens/splash_screen.dart)):
    *   *Scale Transition (ElasticOut)*: Logo aplikasi membesar secara elastis saat aplikasi dibuka.
    *   *Slide & Fade Transition*: Teks judul meluncur naik secara halus dari bawah.
2.  **Animated Cards & Interactive List** ([animated_card.dart](file:///c:/FIKKAN/project/Skills/NutriMove/nutrimove/lib/shared/widgets/animated_card.dart)):
    *   *Scale & Fade In*: Kartu data (dashboard, list makanan) muncul dengan transisi membesar dan memudar secara bergantian (staggered delay).
    *   *Tap Feedback Animation*: Kartu mengecil sedikit (scale down 0.97) secara interaktif ketika ditekan.
3.  **Hero Transition (Grade Melayang)**:
    *   Transisi visual halus di mana badge *NutriGrade* (A/B/C/D) melayang dan membesar dari ukuran kartu di [home_screen.dart](file:///c:/FIKKAN/project/Skills/NutriMove/nutrimove/lib/features/dashboard/presentation/screens/home_screen.dart) menuju ke pratinjau besar di [edit_meal_screen.dart](file:///c:/FIKKAN/project/Skills/NutriMove/nutrimove/lib/features/dashboard/presentation/screens/edit_meal_screen.dart) saat item makanan diklik.

### 3. 🧱 Struktur Minimal Halaman
*   **Halaman Utama (Dashboard)**: [home_screen.dart](file:///c:/FIKKAN/project/Skills/NutriMove/nutrimove/lib/features/dashboard/presentation/screens/home_screen.dart) (Menampilkan progress kalori, makro, & riwayat makan).
*   **Halaman Tambah/Edit**: [manual_input_screen.dart](file:///c:/FIKKAN/project/Skills/NutriMove/nutrimove/lib/features/scanner/presentation/screens/manual_input_screen.dart) & [edit_meal_screen.dart](file:///c:/FIKKAN/project/Skills/NutriMove/nutrimove/lib/features/dashboard/presentation/screens/edit_meal_screen.dart).
*   **Halaman Detail**: [food_detail_screen.dart](file:///c:/FIKKAN/project/Skills/NutriMove/nutrimove/lib/features/nutrigrade/presentation/screens/food_detail_screen.dart) (Menampilkan info gizi makanan & rekomendasi TOPSIS).

---

## 💾 II. INTEGRASI DATABASE & AUTENTIKASI (WAJIB)

*   **Autentikasi (15%)**: 
    *   Sistem registrasi & login tervalidasi di [login_screen.dart](file:///c:/FIKKAN/project/Skills/NutriMove/nutrimove/lib/features/auth/presentation/screens/login_screen.dart) dan [register_screen.dart](file:///c:/FIKKAN/project/Skills/NutriMove/nutrimove/lib/features/auth/presentation/screens/register_screen.dart).
    *   Mendukung login email-password tradisional dan integrasi **Google Sign-In** sekali klik di [auth_repository_impl.dart](file:///c:/FIKKAN/project/Skills/NutriMove/nutrimove/lib/features/auth/data/repositories/auth_repository_impl.dart#L36).
*   **Database Integration (15%)**:
    *   **Cloud Firestore** terintegrasi secara dinamis untuk mengelola data profil pengguna online (`users` collection).
    *   Menerapkan cache lokal offline menggunakan **SharedPreferences** di [local_storage_service.dart](file:///c:/FIKKAN/project/Skills/NutriMove/nutrimove/lib/core/storage/local_storage_service.dart) agar data asupan harian tetap tersimpan di HP dan diakses super cepat tanpa koneksi internet.

---

## 🚀 III. POIN NILAI TAMBAHAN (BONUS)

NutriMove memiliki kompleksitas tinggi dan mengimplementasikan banyak fitur bonus lintas level:

### 🟢 Level 1 – Enhancement Dasar (+5% per fitur)
1.  **Dark Mode / Auto Theme Switching**: Menyesuaikan tema aplikasi (Terang/Gelap) secara otomatis berdasarkan preferensi sistem HP pengguna [app.dart](file:///c:/FIKKAN/project/Skills/NutriMove/nutrimove/lib/app.dart#L28).
2.  **Form Validation**: Validasi real-time pada semua field input (email, password, tinggi/berat badan, porsi makanan).
3.  **Loading & Error Handling**: Loading spinner yang proper, dialog konfirmasi hapus, serta notifikasi visual pop-up menggunakan `NutriMoveSnackbar` saat terjadi kesalahan proses.

### 🟡 Level 2 – Intermediate (+10% per fitur)
1.  **State Management**: Menggunakan paket **Provider** secara modular untuk memisahkan logika UI dan State Data (Auth, Dashboard, Scanner, Profile, Gamification).
2.  **Local Cache (Offline Storage)**: Database offline terstruktur berbasis SharedPreferences yang mengelola riwayat logs dan makanan per tanggal (Offline-first approach).
3.  **Custom Reusable Component System**: Struktur widget kustom modular seperti [NutriMoveButton](file:///c:/FIKKAN/project/Skills/NutriMove/nutrimove/lib/shared/widgets/nutrimove_button.dart), [NutriMoveTextField](file:///c:/FIKKAN/project/Skills/NutriMove/nutrimove/lib/shared/widgets/nutrimove_text_field.dart), dan [CustomAppBar](file:///c:/FIKKAN/project/Skills/NutriMove/nutrimove/lib/shared/widgets/custom_app_bar.dart).

### 🔵 Level 3 – Advanced (+15% per fitur)
1.  **Data Visualization (Charts)**: Grafik interaktif harian dan mingguan untuk melacak tren kalori menggunakan **FL Chart** di [weekly_report_screen.dart](file:///c:/FIKKAN/project/Skills/NutriMove/nutrimove/lib/features/dashboard/presentation/screens/weekly_report_screen.dart).
2.  **Offline-first Application**: Log makanan dan perhitungan gizi harian dapat berjalan penuh secara offline tanpa internet.

### 🔴 Level 4 – Expert (+20% per fitur)
1.  **Clean Architecture (MVVM / Repository Pattern)**: Pemisahan folder rapi ke dalam komponen modular (`data/`, `domain/`, `presentation/`) di setiap fitur untuk kode yang dapat dipelihara jangka panjang.
2.  **AI Integration**:
    *   *Chatbot Gizi (NutriBot)* ditenagai Gemini AI untuk tanya-jawab nutrisi dengan rendering teks Markdown di [chat_screen.dart](file:///c:/FIKKAN/project/Skills/NutriMove/nutrimove/lib/features/nutribot/presentation/screens/chat_screen.dart).
    *   *AI Food Scan (Computer Vision)* ditenagai Gemini Vision untuk identifikasi makanan berdasarkan foto kamera/galeri di [scan_result_screen.dart](file:///c:/FIKKAN/project/Skills/NutriMove/nutrimove/lib/features/scanner/presentation/screens/scan_result_screen.dart).
3.  **Tema Kesehatan & Gamifikasi**: Pilihan tema sehat (asisten gizi) dengan integrasi gamifikasi streak poin dan pencapaian lencana (badges).

---

## 📘 IV. DOKUMENTASI & PRESENTASI (BONUS TAMBAHAN)

Proyek ini dilengkapi dengan dokumentasi arsitektur sistem visual di dalam folder **`docs/diagrams/`**:
1.  **[Entity Relationship Diagram (ERD)](file:///c:/FIKKAN/project/Skills/NutriMove/nutrimove/docs/diagrams/erd.md)**: Gambaran tabel database relasional penuh Crow's Foot Notation.
2.  **[Use Case Diagram](file:///c:/FIKKAN/project/Skills/NutriMove/nutrimove/docs/diagrams/usecase.md)**: Interaksi 18 use cases sistem dengan 5 aktor.
3.  **[User Flow Diagram](file:///c:/FIKKAN/project/Skills/NutriMove/nutrimove/docs/diagrams/user_flow.md)**: Alur proses onboarding, scan makanan, dan chat NutriBot.
