# 📊 Dokumentasi Diagram Sistem NutriMove

Direktori ini berisi pemodelan visual dan alur proses utama untuk aplikasi **NutriMove**. Diagram dibuat menggunakan sintaks **Mermaid** yang terintegrasi secara bawaan dengan Github, Notion, dan berbagai penampil Markdown modern.

---

## 📂 Daftar Diagram yang Tersedia

Silakan klik tautan di bawah ini untuk melihat masing-masing diagram secara terperinci:

### 1. 🗄️ [Entity Relationship Diagram (ERD)](erd.md)
* **Deskripsi**: Diagram hubungan entitas database (Firestore & model lokal) menggunakan standar **Crow's Foot Notation** relasional penuh.
* **Fokus**: Melacak profil user, daily logs gizi, pencatatan makanan, tracking streak harian, daftar achievements, riwayat obrolan bot, dan relasi multi-kondisi many-to-many untuk jenis alergen.
* **Tautan Berkas**: [erd.md](erd.md)

### 2. 🎭 [Use Case Diagram](usecase.md)
* **Deskripsi**: Diagram pemetaan interaksi fungsionalitas sistem antara **5 Aktor** dengan **18 Use Case** utama, lengkap dengan pemetaan hubungan `<<include>>` (kewajiban alur) dan `<<extend>>` (kondisional opsional).
* **Fokus**: Pendaftaran, autentikasi, pengisian profil kesehatan fisik, pemindaian AI hybrid, manual logging, riwayat gizi, gamifikasi, konsultasi chat, hingga pengaturan profil.
* **Tautan Berkas**: [usecase.md](usecase.md)

### 3. 🔄 [User Flow (Alur Aplikasi)](user_flow.md)
* **Deskripsi**: Diagram alir navigasi langkah-demi-langkah aktivitas pengguna di dalam aplikasi NutriMove. 
* **Fokus**:
  - Alur Autentikasi & Inisialisasi Profil (setup target via AHP)
  - Alur AI Food Scanner & Pencatatan (hybrid scan & pencocokan database lokal)
  - Alur NutriBot AI Chat (dengan integrasi sistem Groq Fallback)
* **Catatan**: Semua flowchart dirancang menggunakan konfigurasi garis lurus (`curve: linear`) untuk mempermudah pembacaan.
* **Tautan Berkas**: [user_flow.md](user_flow.md)

---

## 🛠️ Cara Merender atau Melihat Diagram

Semua diagram disimpan dalam format teks Markdown berbasis Mermaid. Anda dapat melihatnya langsung di:
1. **GitHub / GitLab**: Diterjemahkan secara otomatis dalam tampilan repositori.
2. **VS Code**: Pasang ekstensi *Markdown Preview Mermaid Support* lalu tekan `Ctrl + Shift + V` pada berkas `.md` yang dipilih.
3. **Notion**: Tempelkan kode blok Mermaid langsung ke dalam halaman Notion Anda.
4. **Mermaid Live Editor**: Salin blok kode dari file dan tempel di [mermaid.live](https://mermaid.live).
