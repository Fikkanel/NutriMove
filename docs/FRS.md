# Functional Requirements Specification (FRS) — NutriMove

> **Version:** 1.0 | **Date:** 2026-05-15

## Module 1: Authentication

| ID | Requirement | Input | Output | Priority |
|---|---|---|---|---|
| AUTH-01 | User dapat registrasi | name, email, password | User account created | P0 |
| AUTH-02 | User dapat login | email, password | Auth token, redirect to home | P0 |
| AUTH-03 | User dapat reset password | email | Reset email sent | P0 |
| AUTH-04 | User dapat logout | - | Session cleared | P0 |
| AUTH-05 | User setup profil awal | height, weight, allergens, goal | Profile saved | P0 |

## Module 2: AI Food Scanner

| ID | Requirement | Input | Output | Priority |
|---|---|---|---|---|
| SCAN-01 | Scan makanan via kamera | Camera image | Food identification + confidence | P0 |
| SCAN-02 | Tampilkan estimasi nutrisi | Food ID | Calories, protein, carbs, fat | P0 |
| SCAN-03 | Input manual makanan | name, calories, macros | FoodItem saved | P0 |
| SCAN-04 | Simpan ke daily log | FoodItem | Log updated, streak checked | P0 |

## Module 3: NutriGrade System

| ID | Requirement | Input | Output | Priority |
|---|---|---|---|---|
| GRADE-01 | Hitung criteria weights | Fuzzy comparison matrix | Normalized weights | P1 |
| GRADE-02 | Rank makanan dengan TOPSIS | Food nutrition data, weights | Ranked score + Grade (A-D) | P1 |
| GRADE-03 | Tampilkan grade card | Grade, score | Visual card with color | P1 |
| GRADE-04 | Cek alergen | Food allergens, user allergens | Warning if match | P1 |

## Module 4: Dashboard

| ID | Requirement | Input | Output | Priority |
|---|---|---|---|---|
| DASH-01 | Tampilkan kalori hari ini | User ID, date | CircularProgress + kcal | P0 |
| DASH-02 | Tampilkan macronutrient | Protein, carbs, fat | Progress bars | P0 |
| DASH-03 | Tampilkan meal timeline | Daily log | List of meals with grade | P0 |
| DASH-04 | Laporan mingguan | 7-day data | Summary + charts | P1 |

## Module 5: Gamification

| ID | Requirement | Input | Output | Priority |
|---|---|---|---|---|
| GAM-01 | Tracking daily streak | Meal logged | Streak +1 | P1 |
| GAM-02 | Reset streak jika skip | Midnight check | Streak = 0 | P1 |
| GAM-03 | Unlock achievements | Milestone reached | Badge unlocked | P1 |
| GAM-04 | Tampilkan achievement list | User ID | Grid of badges | P1 |

## Module 6: NutriBot

| ID | Requirement | Input | Output | Priority |
|---|---|---|---|---|
| BOT-01 | User kirim pesan | Text message | Bot response | P1 |
| BOT-02 | Suggestion chips | - | Quick question options | P1 |
| BOT-03 | Chat history | Session | Message list | P2 |

## Module 7: Profile & Settings

| ID | Requirement | Input | Output | Priority |
|---|---|---|---|---|
| PROF-01 | Tampilkan profil | User ID | Name, BMI, stats | P1 |
| PROF-02 | Edit profil | Updated data | Profile updated | P1 |
| PROF-03 | Atur alergen | Allergen list | Saved to Firestore | P1 |
| PROF-04 | Atur target diet | Goal, target kcal | Saved to Firestore | P1 |
