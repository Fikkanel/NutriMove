# Entity Relationship Diagram (ERD) — NutriMove

Dokumen ini memuat Entity Relationship Diagram (ERD) untuk proyek **NutriMove**. ERD ini dimodelkan menggunakan standar **Crow's Foot Notation** relasional penuh untuk menggambarkan bagaimana data disimpan di Firestore (terpetakan secara logis ke struktur relasional) dan model lokal aplikasi.

```mermaid
erDiagram
    users {
        varchar id PK
        varchar email UK
        varchar display_name
        varchar photo_url
        decimal height
        decimal weight
        decimal target_calories
        decimal target_protein
        decimal target_carbs
        decimal target_fat
        varchar diet_goal
        boolean is_notifications_enabled
        varchar language
        timestamp created_at
        timestamp updated_at
    }

    daily_logs {
        varchar id PK
        varchar user_id FK
        date date
        decimal total_calories
        decimal total_protein
        decimal total_carbs
        decimal total_fat
        int streak_day
        timestamp created_at
        timestamp updated_at
    }

    meals {
        varchar id PK
        varchar daily_log_id FK
        varchar name
        varchar category
        decimal calories
        decimal protein
        decimal carbs
        decimal fat
        varchar grade
        varchar image_url
        decimal confidence
        timestamp scanned_at
        timestamp created_at
        timestamp updated_at
    }

    streaks {
        varchar id PK
        varchar user_id FK
        int current_streak
        int longest_streak
        timestamp last_log_date
        timestamp created_at
        timestamp updated_at
    }

    achievements {
        varchar id PK
        varchar user_id FK
        varchar title
        text description
        varchar icon_name
        boolean is_unlocked
        timestamp unlocked_at
        varchar type
        int target_value
        int current_value
        timestamp created_at
        timestamp updated_at
    }

    chat_histories {
        varchar id PK
        varchar user_id FK
        text message_text
        boolean is_user
        timestamp message_timestamp
        timestamp created_at
    }

    food_database {
        varchar id PK
        varchar name UK
        varchar category
        decimal calories_per_100g
        decimal protein_per_100g
        decimal carbs_per_100g
        decimal fat_per_100g
        decimal fiber_per_100g
        decimal sugar_per_100g
        decimal sodium_per_100g
        timestamp created_at
        timestamp updated_at
    }

    allergens {
        varchar id PK
        varchar name UK
    }

    user_allergens {
        varchar user_id FK
        varchar allergen_id FK
    }

    meal_allergens {
        varchar meal_id FK
        varchar allergen_id FK
    }

    food_allergens {
        varchar food_id FK
        varchar allergen_id FK
    }

    users ||--o{ daily_logs : "records"
    daily_logs ||--|{ meals : "contains"
    users ||--|| streaks : "has"
    users ||--o{ achievements : "earns"
    users ||--o{ chat_histories : "sends"

    users ||--o{ user_allergens : "configures"
    allergens ||--o{ user_allergens : "referenced_by"

    meals ||--o{ meal_allergens : "contains"
    allergens ||--o{ meal_allergens : "flagged_in"

    food_database ||--o{ food_allergens : "contains"
    allergens ||--o{ food_allergens : "flagged_in"
```

## Deskripsi Entitas & Pemetaan Bidang

### 1. `users`
Menyimpan data profil utama pengguna NutriMove. Kolom target makronutrisi (`target_calories`, `target_protein`, `target_carbs`, `target_fat`) diisi berdasarkan tujuan diet (`diet_goal`) dan data fisik (`height`, `weight`).

### 2. `daily_logs`
Menyimpan riwayat gizi harian yang dikonsumsi oleh pengguna. Document ID pada Firestore dipetakan sebagai format tanggal ISO 8601 (`YYYY-MM-DD`). Berisi agregasi kalori dan makronutrisi dari makanan yang disantap pada hari tersebut.

### 3. `meals`
Menyimpan rincian setiap makanan yang dimakan oleh pengguna. Entitas ini terhubung ke `daily_logs` melalui `daily_log_id`. Menampung metadata AI hasil pemindaian seperti `confidence` dan `grade` (A/B/C/D).

### 4. `streaks`
Menyimpan data gamifikasi streak harian pengguna. Setiap pengguna memiliki satu baris data streak yang melacak `current_streak` dan `longest_streak`.

### 5. `achievements`
Menyimpan daftar pencapaian/lencana (*badges*) yang dapat diraih pengguna. Melacak progress (`current_value` terhadap `target_value`) dan status keterbukaannya (`is_unlocked`).

### 6. `chat_histories`
Menyimpan riwayat percakapan pengguna dengan **NutriBot AI**.

### 7. `food_database`
Tabel master gizi makanan Indonesia (read-only bagi pengguna) yang digunakan sebagai referensi pencocokan offline/hybrid.

### 8. `allergens` (dan Tabel Pivot)
Tabel master jenis alergen (misal: kacang, seafood, gluten). Hubungan antara Pengguna, Makanan, dan Database Master Makanan dengan Alergen dimodelkan secara many-to-many lewat tabel pembantu:
- `user_allergens`: Alergen yang dihindari oleh pengguna.
- `meal_allergens`: Alergen yang terdeteksi pada makanan yang dicatat pengguna.
- `food_allergens`: Alergen bawaan pada database makanan master.
