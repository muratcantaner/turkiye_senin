import 'package:flutter/foundation.dart';
import 'package:turkiye_senin/models/user.dart';
import 'package:turkiye_senin/services/api_service.dart';
import 'package:turkiye_senin/services/storage_service.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _loadUser();
  }

  Future<void> _loadUser() async {
    _user = await StorageService.getUser();
    notifyListeners();
  }

  Future<bool> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final token = await ApiService.register(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
      );
      
      await StorageService.saveToken(token);
      await _fetchUser();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final token = await ApiService.login(email: email, password: password);
      await StorageService.saveToken(token);
      await _fetchUser();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> _fetchUser() async {
    try {
      _user = await ApiService.getCurrentUser();
      await StorageService.saveUser(_user!);
    } catch (e) {
      _error = e.toString();
    }
  }

  Future<void> logout() async {
    await StorageService.clearAll();
    _user = null;
    _error = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
