# 🔥 God Mode - Quick Start Guide

## What is God Mode?

God Mode is a development feature that allows you to **test the entire Flutter frontend without needing a backend server**. Perfect for:
- Frontend UI/UX development
- Testing navigation flows
- Demonstrating features
- Learning the app structure

## How to Use

### 1. Enable God Mode (Already Enabled!)

God Mode is **currently enabled** by default in `lib/utils/constants.dart`:

```dart
class AppConfig {
  static const bool godMode = true;  // ✅ ENABLED
}
```

### 2. Run the App

```bash
cd c:\Users\1903022325\source\repos\turkiye_senin\flutter_app

# Windows Desktop
flutter run -d windows

# Or Chrome Web
flutter run -d chrome

# Or Android Emulator
flutter run
```

### 3. Login with Any Credentials

When God Mode is enabled:
- **Email**: Any email (e.g., `test@test.com`)
- **Password**: Any password (e.g., `123456`)
- **Result**: Instant login success! ✨

### 4. Explore All Features

All screens work with mock data:
- ✅ **Events Tab**: 5 sample events you can browse
- ✅ **My Events Tab**: 2 pre-registered events
- ✅ **Scholarships Tab**: 4 scholarship listings
- ✅ **Councils Tab**: 5 municipal councils
- ✅ **Profile Tab**: View mock user profile
- ✅ **Event Registration**: Click buttons - they all work!

## Mock Data Details

### Sample User
- Name: Test Kullanıcı
- Email: test@example.com

### Sample Events (5 total)
1. Yazılım Geliştirme Atölyesi - Free, 50 spots
2. Gençlik Konferansı 2024 - 100 TL, 200 spots
3. Spor Festivali - Free, 500 spots
4. Kariyer Günleri - 50 TL, 150 spots
5. Kültür ve Sanat Festivali - Free, unlimited

### Sample Councils (5 total)
- Ankara, İstanbul, İzmir, Bursa, Antalya

### Sample Scholarships (4 total)
- 3 active scholarships
- 1 expired scholarship (for testing expired state)

## What Gets Bypassed

When God Mode is ON, these happen instantly without backend:
- ✅ User registration → Returns mock token
- ✅ User login → Returns mock token
- ✅ Get current user → Returns Test Kullanıcı
- ✅ Fetch events → Returns 5 mock events
- ✅ Fetch user events → Returns 2 registered events
- ✅ Event registration → Instant success
- ✅ Event unregistration → Instant success
- ✅ Fetch scholarships → Returns 4 scholarships
- ✅ Fetch councils → Returns 5 councils
- ✅ Fetch council events → Returns filtered events

## When to Disable God Mode

Disable God Mode when you're ready to connect to the real backend:

```dart
class AppConfig {
  static const bool godMode = false;  // ❌ DISABLED
}
```

Then configure the backend URL:

```dart
class ApiConstants {
  static const String baseUrl = 'http://10.0.2.2:8000';  // Your backend
}
```

## Files Modified for God Mode

1. **`lib/utils/constants.dart`** - God Mode toggle
2. **`lib/utils/mock_data.dart`** - All mock data
3. **`lib/services/api_service.dart`** - God Mode checks
4. **`lib/services/storage_service.dart`** - God Mode checks

## Tips

- **Realistic Feel**: Mock data includes 300ms delays to simulate network requests
- **No Errors**: All operations succeed in God Mode
- **Hot Reload Works**: Change `godMode = true/false` and hot reload
- **Safe Testing**: No real data is affected

---

**Current Status**: 🔥 God Mode is **ENABLED** - Start testing immediately!
