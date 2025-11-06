import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turkiye_senin/providers/scholarship_provider.dart';
import 'package:turkiye_senin/screens/scholarships/scholarship_detail_screen.dart';
import 'package:turkiye_senin/widgets/scholarship_card.dart';

class ScholarshipsListScreen extends StatelessWidget {
  const ScholarshipsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Burslar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              Provider.of<ScholarshipProvider>(context, listen: false).fetchScholarships();
            },
          ),
        ],
      ),
      body: Consumer<ScholarshipProvider>(
        builder: (context, scholarshipProvider, child) {
          if (scholarshipProvider.isLoading && scholarshipProvider.scholarships.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (scholarshipProvider.error != null && scholarshipProvider.scholarships.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Burslar yüklenemedi',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => scholarshipProvider.fetchScholarships(),
                    child: const Text('Tekrar Dene'),
                  ),
                ],
              ),
            );
          }

          if (scholarshipProvider.scholarships.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.school_outlined, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Henüz burs ilanı yok',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => scholarshipProvider.fetchScholarships(),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: scholarshipProvider.scholarships.length,
              itemBuilder: (context, index) {
                final scholarship = scholarshipProvider.scholarships[index];
                return ScholarshipCard(
                  scholarship: scholarship,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ScholarshipDetailScreen(scholarship: scholarship),
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
