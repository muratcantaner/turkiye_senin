import 'package:flutter/material.dart';

class AppConfig {
  // 🔥 GOD MODE: Set to true to bypass all backend checks and use mock data
  // Perfect for frontend development and testing without a backend!
  static const bool godMode = true;
}

class ApiConstants {
  // Update this URL based on your setup:
  // - For Android emulator: 'http://10.0.2.2:8000'
  // - For iOS simulator: 'http://localhost:8000'
  // - For physical device: 'http://YOUR_LOCAL_IP:8000'
  static const String baseUrl = 'http://10.0.2.2:8000';
  
  // Auth endpoints
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  
  // User endpoints
  static const String userMe = '/users/me';
  static const String userEvents = '/users/me/events';
  
  // Event endpoints
  static const String events = '/events/';
  static String eventDetail(int id) => '/events/$id';
  static String eventRegister(int id) => '/events/$id/register';
  
  // Scholarship endpoints
  static const String scholarships = '/scholarships/';
  
  // Council endpoints
  static const String councils = '/councils/';
  static String councilEvents(int id) => '/councils/$id/events';
}

class StorageKeys {
  static const String token = 'auth_token';
  static const String userId = 'user_id';
  static const String userEmail = 'user_email';
  static const String userFirstName = 'user_first_name';
  static const String userLastName = 'user_last_name';
  static const String loginEmail = 'login_email'; // Store login email for God Mode
}

class AppColors {
  static const Color primary = Color(0xFF1976D2);
  static const Color secondary = Color(0xFF424242);
  static const Color accent = Color(0xFFFF6F00);
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFD32F2F);
  static const Color warning = Color(0xFFFFA726);
  static const Color info = Color(0xFF29B6F6);
  
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Colors.white;
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
}

class AppStrings {
  // App
  static const String appName = 'Türkiye Senin';
  
  // Auth
  static const String login = 'Giriş Yap';
  static const String register = 'Kayıt Ol';
  static const String logout = 'Çıkış Yap';
  static const String email = 'E-posta';
  static const String password = 'Şifre';
  static const String firstName = 'Ad';
  static const String lastName = 'Soyad';
  static const String confirmPassword = 'Şifre Tekrar';
  
  // Navigation
  static const String events = 'Etkinlikler';
  static const String myEvents = 'Etkinliklerim';
  static const String scholarships = 'Burslar';
  static const String councils = 'Meclisler';
  static const String profile = 'Profil';
  
  // Messages
  static const String loading = 'Yükleniyor...';
  static const String error = 'Hata';
  static const String success = 'Başarılı';
  static const String noData = 'Veri bulunamadı';
}
