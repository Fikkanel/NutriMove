# Database Schema — NutriMove (Firestore)

## Collections

### 1. `users`

| Field | Type | Description |
|---|---|---|
| `uid` | string | Firebase Auth UID (document ID) |
| `email` | string | Email pengguna |
| `displayName` | string | Nama tampilan |
| `photoUrl` | string? | URL foto profil |
| `height` | number | Tinggi badan (cm) |
| `weight` | number | Berat badan (kg) |
| `targetCalories` | number | Target kalori harian (kcal) |
| `targetProtein` | number | Target protein (g) |
| `targetCarbs` | number | Target karbohidrat (g) |
| `targetFat` | number | Target lemak (g) |
| `allergens` | array\<string\> | Daftar alergen |
| `dietGoal` | string | 'lose', 'maintain', 'gain' |
| `notificationsEnabled` | boolean | Status notifikasi |
| `language` | string | Bahasa (default: 'id') |
| `createdAt` | timestamp | Waktu registrasi |

### 2. `users/{uid}/daily_logs`

| Field | Type | Description |
|---|---|---|
| `date` | string | ISO 8601 date (document ID) |
| `totalCalories` | number | Total kalori hari ini |
| `totalProtein` | number | Total protein (g) |
| `totalCarbs` | number | Total karbo (g) |
| `totalFat` | number | Total lemak (g) |
| `streakDay` | number | Hari ke-N streak |

### 3. `users/{uid}/daily_logs/{date}/meals`

| Field | Type | Description |
|---|---|---|
| `id` | string | Auto-generated ID |
| `name` | string | Nama makanan |
| `calories` | number | Kalori (kcal) |
| `protein` | number | Protein (g) |
| `carbs` | number | Karbohidrat (g) |
| `fat` | number | Lemak (g) |
| `grade` | string | NutriGrade (A/B/C/D) |
| `imageUrl` | string? | URL foto makanan |
| `confidence` | number | Confidence AI (0-1) |
| `scannedAt` | timestamp | Waktu scan |

### 4. `users/{uid}/streaks`

| Field | Type | Description |
|---|---|---|
| `currentStreak` | number | Streak saat ini |
| `longestStreak` | number | Streak terpanjang |
| `lastLogDate` | timestamp | Tanggal log terakhir |

### 5. `users/{uid}/achievements`

| Field | Type | Description |
|---|---|---|
| `id` | string | Achievement ID |
| `title` | string | Judul achievement |
| `description` | string | Deskripsi |
| `type` | string | 'streak', 'scan', 'grade', 'meals' |
| `targetValue` | number | Target untuk unlock |
| `currentValue` | number | Progress saat ini |
| `unlocked` | boolean | Status unlock |
| `unlockedAt` | timestamp? | Waktu unlock |

### 6. `users/{uid}/chat_history`

| Field | Type | Description |
|---|---|---|
| `id` | string | Message ID |
| `text` | string | Isi pesan |
| `isUser` | boolean | true = user, false = bot |
| `timestamp` | timestamp | Waktu pesan |

### 7. `food_database` (Read-only)

| Field | Type | Description |
|---|---|---|
| `name` | string | Nama makanan |
| `category` | string | Kategori (nasi, sayur, dll) |
| `caloriesPer100g` | number | Kalori per 100g |
| `protein` | number | Protein per 100g |
| `carbs` | number | Karbo per 100g |
| `fat` | number | Lemak per 100g |
| `fiber` | number | Serat per 100g |
| `sugar` | number | Gula per 100g |
| `sodium` | number | Sodium (mg) |
| `allergens` | array\<string\> | Kandungan alergen |

## Firestore Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users: only owner can read/write
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
      
      match /{subcollection=**} {
        allow read, write: if request.auth != null && request.auth.uid == userId;
      }
    }
    
    // Food database: authenticated users can read
    match /food_database/{docId} {
      allow read: if request.auth != null;
      allow write: if false; // Admin only via console
    }
  }
}
```
