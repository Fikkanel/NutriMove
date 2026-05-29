# Software Requirements Specification (SRS) — NutriMove

> **Version:** 1.0 | **Date:** 2026-05-15 | **Status:** Approved

## 1. Pendahuluan

### 1.1 Tujuan
Dokumen ini mendefinisikan kebutuhan perangkat lunak untuk aplikasi NutriMove — asisten nutrisi pintar berbasis mobile.

### 1.2 Ruang Lingkup
NutriMove adalah aplikasi cross-platform (Android & iOS) yang membantu pengguna mengelola asupan nutrisi harian melalui AI food scanning, penilaian NutriGrade, dan rekomendasi menu personal.

### 1.3 Referensi
- Project Brief NutriMove
- Flutter Documentation v3.41.1
- Firebase Documentation

## 2. Deskripsi Umum

### 2.1 Perspektif Produk
Aplikasi standalone yang terhubung ke Firebase backend untuk autentikasi dan penyimpanan data.

### 2.2 Fungsi Utama
1. Autentikasi pengguna (email/password)
2. Scan makanan via kamera (AI Computer Vision)
3. Penilaian kualitas nutrisi (NutriGrade A-D)
4. Dashboard tracking kalori harian
5. Rekomendasi menu personal (Fuzzy AHP + TOPSIS)
6. Chatbot konsultasi nutrisi (NutriBot)
7. Gamifikasi streak harian

### 2.3 Pengguna
- Individu yang ingin mengelola diet
- Usia 18-55 tahun
- Familiar dengan smartphone

### 2.4 Batasan
- Memerlukan koneksi internet untuk fitur chat dan sync data
- Akurasi AI bergantung pada kualitas model TFLite

## 3. Kebutuhan Fungsional

### FR-01: Registrasi & Login
- Pengguna dapat registrasi dengan email dan password
- Pengguna dapat login dengan kredensial yang terdaftar
- Pengguna dapat reset password via email

### FR-02: Setup Profil
- Pengguna mengisi tinggi, berat badan, alergen, dan target diet saat pertama kali

### FR-03: AI Food Scanning
- Pengguna dapat scan makanan melalui kamera
- Sistem mengidentifikasi jenis makanan dengan confidence score
- Sistem menampilkan estimasi nutrisi (kalori, protein, karbo, lemak)
- Pengguna dapat input manual sebagai fallback

### FR-04: NutriGrade
- Sistem menghitung grade A-D untuk setiap makanan
- Grade dihitung menggunakan Fuzzy AHP + TOPSIS
- Peringatan alergen ditampilkan jika relevan

### FR-05: Dashboard
- Menampilkan total kalori hari ini vs target
- Menampilkan breakdown macronutrient
- Menampilkan daftar makanan yang sudah di-log

### FR-06: Rekomendasi Menu
- Sistem merekomendasikan makanan sehat berdasarkan profil pengguna
- Ranking menggunakan TOPSIS

### FR-07: NutriBot
- Pengguna dapat bertanya tentang nutrisi
- Bot memberikan respons berbasis AI

### FR-08: Gamifikasi
- Streak harian bertambah setiap hari user log makanan
- Achievement badges di-unlock berdasarkan milestones

## 4. Kebutuhan Non-Fungsional

### NFR-01: Performance
- Splash screen < 3 detik
- Scan result < 5 detik
- UI response < 100ms

### NFR-02: Security
- Password encrypted (Firebase Auth)
- Data user di-isolasi per UID
- API keys di-obfuscate via dart-define

### NFR-03: Compatibility
- Android 6.0+
- iOS 15.0+
- Flutter 3.41.1

### NFR-04: Maintainability
- Clean Architecture pattern
- Code coverage minimum 60%
