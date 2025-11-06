import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:turkiye_senin/models/scholarship.dart';

class ScholarshipCard extends StatelessWidget {
  final Scholarship scholarship;
  final VoidCallback onTap;

  const ScholarshipCard({
    super.key,
    required this.scholarship,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.school, color: Colors.blue),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      scholarship.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                scholarship.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey[700]),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: scholarship.isExpired
                      ? Colors.red.shade50
                      : Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: scholarship.isExpired ? Colors.red : Colors.green,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: scholarship.isExpired ? Colors.red : Colors.green,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Son Tarih: ${DateFormat('dd MMM yyyy', 'tr_TR').format(scholarship.deadline)}',
                      style: TextStyle(
                        color: scholarship.isExpired ? Colors.red : Colors.green,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
