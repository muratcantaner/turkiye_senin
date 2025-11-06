# Complete Setup Guide - Türkiye Senin App

## 🎯 Two Ways to Test the App

### Option 1: God Mode (Frontend Only) - EASIEST ✨
Test the frontend immediately without setting up the backend.

### Option 2: Full Stack (Backend + Frontend)
Connect to a real backend API for production testing.

---

## ✨ Option 1: God Mode Testing (Recommended for Frontend Development)

### Step 1: Verify God Mode is Enabled

Open `flutter_app/lib/utils/constants.dart` and confirm:

```dart
class AppConfig {
  static const bool godMode = true;  // ✅ Should be true
}
```

### Step 2: Run the App

```bash
cd c:\Users\1903022325\source\repos\turkiye_senin\flutter_app

# Run on Windows
flutter run -d windows

# OR run on Chrome
flutter run -d chrome
```

### Step 3: Login with Any Credentials

- Email: `anything@test.com`
- Password: `123456`
- Click "Giriş Yap"

**✅ You're in!** All features work with mock data.

### What You Can Test
- Browse 5 sample events
- Register/unregister for events
- View "Etkinliklerim" (registered events)
- Browse 4 scholarships
- View 5 councils
- View user profile
- All navigation and UI

---

## 🔧 Option 2: Full Stack Setup (Backend + Frontend)

### Backend Setup

#### 1. Navigate to Backend Directory

```bash
cd c:\Users\1903022325\source\repos\turkiye_senin
```

#### 2. Create Python Virtual Environment

```bash
# Create venv
python -m venv venv

# Activate venv (Windows PowerShell)
.\venv\Scripts\Activate.ps1

# OR activate venv (Windows CMD)
.\venv\Scripts\activate.bat
```

#### 3. Install Backend Dependencies

```bash
pip install fastapi uvicorn sqlalchemy pydantic python-jose[cryptography] passlib[bcrypt] python-multipart
```

#### 4. Initialize Database

```bash
# If you have alembic migrations
alembic upgrade head

# OR if using SQLite with create_all
python -c "from app.database import engine, Base; from app.models import *; Base.metadata.create_all(bind=engine)"
```

#### 5. Start Backend Server

```bash
# Start FastAPI server
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

**Backend should now be running at:** `http://localhost:8000`

You can verify by visiting: `http://localhost:8000/docs` (API documentation)

---

### Frontend Setup with Backend

#### 1. Disable God Mode

Open `flutter_app/lib/utils/constants.dart`:

```dart
class AppConfig {
  static const bool godMode = false;  // ❌ Disable for real API
}
```

#### 2. Configure Backend URL

In the same file, update `ApiConstants.baseUrl`:

```dart
class ApiConstants {
  // For Android Emulator
  static const String baseUrl = 'http://10.0.2.2:8000';
  
  // For iOS Simulator
  // static const String baseUrl = 'http://localhost:8000';
  
  // For Windows/Chrome/Physical Device
  // static const String baseUrl = 'http://YOUR_COMPUTER_IP:8000';
  // Example: 'http://192.168.1.100:8000'
}
```

**Finding Your Computer's IP (for physical devices):**

```bash
# Windows
ipconfig
# Look for "IPv4 Address" under your active network adapter

# Example: 192.168.1.100
```

#### 3. Run Flutter App

```bash
cd c:\Users\1903022325\source\repos\turkiye_senin\flutter_app

# Run on your target device
flutter run
```

#### 4. Create a Real Account

Now on the app:
1. Click "Kayıt Ol" (Register)
2. Fill in real information:
   - First Name: Your name
   - Last Name: Your surname
   - Email: valid email
   - Password: secure password
3. Click "Kayıt Ol"
4. Login with your credentials

---

## 📱 Running on Different Devices

### Windows Desktop
```bash
flutter run -d windows
```

### Chrome Browser
```bash
flutter run -d chrome
```

### Android Emulator
```bash
# Start Android emulator first from Android Studio
# Then:
flutter run
```

### Physical Android Device
1. Enable USB Debugging on your phone
2. Connect via USB
3. Configure backend URL to use your computer's IP
4. Run:
```bash
flutter run
```

---

## 🐛 Troubleshooting

### Issue: "Connection refused" or "Network error"

**Check:**
1. Backend is running: Visit `http://localhost:8000/docs`
2. Firewall isn't blocking port 8000
3. Correct IP address in `ApiConstants.baseUrl`
4. For Android emulator, use `10.0.2.2` instead of `localhost`

### Issue: "Locale data has not been initialized"

**Fixed!** Make sure `main.dart` has:
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('tr_TR', null);
  runApp(const MyApp());
}
```

### Issue: App crashes on startup

1. Check terminal for error messages
2. Run `flutter clean && flutter pub get`
3. Restart the app
4. Enable God Mode for testing without backend

### Issue: "No devices connected"

```bash
# List available devices
flutter devices

# Run on specific device
flutter run -d <device_id>
```

---

## 🔄 Switching Between Modes

### God Mode → Real Backend

1. Set `AppConfig.godMode = false` in `constants.dart`
2. Configure `ApiConstants.baseUrl`
3. Make sure backend is running
4. Hot restart app (press `R` in terminal)

### Real Backend → God Mode

1. Set `AppConfig.godMode = true` in `constants.dart`
2. Hot restart app (press `R` in terminal)
3. Backend not needed anymore!

---

## 📊 Testing Checklist

### God Mode Testing (Frontend)
- [ ] App launches successfully
- [ ] Can login with any credentials
- [ ] Events list displays 5 events
- [ ] Can view event details
- [ ] Can register/unregister for events
- [ ] "Etkinliklerim" shows registered events
- [ ] Scholarships list displays 4 items
- [ ] Councils list displays 5 councils
- [ ] Profile shows user information
- [ ] All navigation works smoothly

### Full Stack Testing (Backend + Frontend)
- [ ] Backend API docs accessible at `/docs`
- [ ] Can create new account (register)
- [ ] Can login with created account
- [ ] Events load from real database
- [ ] Can register for events (saved to DB)
- [ ] User events persist after app restart
- [ ] Scholarships load from database
- [ ] Councils load from database
- [ ] Profile shows real user data
- [ ] Logout works correctly

---

## 🎓 Quick Reference

**Start Backend:**
```bash
cd c:\Users\1903022325\source\repos\turkiye_senin
.\venv\Scripts\Activate.ps1
uvicorn app.main:app --reload --port 8000
```

**Start Frontend (God Mode):**
```bash
cd c:\Users\1903022325\source\repos\turkiye_senin\flutter_app
flutter run -d windows
```

**Start Frontend (Real Backend):**
```bash
# 1. Disable God Mode in constants.dart
# 2. Make sure backend is running
cd c:\Users\1903022325\source\repos\turkiye_senin\flutter_app
flutter run -d windows
```

**Hot Reload:** Press `r` in terminal  
**Hot Restart:** Press `R` in terminal  
**Quit:** Press `q` in terminal

---

## ✅ Current Status

- ✅ God Mode is **ENABLED**
- ✅ Locale initialization **FIXED**
- ✅ setState during build **FIXED**
- ✅ App ready to run with mock data
- ⚠️ Backend setup required for production testing

**Ready to test!** Run `flutter run -d windows` now! 🚀
