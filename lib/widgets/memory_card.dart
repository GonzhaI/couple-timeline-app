import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MemoryCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const MemoryCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final String title = data['title'] ?? 'No Title';
    final String description = data['description'] ?? 'No Description';
    final String location = data['location'] ?? 'No Location';

    final Timestamp timestamp = data['date'];
    final DateTime date = timestamp.toDate();
    final String dateString = "${date.day}/${date.month}/${date.year}";

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(dateString, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                const Spacer(),
                if (location.isNotEmpty) ...[
                  Icon(Icons.location_on, size: 14, color: Colors.deepPurple[400]),
                  const SizedBox(width: 4),
                  Text(
                    location,
                    style: TextStyle(color: Colors.deepPurple[400], fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),

            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            if (description.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(description, style: const TextStyle(fontSize: 14, height: 1.4)),
            ],
          ],
        ),
      ),
    );
  }
}
