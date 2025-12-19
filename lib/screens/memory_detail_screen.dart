import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_timeline/l10n/app_localizations.dart';
import 'package:couple_timeline/screens/add_memory_screen.dart';
import 'package:couple_timeline/services/database_service.dart';
import 'package:couple_timeline/utils/date_formatter.dart';
import 'package:couple_timeline/utils/memory_categories.dart';
import 'package:flutter/material.dart';

class MemoryDetailScreen extends StatelessWidget {
  final String memoryId;
  final Map<String, dynamic> data;

  const MemoryDetailScreen({
    super.key,
    required this.memoryId,
    required this.data,
  });

  void _deleteMemory(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.deleteDialogTitle),
        content: Text(l10n.deleteDialogContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.cancelButton),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              try {
                await DatabaseService().deleteMemory(memoryId);
                if (context.mounted) {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.memoryDeletedMsg)),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("${l10n.errorPrefix}$e"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: Text(
              l10n.deleteButton,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final String title = data['title'] ?? l10n.noTitle;
    final String description = data['description'] ?? '';
    final String location = data['location'] ?? '';
    final String categoryId = data['categoryId'] ?? '';
    final MemoryCategory category = getCategoryById(categoryId);

    DateTime date = DateTime.now();
    if (data['date'] != null) {
      date = (data['date'] as Timestamp).toDate();
    }
    final String dateString = formatFullDate(context, date);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.memoryDetailsTitle),
        actions: [
          // Edit button
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              final String coupleId = data['coupleId'];
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => AddMemoryScreen(
                    coupleId: coupleId,
                    memoryId: memoryId,
                    initialData: data,
                  ),
                ),
              );
            },
          ),
          // Delete button
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.redAccent),
            onPressed: () => _deleteMemory(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header: Icon and Title
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: category.color.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(category.icon, size: 60, color: category.color),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Date and location
            Card(
              elevation: 0,
              color: Theme.of(
                context,
              ).colorScheme.surfaceVariant.withOpacity(0.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_month,
                          size: 20,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          dateString,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                    // Divider
                    const SizedBox(height: 8),
                    // Location if exists
                    if (location.isNotEmpty)
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 20,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: Text(
                              location,
                              style: Theme.of(context).textTheme.bodyMedium,
                              overflow: TextOverflow.visible,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Description
            Text(
              l10n.detailHistory,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              description.isNotEmpty ? description : l10n.noDescription,
              style: TextStyle(
                fontSize: 16,
                height: 1.6,
                color: description.isEmpty
                    ? Colors.grey
                    : Theme.of(context).textTheme.bodyLarge?.color,
                fontStyle: description.isEmpty
                    ? FontStyle.italic
                    : FontStyle.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
