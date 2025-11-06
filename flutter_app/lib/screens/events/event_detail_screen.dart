import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:turkiye_senin/models/event.dart';
import 'package:turkiye_senin/providers/auth_provider.dart';
import 'package:turkiye_senin/providers/event_provider.dart';

class EventDetailScreen extends StatelessWidget {
  final Event event;

  const EventDetailScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final eventProvider = Provider.of<EventProvider>(context);
    final isRegistered = eventProvider.isUserRegistered(event.id);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Etkinlik Detayı'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor.withOpacity(0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.event,
                  size: 80,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    event.eventName,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Chip(
                    label: Text(event.eventCategory),
                    backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                  ),
                  const SizedBox(height: 24),
                  _DetailRow(
                    icon: Icons.calendar_today,
                    title: 'Tarih',
                    value: DateFormat('dd MMMM yyyy, HH:mm', 'tr_TR').format(event.eventDate),
                  ),
                  const SizedBox(height: 12),
                  _DetailRow(
                    icon: Icons.location_on,
                    title: 'Konum',
                    value: event.eventLocation,
                  ),
                  const SizedBox(height: 12),
                  _DetailRow(
                    icon: Icons.attach_money,
                    title: 'Fiyat',
                    value: event.isFree ? 'Ücretsiz' : '${event.eventPrice.toStringAsFixed(2)} TL',
                  ),
                  if (event.participantLimit != null) ...[
                    const SizedBox(height: 12),
                    _DetailRow(
                      icon: Icons.people,
                      title: 'Katılımcı Limiti',
                      value: 'Kontenjan: ${event.participantLimit} kişi',
                    ),
                  ],
                  const SizedBox(height: 32),
                  if (authProvider.isAuthenticated)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          try {
                            if (isRegistered) {
                              await eventProvider.unregisterFromEvent(event.id);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Kayıt iptal edildi')),
                                );
                              }
                            } else {
                              await eventProvider.registerForEvent(event.id);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Etkinliğe kayıt oldunuz')),
                                );
                              }
                            }
                          } catch (e) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
                              );
                            }
                          }
                        },
                        icon: Icon(isRegistered ? Icons.cancel : Icons.check_circle),
                        label: Text(
                          isRegistered ? 'Kaydı İptal Et' : 'Etkinliğe Katıl',
                          style: const TextStyle(fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(16),
                          backgroundColor: isRegistered ? Colors.red : Theme.of(context).primaryColor,
                        ),
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.orange),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.orange),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Etkinliğe katılmak için giriş yapmalısınız',
                              style: TextStyle(color: Colors.orange),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 24, color: Theme.of(context).primaryColor),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
