import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turkiye_senin/providers/auth_provider.dart';
import 'package:turkiye_senin/providers/event_provider.dart';
import 'package:turkiye_senin/providers/scholarship_provider.dart';
import 'package:turkiye_senin/providers/council_provider.dart';
import 'package:turkiye_senin/screens/events/events_list_screen.dart';
import 'package:turkiye_senin/screens/events/my_events_screen.dart';
import 'package:turkiye_senin/screens/scholarships/scholarships_list_screen.dart';
import 'package:turkiye_senin/screens/councils/councils_list_screen.dart';
import 'package:turkiye_senin/screens/profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const EventsListScreen(),
    const MyEventsScreen(),
    const ScholarshipsListScreen(),
    const CouncilsListScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Load data after the first frame to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  Future<void> _loadInitialData() async {
    if (!mounted) return;
    
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    final scholarshipProvider =
        Provider.of<ScholarshipProvider>(context, listen: false);
    final councilProvider =
        Provider.of<CouncilProvider>(context, listen: false);

    await Future.wait([
      eventProvider.fetchEvents(),
      scholarshipProvider.fetchScholarships(),
      councilProvider.fetchCouncils(),
    ]);

    if (!mounted) return;
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    if (authProvider.isAuthenticated) {
      await eventProvider.fetchUserEvents();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.event),
            label: 'Etkinlikler',
          ),
          NavigationDestination(
            icon: Icon(Icons.event_available),
            label: 'Etkinliklerim',
          ),
          NavigationDestination(
            icon: Icon(Icons.school),
            label: 'Burslar',
          ),
          NavigationDestination(
            icon: Icon(Icons.location_city),
            label: 'Konseyler',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
