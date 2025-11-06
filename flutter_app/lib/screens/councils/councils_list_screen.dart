import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turkiye_senin/providers/council_provider.dart';
import 'package:turkiye_senin/screens/councils/council_detail_screen.dart';
import 'package:turkiye_senin/widgets/council_card.dart';

class CouncilsListScreen extends StatelessWidget {
  const CouncilsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Konsey'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Provider.of<CouncilProvider>(context, listen: false).fetchCouncils();
            },
          ),
        ],
      ),
      body: Consumer<CouncilProvider>(
        builder: (context, councilProvider, child) {
          if (councilProvider.isLoading && councilProvider.councils.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (councilProvider.error != null && councilProvider.councils.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Konseyler yüklenemedi',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => councilProvider.fetchCouncils(),
                    child: const Text('Tekrar Dene'),
                  ),
                ],
              ),
            );
          }

          if (councilProvider.councils.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_city_outlined, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Henüz konsey bilgisi yok',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => councilProvider.fetchCouncils(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: councilProvider.councils.length,
              itemBuilder: (context, index) {
                final council = councilProvider.councils[index];
                return CouncilCard(
                  council: council,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CouncilDetailScreen(council: council),
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
