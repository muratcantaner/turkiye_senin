import 'package:flutter/foundation.dart';
import 'package:turkiye_senin/models/scholarship.dart';
import 'package:turkiye_senin/services/api_service.dart';

class ScholarshipProvider with ChangeNotifier {
  List<Scholarship> _scholarships = [];
  bool _isLoading = false;
  String? _error;

  List<Scholarship> get scholarships => _scholarships;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchScholarships() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _scholarships = await ApiService.getScholarships();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
