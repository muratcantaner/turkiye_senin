import 'package:turkiye_senin/models/user.dart';
import 'package:turkiye_senin/models/event.dart';
import 'package:turkiye_senin/models/scholarship.dart';
import 'package:turkiye_senin/models/council.dart';

/// Mock data for God Mode - allows frontend testing without backend
class MockData {
  // Regular user
  static final User mockUser = User(
    id: 1,
    email: 'test@example.com',
    firstName: 'Test',
    lastName: 'Kullanıcı',
    isActive: true,
    isAdmin: false,
  );
  
  // Admin user (any .gov email becomes admin in God Mode)
  static final User mockAdminUser = User(
    id: 999,
    email: 'admin@ankara.gov.tr',
    firstName: 'Admin',
    lastName: 'Yönetici',
    isActive: true,
    isAdmin: true,
  );
  
  // Returns appropriate user based on login email
  static User getUserByEmail(String email) {
    if (email.endsWith('.gov') || email.endsWith('.gov.tr')) {
      return mockAdminUser;
    }
    return mockUser;
  }

  static final List<Event> mockEvents = [
    Event(
      id: 1,
      eventName: 'Yazılım Geliştirme Atölyesi',
      eventCategory: 'Eğitim',
      eventDate: DateTime.now().add(const Duration(days: 5)),
      eventLocation: 'Ankara Kongre Merkezi',
      eventPrice: 0,
      participantLimit: 50,
      councilId: 1,
    ),
    Event(
      id: 2,
      eventName: 'Gençlik Konferansı 2024',
      eventCategory: 'Konferans',
      eventDate: DateTime.now().add(const Duration(days: 10)),
      eventLocation: 'İstanbul Üniversitesi',
      eventPrice: 100,
      participantLimit: 200,
      councilId: 2,
    ),
    Event(
      id: 3,
      eventName: 'Spor Festivali',
      eventCategory: 'Spor',
      eventDate: DateTime.now().add(const Duration(days: 15)),
      eventLocation: 'İzmir Stadyumu',
      eventPrice: 0,
      participantLimit: 500,
      councilId: 3,
    ),
    Event(
      id: 4,
      eventName: 'Kariyer Günleri',
      eventCategory: 'Kariyer',
      eventDate: DateTime.now().add(const Duration(days: 20)),
      eventLocation: 'Bursa Fuar Merkezi',
      eventPrice: 50,
      participantLimit: 150,
      councilId: 1,
    ),
    Event(
      id: 5,
      eventName: 'Kültür ve Sanat Festivali',
      eventCategory: 'Kültür',
      eventDate: DateTime.now().add(const Duration(days: 25)),
      eventLocation: 'Antalya Açık Hava Tiyatrosu',
      eventPrice: 0,
      participantLimit: null,
      councilId: 2,
    ),
  ];

  static final List<Event> mockUserEvents = [
    MockData.mockEvents[0], // Yazılım Geliştirme Atölyesi
    MockData.mockEvents[2], // Spor Festivali
  ];

  static final List<Scholarship> mockScholarships = [
    Scholarship(
      id: 1,
      title: 'Başarı Bursu 2024',
      description: 'Başarılı öğrencilere yönelik tam burs imkanı. Lisans ve yüksek lisans programlarında geçerlidir.',
      deadline: DateTime.now().add(const Duration(days: 30)),
      applicationUrl: 'https://example.com/scholarship1',
    ),
    Scholarship(
      id: 2,
      title: 'Sosyal Sorumluluk Bursu',
      description: 'Gönüllü çalışmalarda aktif olan öğrenciler için kısmi burs desteği.',
      deadline: DateTime.now().add(const Duration(days: 45)),
      applicationUrl: 'https://example.com/scholarship2',
    ),
    Scholarship(
      id: 3,
      title: 'Yurtdışı Eğitim Bursu',
      description: 'Yurtdışında eğitim almak isteyen öğrenciler için tam kapsamlı burs programı.',
      deadline: DateTime.now().add(const Duration(days: 60)),
      applicationUrl: 'https://example.com/scholarship3',
    ),
    Scholarship(
      id: 4,
      title: 'Spor Bursu',
      description: 'Milli sporcu olan veya önemli başarılar elde etmiş sporculara özel burs.',
      deadline: DateTime.now().subtract(const Duration(days: 5)), // Expired
      applicationUrl: 'https://example.com/scholarship4',
    ),
  ];

  static final List<Council> mockCouncils = [
    Council(
      id: 1,
      councilName: 'Ankara Gençlik Meclisi',
      city: 'Ankara',
    ),
    Council(
      id: 2,
      councilName: 'İstanbul Gençlik Meclisi',
      city: 'İstanbul',
    ),
    Council(
      id: 3,
      councilName: 'İzmir Gençlik Meclisi',
      city: 'İzmir',
    ),
    Council(
      id: 4,
      councilName: 'Bursa Gençlik Meclisi',
      city: 'Bursa',
    ),
    Council(
      id: 5,
      councilName: 'Antalya Gençlik Meclisi',
      city: 'Antalya',
    ),
  ];

  static List<Event> getCouncilEvents(int councilId) {
    return mockEvents.where((event) => event.councilId == councilId).toList();
  }

  static Future<void> delay() async {
    // Simulate network delay for realism
    await Future.delayed(const Duration(milliseconds: 300));
  }
}
