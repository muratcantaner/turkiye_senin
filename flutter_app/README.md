# Türkiye Senin - Flutter Mobile App

A comprehensive Flutter mobile application for managing municipal events, scholarships, and user registrations. This app connects to the Türkiye Senin backend API.

## Features

- **User Authentication**: JWT-based secure login and registration
- **Event Management**: Browse, view details, and register for municipal events
- **My Events**: Track registered events
- **Scholarship System**: Browse and apply for educational scholarships
- **Council Information**: View municipal councils and their organized events
- **User Profile**: Manage account information
- **🔥 God Mode**: Bypass all backend checks with mock data for frontend testing

## Prerequisites

- Flutter SDK (>=3.0.0)
- Dart SDK
- Android Studio / Xcode (for mobile development)
- Türkiye Senin Backend API running

## Setup Instructions

### 1. Install Flutter

Follow the official Flutter installation guide:
https://docs.flutter.dev/get-started/install

### 2. Clone and Setup

If starting fresh, create the Flutter project:

```bash
cd c:\Users\1903022325\source\repos\turkiye_senin
flutter create flutter_app
```

Then replace the `lib` folder and `pubspec.yaml` with the provided files.

### 3. Install Dependencies

```bash
cd flutter_app
flutter pub get
```

### 4. Configure Backend URL

Update the API base URL in `lib/utils/constants.dart`:

```dart
static const String baseUrl = 'http://YOUR_BACKEND_IP:8000';
```

**Important**: 
- For Android emulator: Use `http://10.0.2.2:8000`
- For iOS simulator: Use `http://localhost:8000`
- For physical device: Use your computer's local IP (e.g., `http://192.168.1.x:8000`)

### 5. Run the App

```bash
# List available devices
flutter devices

# Run on connected device
flutter run

# Or run in debug mode
flutter run -d <device_id>
```

## 🔥 God Mode - Frontend Development Without Backend

**God Mode** allows you to test and develop the frontend without needing a running backend API. It bypasses all authentication and database checks, returning mock data instantly.

### Enable God Mode

Open `lib/utils/constants.dart` and set:

```dart
class AppConfig {
  static const bool godMode = true;  // ✅ Enabled
}
```

### What God Mode Does

When enabled, the app will:
- ✅ **Auto-login**: Any email/password combination instantly succeeds
- ✅ **Mock Data**: Returns sample events, scholarships, councils, and users
- ✅ **Instant Responses**: No network delays (300ms simulated delay for realism)
- ✅ **No Errors**: All API calls succeed instantly
- ✅ **Full Navigation**: Browse all screens and features freely

### Mock Data Included

- **User**: Test Kullanıcı (test@example.com)
- **Events**: 5 sample events across different categories
- **Scholarships**: 4 scholarships (including 1 expired)
- **Councils**: 5 municipal councils
- **User Events**: 2 pre-registered events

### Disable God Mode for Production

When ready to connect to the real backend:

```dart
class AppConfig {
  static const bool godMode = false;  // ❌ Disabled - uses real API
}
```

Then configure your backend URL in `ApiConstants.baseUrl`.

## Project Structure

```
flutter_app/
├── lib/
│   ├── main.dart                          # App entry point
│   ├── models/                            # Data models
│   │   ├── user.dart
│   │   ├── event.dart
│   │   ├── scholarship.dart
│   │   ├── council.dart
│   │   └── registration.dart
│   ├── services/                          # API & Storage services
│   │   ├── api_service.dart
│   │   └── storage_service.dart
│   ├── providers/                         # State management
│   │   ├── auth_provider.dart
│   │   ├── event_provider.dart
│   │   ├── scholarship_provider.dart
│   │   └── council_provider.dart
│   ├── screens/                           # UI screens
│   │   ├── auth/                         # Authentication screens
│   │   ├── home/                         # Home & navigation
│   │   ├── events/                       # Event screens
│   │   ├── scholarships/                 # Scholarship screens
│   │   ├── councils/                     # Council screens
│   │   └── profile/                      # User profile
│   ├── widgets/                           # Reusable widgets
│   │   ├── event_card.dart
│   │   ├── scholarship_card.dart
│   │   ├── council_card.dart
│   │   └── custom_button.dart
│   └── utils/                             # Utilities & constants
│       ├── constants.dart                # API config & God Mode toggle
│       ├── validators.dart               # Form validators
│       └── mock_data.dart                # Mock data for God Mode
├── pubspec.yaml                           # Dependencies
└── README.md                              # This file
```

## Key Dependencies

- **provider**: State management
- **http**: API communication
- **shared_preferences**: Local storage for auth tokens
- **intl**: Date/time formatting (Turkish locale)
- **url_launcher**: Open scholarship URLs

## API Integration

The app communicates with the backend through the following endpoints:

### Authentication
- `POST /auth/register` - User registration
- `POST /auth/login` - User login

### Events
- `GET /events/` - List all events
- `GET /events/{id}` - Event details
- `POST /events/{id}/register` - Register for event
- `DELETE /events/{id}/register` - Unregister from event

### Users
- `GET /users/me` - Current user profile
- `GET /users/me/events` - User's registered events

### Scholarships
- `GET /scholarships/` - List all scholarships

### Councils
- `GET /councils/` - List all councils
- `GET /councils/{id}/events` - Council's events

## Building for Release

### Android

```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

### iOS

```bash
flutter build ios --release
```

## Troubleshooting

### Network Issues

If you get network errors:
1. Ensure backend is running
2. Check `baseUrl` in `constants.dart`
3. For Android, add network permissions in `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
```

### Build Errors

```bash
flutter clean
flutter pub get
flutter run
```

### Hot Reload Not Working

Press `r` in terminal or use IDE hot reload button.

## Features Overview

### Authentication
- Secure JWT token-based authentication
- Persistent login with token storage
- Profile management

### Events
- Browse all municipal events
- Filter by category
- View detailed event information
- Register/unregister for events
- Track registered events

### Scholarships
- Browse available scholarships
- View application deadlines
- Direct links to application forms

### Councils
- View all municipal councils
- Browse events by council
- Council contact information

## Development

### Adding New Features

1. Create model in `models/`
2. Add API methods in `services/api_service.dart`
3. Create provider in `providers/`
4. Build UI screens in `screens/`
5. Add reusable widgets in `widgets/`

### State Management

The app uses Provider for state management:
- `AuthProvider`: User authentication state
- `EventProvider`: Events data
- `ScholarshipProvider`: Scholarships data
- `CouncilProvider`: Councils data

## Contributing

1. Follow Flutter style guide
2. Use meaningful commit messages
3. Test on both Android and iOS
4. Ensure Turkish localization is correct

## License

MIT License

## Support

For issues and questions:
- Backend API: See `backend/README.md`
- Flutter issues: Check Flutter documentation
