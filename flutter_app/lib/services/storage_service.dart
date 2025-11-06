import 'package:shared_preferences/shared_preferences.dart';
import 'package:turkiye_senin/utils/constants.dart';
import 'package:turkiye_senin/models/user.dart';
import 'package:turkiye_senin/utils/mock_data.dart';

class StorageService {
  static Future<void> saveToken(String token) async {
    // 🔥 GOD MODE: Tokens always work
    if (AppConfig.godMode) return;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(StorageKeys.token, token);
  }

  static Future<String?> getToken() async {
    // 🔥 GOD MODE: Always have a valid token
    if (AppConfig.godMode) {
      return 'mock_token_123456';
    }
    
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(StorageKeys.token);
  }

  static Future<void> saveUser(User user) async {
    // 🔥 GOD MODE: No need to persist
    if (AppConfig.godMode) return;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(StorageKeys.userId, user.id);
    await prefs.setString(StorageKeys.userEmail, user.email);
    await prefs.setString(StorageKeys.userFirstName, user.firstName);
    await prefs.setString(StorageKeys.userLastName, user.lastName);
  }

  static Future<User?> getUser() async {
    // 🔥 GOD MODE: Return user based on login email
    if (AppConfig.godMode) {
      final prefs = await SharedPreferences.getInstance();
      final loginEmail = prefs.getString(StorageKeys.loginEmail);
      if (loginEmail != null) {
        return MockData.getUserByEmail(loginEmail);
      }
      return MockData.mockUser;
    }
    
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getInt(StorageKeys.userId);
    final email = prefs.getString(StorageKeys.userEmail);
    final firstName = prefs.getString(StorageKeys.userFirstName);
    final lastName = prefs.getString(StorageKeys.userLastName);

    if (id == null || email == null || firstName == null || lastName == null) {
      return null;
    }

    return User(
      id: id,
      email: email,
      firstName: firstName,
      lastName: lastName,
      isActive: true,
      isAdmin: false,
    );
  }
  
  static Future<void> saveLoginEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(StorageKeys.loginEmail, email);
  }

  static Future<void> clearAll() async {
    // 🔥 GOD MODE: Nothing to clear
    if (AppConfig.godMode) return;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
