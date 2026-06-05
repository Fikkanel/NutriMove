# Dokumentasi Arsitektur & Diagram NutriMove

Sesuai dengan pedoman standardisasi dokumentasi visual di proyek NutriMove, seluruh diagram sistem (ERD, Use Case, dan User Flow) telah dipindahkan dan dikelompokkan ke dalam direktori resmi `docs/diagrams/`.

Silakan akses masing-masing diagram yang terbaru melalui tautan di bawah ini:

---

## 📂 Struktur Berkas Diagram

1. **[Entity Relationship Diagram (ERD)](docs/diagrams/erd.md)**
   * **Deskripsi**: Struktur hubungan data relasional penuh untuk pengguna, logs harian, makanan (meals), data streak, achievements, riwayat chatbot, database makanan master, dan relasi many-to-many untuk penanganan alergen.
   * **Format**: Mermaid (Crow's Foot Notation).

2. **[Use Case Diagram](docs/diagrams/usecase.md)**
   * **Deskripsi**: Interaksi antara 5 Aktor utama/pendukung dengan 18 Use Case sistem, lengkap dengan deskripsi relasi ketergantungan `<<include>>` dan `<<extend>>`.
   * **Format**: Mermaid Flowchart.

3. **[User Flow (Alur Aplikasi)](docs/diagrams/user_flow.md)**
   * **Deskripsi**: Alur kerja navigasi aplikasi yang terdiri dari tiga sub-flow utama: Autentikasi & Setup Profil (AHP), Hybrid AI Food Scanner (TOPSIS), dan Obrolan NutriBot AI (dengan Groq Fallback).
   * **Format**: Mermaid Flowchart dengan garis lurus (`curve: linear`).

4. **[Indeks Utama Diagram](docs/diagrams/README.md)**
   * **Deskripsi**: Indeks ringkas yang memuat semua informasi pembacaan dan rendering Mermaid.

---

## 🚀 Cara Membuka & Merender Diagram
Anda dapat membaca berkas-berkas di atas langsung dari editor Markdown favorit Anda (VS Code, Obsidian) dengan mengaktifkan rendering Mermaid, atau melihatnya langsung saat diunggah ke repositori GitHub/GitLab.
