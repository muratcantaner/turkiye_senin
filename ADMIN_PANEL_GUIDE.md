# 🔐 Admin Panel Guide - Türkiye Senin

## Overview

The Türkiye Senin app now includes a full-featured admin panel for managing events. Admin users have access to a dedicated interface where they can create, edit, and delete events.

---

## 🎯 Admin Access

### Who Gets Admin Access?

In **God Mode**, any user logging in with an email ending in `.gov` or `.gov.tr` automatically gets admin privileges.

**Examples:**
- ✅ `admin@ankara.gov.tr` → Admin
- ✅ `user@istanbul.gov` → Admin
- ❌ `user@example.com` → Regular User
- ❌ `test@gmail.com` → Regular User

### In Production (Real Backend)

When God Mode is disabled, admin status is determined by the `is_admin` field in the backend database.

---

## 🚀 How to Access Admin Panel

### Option 1: Login with .gov Email (God Mode)

1. **Run the app** (God Mode must be enabled)
   ```bash
   flutter run -d windows
   ```

2. **Login with a .gov email**
   - Email: `admin@ankara.gov.tr`
   - Password: `any password` (in God Mode)
   - Click "Giriş Yap"

3. **Automatically routed to Admin Panel**
   - You'll see "Admin Paneli" instead of regular home screen
   - Orange "YÖNETİCİ" badge visible

### Option 2: Regular User Login

- Email: `test@example.com`
- Password: `any password`
- Routes to regular home screen

---

## 📋 Admin Panel Features

### Main Screen

The admin home screen displays:
- **Admin Info Card** - Shows your name, email, and admin badge
- **Event Count** - Total number of events
- **Events List** - All events with edit/delete buttons
- **Floating Action Button** - "Yeni Etkinlik" to create events

### Actions Available

#### 1. **Create Event** (➕ Button)

Click the floating "Yeni Etkinlik" button to open the event creation form.

**Form Fields:**
- **Etkinlik Adı*** (Event Name) - Required
- **Kategori*** (Category) - Required (e.g., Eğitim, Spor, Kültür)
- **Etkinlik Tarihi*** (Event Date) - Required, date + time picker
- **Konum*** (Location) - Required
- **Düzenleyen Meclis** (Organizing Council) - Optional dropdown
- **Ücretsiz Etkinlik** (Free Event) - Toggle switch
- **Fiyat** (Price) - Shows if not free
- **Katılımcı Limiti** (Participant Limit) - Optional

Click **"Oluştur"** to create the event.

#### 2. **Edit Event** (✏️ Icon)

- Click the blue edit icon next to any event
- Opens pre-filled form with existing event data
- Make changes
- Click **"Güncelle"** to save

#### 3. **Delete Event** (🗑️ Icon)

- Click the red delete icon next to any event
- Confirmation dialog appears
- Click **"Sil"** to confirm deletion
- Event removed instantly

#### 4. **Refresh** (🔄 Icon)

- Top-right refresh icon
- Reloads all events from the database
- Useful after making changes

#### 5. **Logout** (🚪 Icon)

- Top-right logout icon
- Confirmation dialog appears
- Returns to login screen

---

## 🔥 God Mode Behavior

### Mock Data Management

In God Mode, events are stored in memory (mock data):
- **Create**: Adds event to `MockData.mockEvents` list
- **Update**: Updates event in the list
- **Delete**: Removes event from the list
- **Changes persist** during the current app session
- **Changes reset** when app restarts

### Mock Admin User

```dart
User(
  id: 999,
  email: 'admin@ankara.gov.tr',
  firstName: 'Admin',
  lastName: 'Yönetici',
  isActive: true,
  isAdmin: true,
)
```

---

## 💡 Testing Scenarios

### Scenario 1: Admin Creates Event

1. Login with `admin@ankara.gov.tr`
2. See admin panel
3. Click "Yeni Etkinlik"
4. Fill form:
   - Name: "Test Etkinliği"
   - Category: "Test"
   - Date: Tomorrow
   - Location: "Test Mekanı"
   - Free: Yes
5. Click "Oluştur"
6. Event appears in list

### Scenario 2: Admin Edits Event

1. Click edit icon on any event
2. Change name to "Updated Event"
3. Change category
4. Click "Güncelle"
5. Changes reflected in list

### Scenario 3: Admin Deletes Event

1. Click delete icon on any event
2. Confirm deletion
3. Event removed from list
4. "Etkinlik silindi" message appears

### Scenario 4: Regular User vs Admin

1. Logout from admin
2. Login with `test@example.com`
3. See regular home screen (tabs at bottom)
4. No admin controls visible
5. Logout and login with `admin@ankara.gov.tr`
6. See admin panel again

---

## 🏗️ Technical Architecture

### Files Created

```
lib/
├── screens/
│   └── admin/
│       ├── admin_home_screen.dart      # Main admin interface
│       └── admin_event_form_screen.dart # Create/Edit event form
├── models/
│   └── user.dart                       # Added isAdminUser getter
├── providers/
│   └── event_provider.dart             # Added CRUD methods
├── services/
│   ├── api_service.dart                # Added admin API methods
│   └── storage_service.dart            # Updated for email-based auth
└── utils/
    ├── constants.dart                  # Added loginEmail storage key
    └── mock_data.dart                  # Added mock admin user
```

### Admin Routing Logic

**Splash Screen** (`splash_screen.dart`):
```dart
if (authProvider.isAuthenticated) {
  final isAdmin = authProvider.user?.isAdminUser ?? false;
  // Route to AdminHomeScreen or HomeScreen
}
```

**Login Screen** (`login_screen.dart`):
```dart
if (success) {
  final isAdmin = authProvider.user?.isAdminUser ?? false;
  // Navigate to appropriate screen
}
```

### Admin Check Logic

**User Model** (`user.dart`):
```dart
bool get isAdminUser => isAdmin || 
                        email.endsWith('.gov.tr') || 
                        email.endsWith('.gov');
```

### API Methods Added

**EventProvider**:
- `createEvent(Event event)` - Create new event
- `updateEvent(Event event)` - Update existing event
- `deleteEvent(int eventId)` - Delete event

**ApiService**:
- `createEvent(Event event)` - POST request
- `updateEvent(Event event)` - PUT request
- `deleteEvent(int eventId)` - DELETE request

All methods support God Mode with in-memory mock data.

---

## 🔒 Security Considerations

### God Mode (Development)

- Email-based admin check (`.gov` suffix)
- No real authentication
- For testing only

### Production Mode

- Backend validates admin status
- JWT token required
- Database-backed permissions
- Proper role-based access control

---

## 🎨 UI/UX Features

### Admin Panel Design

- **Distinct Interface**: Different from regular user view
- **Admin Badge**: Orange "YÖNETİCİ" badge clearly visible
- **Color Coding**: 
  - Blue ✏️ for edit actions
  - Red 🗑️ for delete actions
  - Green for status indicators
- **Confirmation Dialogs**: Prevent accidental deletions
- **Success Messages**: Snackbar notifications
- **Loading States**: Progress indicators during operations

### Form Validation

- Required fields marked with `*`
- Email format validation
- Date must be in future
- Price validation (numbers only)
- Participant limit validation (numbers only)

---

## 📝 Quick Reference

### Admin Login (God Mode)
```
Email: admin@ankara.gov.tr
Password: anything
```

### Regular User Login (God Mode)
```
Email: test@example.com
Password: anything
```

### Toggle Admin Mode
```dart
// lib/utils/constants.dart
class AppConfig {
  static const bool godMode = true;  // Enable/disable
}
```

### Check If User Is Admin
```dart
final isAdmin = authProvider.user?.isAdminUser ?? false;
```

---

## 🚀 Next Steps

### For Development
1. Test all admin features in God Mode
2. Verify routing logic
3. Test with multiple admin emails
4. Verify regular users don't see admin panel

### For Production
1. Set `godMode = false`
2. Implement backend admin endpoints
3. Add proper authentication
4. Add role-based permissions
5. Add admin user management
6. Add audit logging

---

## ✅ Testing Checklist

- [ ] Admin can login with .gov email
- [ ] Regular users see normal home screen
- [ ] Admin sees admin panel
- [ ] Admin can create events
- [ ] Admin can edit events
- [ ] Admin can delete events
- [ ] Confirmation dialogs work
- [ ] Form validation works
- [ ] Success/error messages display
- [ ] Logout works correctly
- [ ] Routes correct after login
- [ ] Mock data persists during session
- [ ] Changes visible immediately

---

**Admin Panel Ready!** 🎉

Login with any `.gov` email and start managing events!
