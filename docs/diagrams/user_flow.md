# User Flow — NutriMove

Dokumen ini mendokumentasikan alur navigasi dan interaksi pengguna di dalam aplikasi NutriMove. Untuk kemudahan pemahaman, alur dibagi menjadi tiga diagram alur utama:
1. **Alur Autentikasi & Inisialisasi Profil**
2. **Alur AI Food Scanner & Pencatatan Makanan**
3. **Alur NutriBot AI Chat**

---

## 1. Alur Autentikasi & Inisialisasi Profil

Alur ini menjelaskan langkah pertama pengguna saat membuka aplikasi hingga diarahkan ke Dashboard utama.

```mermaid
%%{init: {"flowchart": {"curve": "linear"}} }%%
flowchart TD
    Start([Start: Buka Aplikasi]) --> CheckSession{User memiliki sesi aktif?}
    
    CheckSession -- Tidak --> OpenWelcome[User membuka Onboarding Screen]
    OpenWelcome --> ClickLogin[User klik Mulai / Login]
    ClickLogin --> InputAuth[/User input Email & Password/]
    
    InputAuth --> ClickAuthAction{Aksi yang dipilih?}
    ClickAuthAction -- Registrasi --> RegSubmit[System kirim data ke Firebase Auth]
    RegSubmit --> RegCheck{Registrasi sukses?}
    RegCheck -- Tidak --> ShowRegErr[System tampilkan error registrasi]
    ShowRegErr --> InputAuth
    RegCheck -- Ya --> FirestoreCreate[(Firestore simpan user record baru)]
    FirestoreCreate --> InputProfile
    
    ClickAuthAction -- Login --> LoginSubmit[System verifikasi via Firebase Auth]
    LoginSubmit --> LoginCheck{Verifikasi sukses?}
    LoginCheck -- Tidak --> ShowLoginErr[System tampilkan error password/email]
    ShowLoginErr --> InputAuth
    LoginCheck -- Ya --> FetchProfile[(System ambil data profil dari Firestore)]
    FetchProfile --> CheckProfileData{Profil lengkap?}
    
    CheckSession -- Ya --> FetchProfile
    
    CheckProfileData -- Tidak --> InputProfile[User diarahkan ke Profile Setup Screen]
    InputProfile --> FillPhysical[/User input Tinggi, Berat, Goal & Alergen/]
    FillPhysical --> CalculateTarget[System hitung target gizi harian via AHP]
    CalculateTarget --> SaveProfileData[(Firestore simpan profil kesehatan lengkap)]
    SaveProfileData --> OpenDashboard
    
    CheckProfileData -- Ya --> OpenDashboard[User diarahkan ke Dashboard Utama]
    OpenDashboard --> End([End: Home Screen aktif])
```

---

## 2. Alur AI Food Scanner & Pencatatan Makanan

Alur ini menjelaskan proses pemindaian makanan secara hybrid (lokal/Gemini) hingga data gizi tersimpan ke log harian.

```mermaid
%%{init: {"flowchart": {"curve": "linear"}} }%%
flowchart TD
    Start([Start: Dashboard Utama]) --> ClickScan[User klik tombol FAB Scan]
    ClickScan --> CaptureImage[User ambil foto makanan atau pilih galeri]
    CaptureImage --> TriggerHybrid{System jalankan hybrid scanner}
    
    TriggerHybrid -- Match Database Lokal --5ms--> CalcGrade[System hitung NutriGrade via TOPSIS]
    TriggerHybrid -- Tidak Match database lokal --> CallGemini[System kirim gambar ke Gemini Vision API]
    
    CallGemini --> GeminiCheck{AI berhasil identifikasi makanan?}
    GeminiCheck -- Tidak --> ShowAIError[System tampilkan pesan 'Makanan tidak dikenali']
    ShowAIError --> CaptureImage
    
    GeminiCheck -- Ya --> CalcGrade
    
    CalcGrade --> DisplayResult[User membuka Scan Result Screen]
    DisplayResult --> AdjustPortion{User mengubah porsi?}
    
    AdjustPortion -- Ya --> SliderAdjust[/User geser porsi slider/]
    SliderAdjust --> Recalculate[System hitung ulang kalori & makro]
    Recalculate --> DisplayResult
    
    AdjustPortion -- Tidak --> CheckAllergen{System mendeteksi alergen?}
    
    CheckAllergen -- Ya --> ShowAllergenAlert[System tampilkan Peringatan Alergen]
    ShowAllergenAlert --> ConfirmSave
    
    CheckAllergen -- Tidak --> ConfirmSave[User klik Simpan Data Makanan]
    
    ConfirmSave --> SaveToFirestore[(Firestore simpan makanan di subkoleksi meals)]
    SaveToFirestore --> UpdateTotals[(Firestore update total gizi harian daily_logs)]
    UpdateTotals --> TriggerGamification[System pemicu evaluasi streak & achievement]
    TriggerGamification --> AwardPoints[(SharedPrefs & Firestore perbarui data gamifikasi)]
    AwardPoints --> BackToDashboard[User kembali ke Dashboard Utama]
    BackToDashboard --> End([End: Dashboard terupdate])
```

---

## 3. Alur NutriBot AI Chat

Alur ini menjelaskan proses konsultasi interaktif antara pengguna dengan chatbot AI (NutriBot) yang dilengkapi sistem fallback.

```mermaid
%%{init: {"flowchart": {"curve": "linear"}} }%%
flowchart TD
    Start([Start: Dashboard Utama]) --> OpenChat[User membuka Halaman NutriBot]
    OpenChat --> RenderHistory[(System memuat riwayat pesan dari Firestore)]
    RenderHistory --> ChooseAction{Aksi Pengguna?}
    
    ChooseAction -- Klik Suggestion Chip --> SetInputText[/System isi kolom input dengan saran teks/]
    SetInputText --> SendMessage
    
    ChooseAction -- Mengetik Manual --> UserInput[/User mengetik pertanyaan pada input/]
    UserInput --> SendMessage[User klik tombol Kirim]
    
    SendMessage --> AppendUserMessage[System tampilkan chat bubble pengguna]
    AppendUserMessage --> SaveUserChat[(Firestore simpan pesan pengguna)]
    SaveUserChat --> ShowTyping[System tampilkan indikator mengetik bot]
    
    ShowTyping --> CallGeminiService[System kirim riwayat percakapan ke Gemini AI]
    CallGeminiService --> ServiceCheck{Gemini API merespons sukses?}
    
    ServiceCheck -- Ya --> FormatResponse[System render respons menggunakan Markdown]
    
    ServiceCheck -- Tidak: Error 429 / Limit --> CallGroqFallback[System alihkan request ke Groq AI Fallback]
    CallGroqFallback --> GroqCheck{Groq API merespons sukses?}
    
    GroqCheck -- Ya --> FormatResponse
    GroqCheck -- Gagal --> FormatError[System buat respons 'Koneksi sibuk, coba lagi nanti']
    
    FormatError --> DisplayBotMessage
    FormatResponse --> DisplayBotMessage[System tampilkan chat bubble NutriBot]
    
    DisplayBotMessage --> SaveBotChat[(Firestore simpan respons bot)]
    SaveBotChat --> EndChat[Kembali menunggu input baru]
    EndChat --> End([End: Percakapan terupdate])
```
