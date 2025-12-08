import 'package:couple_timeline/screens/add_memory_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_timeline/services/database_service.dart';
import 'package:couple_timeline/l10n/app_localizations.dart';
import 'package:couple_timeline/utils/memory_categories.dart';

class MemoryCard extends StatelessWidget {
  final String memoryId;
  final Map<String, dynamic> data;
  const MemoryCard({super.key, required this.memoryId, required this.data});

  // Function to show delete confirmation dialog
  void _deleteMemory(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteDialogTitle),
        content: Text(l10n.deleteDialogContent),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: Text(l10n.cancelButton)),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              try {
                await DatabaseService().deleteMemory(memoryId);

                if (ctx.mounted) {
                  ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(content: Text(l10n.memoryDeletedMsg)));
                }
              } catch (e) {
                if (ctx.mounted) {
                  ScaffoldMessenger.of(
                    ctx,
                  ).showSnackBar(SnackBar(content: Text("${l10n.errorPrefix}$e"), backgroundColor: Colors.red));
                }
              }
            },
            child: Text(l10n.deleteButton, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final String title = data['title'] ?? l10n.noTitle;
    final String description = data['description'] ?? l10n.noDescription;
    final String location = data['location'] ?? l10n.noLocation;

    final String categoryId = data['category'] ?? 'daily';
    final MemoryCategory category = getCategoryById(categoryId);

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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: category.color.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(category.icon, color: category.color, size: 24),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),

                  // Date and Location
                  Row(
                    children: [
                      Text(dateString, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                      if (location.isNotEmpty && location != l10n.noLocation) ...[
                        const SizedBox(width: 8),
                        const Text("•", style: TextStyle(color: Colors.grey)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            location,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.grey[600], fontSize: 12, fontStyle: FontStyle.italic),
                          ),
                        ),
                      ],
                    ],
                  ),

                  // Description
                  if (description.isNotEmpty && description != l10n.noDescription) ...[
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: const TextStyle(fontSize: 14, height: 1.4),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),

            // Options Menu
            PopupMenuButton<String>(
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.more_vert, color: Colors.grey),
              onSelected: (value) {
                if (value == 'edit') {
                  final String coupleId = data['coupleId'];
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddMemoryScreen(coupleId: coupleId, memoryId: memoryId, initialData: data),
                    ),
                  );
                } else if (value == 'delete') {
                  _deleteMemory(context);
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(value: 'edit', child: Text(l10n.editAction)),
                PopupMenuItem(
                  value: 'delete',
                  child: Text(l10n.deleteAction, style: const TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
