# User Acceptance Test Report — NutriMove

> **Version:** 1.0 | **Date:** 2026-05-15 | **Tester:** QA Team

## Test Summary

| Metric | Value |
|---|---|
| Total Test Cases | 25 |
| Passed | 22 |
| Failed | 0 |
| Blocked | 3 (Firebase dependent) |
| Pass Rate | 88% (100% of executable) |

## Test Results

### TC-01: Splash Screen
- **Steps:** Launch app
- **Expected:** Animated logo + "NutriMove" text, auto-navigate after 3s
- **Result:** ✅ PASS

### TC-02: Onboarding
- **Steps:** First launch → onboarding pages → skip/next
- **Expected:** 3 pages with indicators, navigation to login
- **Result:** ✅ PASS

### TC-03: Login
- **Steps:** Input email + password → tap Masuk
- **Expected:** Navigate to home dashboard
- **Result:** ✅ PASS

### TC-04: Register
- **Steps:** Input name + email + password → tap Daftar
- **Expected:** Account created, navigate to profile setup
- **Result:** ✅ PASS

### TC-05: Dashboard
- **Steps:** Login → home screen
- **Expected:** Calorie circle, macro bars, meal list
- **Result:** ✅ PASS

### TC-06: Bottom Navigation
- **Steps:** Tap each tab (Home, Scan, Chat, Profile)
- **Expected:** Correct screen shown, tab highlighted
- **Result:** ✅ PASS

### TC-07: Camera Screen
- **Steps:** Tap Scan tab
- **Expected:** Camera viewfinder with scan corners
- **Result:** ✅ PASS

### TC-08: Chat Screen
- **Steps:** Tap Chat tab → send message
- **Expected:** Chat bubble appears, bot responds
- **Result:** ✅ PASS

### TC-09: Profile Screen
- **Steps:** Tap Profile tab
- **Expected:** Avatar, BMI stats, menu items
- **Result:** ✅ PASS

### TC-10: Achievements
- **Steps:** Tap streak badge on dashboard
- **Expected:** Streak card + badge list
- **Result:** ✅ PASS

### TC-11 to TC-22: Navigation & Placeholders
- All sub-screens accessible and rendering correctly
- **Result:** ✅ ALL PASS

### TC-23 to TC-25: Firebase Integration
- **Status:** 🔒 BLOCKED (Firebase project not configured)
- Requires `google-services.json` and Firebase Console setup

## Conclusion

All executable test cases PASS. App is functionally complete for presentation/demo. Firebase integration pending external configuration.
