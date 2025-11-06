import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turkiye_senin/models/council.dart';
import 'package:turkiye_senin/providers/council_provider.dart';
import 'package:turkiye_senin/screens/events/event_detail_screen.dart';
import 'package:turkiye_senin/widgets/event_card.dart';

class CouncilDetailScreen extends StatefulWidget {
  final Council council;

  const CouncilDetailScreen({super.key, required this.council});

  @override
  State<CouncilDetailScreen> createState() => _CouncilDetailScreenState();
}

class _CouncilDetailScreenState extends State<CouncilDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CouncilProvider>(context, listen: false)
          .fetchCouncilEvents(widget.council.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.council.councilName),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
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
            child: Column(
              children: [
                const Icon(Icons.location_city, size: 60, color: Colors.white),
                const SizedBox(height: 12),
                Text(
                  widget.council.councilName,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  widget.council.city,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  'Düzenlenen Etkinlikler',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<CouncilProvider>(
              builder: (context, councilProvider, child) {
                final events = councilProvider.getCouncilEvents(widget.council.id);
                if (councilProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (events.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.event_busy, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        Text(
                          'Bu konsey henüz etkinlik düzenlememiş',
                          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return EventCard(
                      event: event,
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
