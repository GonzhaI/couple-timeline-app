import 'package:couple_timeline/screens/add_memory_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_timeline/services/database_service.dart';

class MemoryCard extends StatelessWidget {
  final String memoryId;
  final Map<String, dynamic> data;
  const MemoryCard({super.key, required this.memoryId, required this.data});

  // Function to show delete confirmation dialog
  void _deleteMemory(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Memorie?"),
        content: const Text("This action can't be undone"),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text("Cancel")),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              try {
                await DatabaseService().deleteMemory(memoryId);

                if (ctx.mounted) {
                  ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text("Memory Deleted")));
                }
              } catch (e) {
                if (ctx.mounted) {
                  ScaffoldMessenger.of(
                    ctx,
                  ).showSnackBar(SnackBar(content: Text("Error $e"), backgroundColor: Colors.red));
                }
              }
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String title = data['title'] ?? 'No Title';
    final String description = data['description'] ?? 'No Description';
    final String location = data['location'] ?? 'No Location';

    DateTime date = DateTime.now();
    if (data['date'] != null) {
      date = (data['date'] as Timestamp).toDate();
    }
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
                const SizedBox(width: 10),

                if (location.isNotEmpty) ...[
                  Icon(Icons.location_on, size: 14, color: Colors.deepPurple[400]),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      location,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.deepPurple[400], fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ] else
                  const Spacer(),

                // Options Menu
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: Colors.grey),
                  onSelected: (value) {
                    if (value == 'edit') {
                      final String coupleId = data['coupleId'];
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AddMemoryScreen(coupleId: coupleId, memoryId: memoryId, initialData: data),
                        ),
                      );
                    } else if (value == 'delete') {
                      _deleteMemory(context);
                    }
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit, color: Colors.blue),
                          SizedBox(width: 8),
                          Text('Edit'),
                        ],
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Delete'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Title
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            // Description
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
