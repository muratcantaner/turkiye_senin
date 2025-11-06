import 'package:flutter/foundation.dart';
import 'package:turkiye_senin/models/council.dart';
import 'package:turkiye_senin/models/event.dart';
import 'package:turkiye_senin/services/api_service.dart';

class CouncilProvider with ChangeNotifier {
  List<Council> _councils = [];
  final Map<int, List<Event>> _councilEvents = {};
  bool _isLoading = false;
  String? _error;

  List<Council> get councils => _councils;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchCouncils() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _councils = await ApiService.getCouncils();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<Event>> fetchCouncilEvents(int councilId) async {
    try {
      final events = await ApiService.getCouncilEvents(councilId);
      _councilEvents[councilId] = events;
      notifyListeners();
      return events;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return [];
    }
  }

  List<Event> getCouncilEvents(int councilId) {
    return _councilEvents[councilId] ?? [];
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
