import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turkiye_senin/providers/auth_provider.dart';
import 'package:turkiye_senin/providers/event_provider.dart';
import 'package:turkiye_senin/screens/auth/login_screen.dart';
import 'package:turkiye_senin/screens/events/event_detail_screen.dart';
import 'package:turkiye_senin/widgets/event_card.dart';

class MyEventsScreen extends StatelessWidget {
  const MyEventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    if (!authProvider.isAuthenticated) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Etkinliklerim'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.event_busy, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'Etkinliklerinizi görmek için\ngiriş yapmalısınız',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
                child: const Text('Giriş Yap'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Etkinliklerim'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Provider.of<EventProvider>(context, listen: false).fetchUserEvents();
            },
          ),
        ],
      ),
      body: Consumer<EventProvider>(
        builder: (context, eventProvider, child) {
          if (eventProvider.isLoading && eventProvider.userEvents.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (eventProvider.userEvents.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.event_busy, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Henüz kayıtlı etkinlik yok',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Etkinlikler sekmesinden katılmak\nistediğiniz etkinliklere kayıt olabilirsiniz',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => eventProvider.fetchUserEvents(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: eventProvider.userEvents.length,
              itemBuilder: (context, index) {
                final event = eventProvider.userEvents[index];
                return EventCard(
                  event: event,
                  isRegistered: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EventDetailScreen(event: event),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
