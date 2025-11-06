import 'package:flutter/foundation.dart';
import 'package:turkiye_senin/models/event.dart';
import 'package:turkiye_senin/services/api_service.dart';

class EventProvider with ChangeNotifier {
  List<Event> _events = [];
  List<Event> _userEvents = [];
  bool _isLoading = false;
  String? _error;

  List<Event> get events => _events;
  List<Event> get userEvents => _userEvents;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchEvents() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _events = await ApiService.getEvents();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchUserEvents() async {
    try {
      _userEvents = await ApiService.getUserEvents();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<bool> registerForEvent(int eventId) async {
    try {
      await ApiService.registerForEvent(eventId);
      await fetchUserEvents();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  Future<bool> unregisterFromEvent(int eventId) async {
    try {
      await ApiService.unregisterFromEvent(eventId);
      await fetchUserEvents();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  bool isUserRegistered(int eventId) {
    return _userEvents.any((event) => event.id == eventId);
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Admin methods
  Future<void> createEvent(Event event) async {
    _isLoading = true;
    notifyListeners();

    try {
      await ApiService.createEvent(event);
      await fetchEvents(); // Reload events
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateEvent(Event event) async {
    _isLoading = true;
    notifyListeners();

    try {
      await ApiService.updateEvent(event);
      await fetchEvents(); // Reload events
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> deleteEvent(int eventId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await ApiService.deleteEvent(eventId);
      _events.removeWhere((event) => event.id == eventId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
}
