import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:turkiye_senin/utils/constants.dart';
import 'package:turkiye_senin/models/user.dart';
import 'package:turkiye_senin/models/event.dart';
import 'package:turkiye_senin/models/scholarship.dart';
import 'package:turkiye_senin/models/council.dart';
import 'package:turkiye_senin/services/storage_service.dart';
import 'package:turkiye_senin/utils/mock_data.dart';

class ApiService {
  static Future<Map<String, String>> _getHeaders() async {
    final token = await StorageService.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Auth
  static Future<String> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    // 🔥 GOD MODE: Return mock token instantly
    if (AppConfig.godMode) {
      await MockData.delay();
      return 'mock_token_123456';
    }
    
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.register}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'first_name': firstName,
        'last_name': lastName,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['access_token'];
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['detail'] ?? 'Registration failed');
    }
  }

  static Future<String> login({
    required String email,
    required String password,
  }) async {
    // 🔥 GOD MODE: Return mock token instantly and save login email
    if (AppConfig.godMode) {
      await MockData.delay();
      await StorageService.saveLoginEmail(email); // Save for admin check
      return 'mock_token_123456';
    }
    
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.login}'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: {
        'username': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['access_token'];
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['detail'] ?? 'Login failed');
    }
  }

  // Users
  static Future<User> getCurrentUser() async {
    // 🔥 GOD MODE: Return user based on stored login email
    if (AppConfig.godMode) {
      await MockData.delay();
      final user = await StorageService.getUser();
      return user ?? MockData.mockUser;
    }
    
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.userMe}'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get user');
    }
  }

  static Future<List<Event>> getUserEvents() async {
    // 🔥 GOD MODE: Return mock user events instantly
    if (AppConfig.godMode) {
      await MockData.delay();
      return MockData.mockUserEvents;
    }
    
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.userEvents}'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Event.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get user events');
    }
  }

  // Events
  static Future<List<Event>> getEvents() async {
    // 🔥 GOD MODE: Return mock events instantly
    if (AppConfig.godMode) {
      await MockData.delay();
      return MockData.mockEvents;
    }
    
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.events}'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Event.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get events');
    }
  }

  static Future<Event> getEventById(int id) async {
    // 🔥 GOD MODE: Return mock event instantly
    if (AppConfig.godMode) {
      await MockData.delay();
      return MockData.mockEvents.firstWhere(
        (e) => e.id == id,
        orElse: () => MockData.mockEvents.first,
      );
    }
    
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.eventDetail(id)}'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      return Event.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get event');
    }
  }

  static Future<void> registerForEvent(int eventId) async {
    // 🔥 GOD MODE: Instant success
    if (AppConfig.godMode) {
      await MockData.delay();
      return;
    }
    
    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.eventRegister(eventId)}'),
      headers: headers,
    );

    if (response.statusCode != 200) {
      final error = jsonDecode(response.body);
      throw Exception(error['detail'] ?? 'Failed to register for event');
    }
  }

  static Future<void> unregisterFromEvent(int eventId) async {
    // 🔥 GOD MODE: Instant success
    if (AppConfig.godMode) {
      await MockData.delay();
      return;
    }
    
    final headers = await _getHeaders();
    final response = await http.delete(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.eventRegister(eventId)}'),
      headers: headers,
    );

    if (response.statusCode != 200) {
      final error = jsonDecode(response.body);
      throw Exception(error['detail'] ?? 'Failed to unregister from event');
    }
  }

  // Scholarships
  static Future<List<Scholarship>> getScholarships() async {
    // 🔥 GOD MODE: Return mock scholarships instantly
    if (AppConfig.godMode) {
      await MockData.delay();
      return MockData.mockScholarships;
    }
    
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.scholarships}'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Scholarship.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get scholarships');
    }
  }

  // Councils
  static Future<List<Council>> getCouncils() async {
    // 🔥 GOD MODE: Return mock councils instantly
    if (AppConfig.godMode) {
      await MockData.delay();
      return MockData.mockCouncils;
    }
    
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.councils}'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Council.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get councils');
    }
  }

  static Future<List<Event>> getCouncilEvents(int councilId) async {
    // 🔥 GOD MODE: Return mock council events instantly
    if (AppConfig.godMode) {
      await MockData.delay();
      return MockData.getCouncilEvents(councilId);
    }
    
    final headers = await _getHeaders();
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.councilEvents(councilId)}'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Event.fromJson(json)).toList();
    } else {
      throw Exception('Failed to get council events');
    }
  }

  // Admin Event Management
  static Future<Event> createEvent(Event event) async {
    // 🔥 GOD MODE: Add event to mock data and return it
    if (AppConfig.godMode) {
      await MockData.delay();
      final newEvent = Event(
        id: MockData.mockEvents.length + 1,
        eventName: event.eventName,
        eventCategory: event.eventCategory,
        eventDate: event.eventDate,
        eventLocation: event.eventLocation,
        eventPrice: event.eventPrice,
        participantLimit: event.participantLimit,
        councilId: event.councilId,
      );
      MockData.mockEvents.add(newEvent);
      return newEvent;
    }

    final headers = await _getHeaders();
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.events}'),
      headers: headers,
      body: jsonEncode(event.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return Event.fromJson(jsonDecode(response.body));
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['detail'] ?? 'Failed to create event');
    }
  }

  static Future<Event> updateEvent(Event event) async {
    // 🔥 GOD MODE: Update event in mock data
    if (AppConfig.godMode) {
      await MockData.delay();
      final index = MockData.mockEvents.indexWhere((e) => e.id == event.id);
      if (index != -1) {
        MockData.mockEvents[index] = event;
      }
      return event;
    }

    final headers = await _getHeaders();
    final response = await http.put(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.eventDetail(event.id)}'),
      headers: headers,
      body: jsonEncode(event.toJson()),
    );

    if (response.statusCode == 200) {
      return Event.fromJson(jsonDecode(response.body));
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['detail'] ?? 'Failed to update event');
    }
  }

  static Future<void> deleteEvent(int eventId) async {
    // 🔥 GOD MODE: Remove event from mock data
    if (AppConfig.godMode) {
      await MockData.delay();
      MockData.mockEvents.removeWhere((e) => e.id == eventId);
      return;
    }

    final headers = await _getHeaders();
    final response = await http.delete(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.eventDetail(eventId)}'),
      headers: headers,
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      final error = jsonDecode(response.body);
      throw Exception(error['detail'] ?? 'Failed to delete event');
    }
  }
}
