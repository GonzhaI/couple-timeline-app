import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_timeline/utils/date_formatter.dart';
import 'package:flutter/material.dart';
import 'package:couple_timeline/l10n/app_localizations.dart';
import 'package:couple_timeline/services/database_service.dart';
import 'package:couple_timeline/utils/memory_categories.dart';

class StatsScreen extends StatelessWidget {
  final String coupleId;

  const StatsScreen({super.key, required this.coupleId});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.statsTitle), centerTitle: true),
      body: StreamBuilder<QuerySnapshot>(
        stream: DatabaseService().getMemoriesStream(coupleId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                l10n.noMemoriesYet,
                style: TextStyle(color: Theme.of(context).disabledColor),
              ),
            );
          }

          final docs = snapshot.data!.docs;

          // Total memories
          final totalCount = docs.length;

          // Count by categories
          final Map<String, int> categoryCounts = {};
          for (var doc in docs) {
            final data = doc.data() as Map<String, dynamic>;
            final category = data['category'] as String? ?? 'daily';
            categoryCounts[category] = (categoryCounts[category] ?? 0) + 1;
          }

          // Get the popular category
          String? topCategory;
          int maxCount = 0;
          categoryCounts.forEach((key, value) {
            if (value > maxCount) {
              maxCount = value;
              topCategory = key;
            }
          });

          // First memorie
          final oldestDoc = docs.last.data() as Map<String, dynamic>;
          final oldestDateTimestamp = oldestDoc['date'] as Timestamp;
          final oldestDate = oldestDateTimestamp.toDate();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        label: l10n.totalMemories,
                        value: totalCount.toString(),
                        icon: Icons.filter_frames,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        label: l10n.mostActiveCategory,
                        value: _getCategoryName(context, topCategory),
                        icon: Icons.star,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // First memory
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Theme.of(context).dividerColor.withOpacity(0.1),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        l10n.firstMemoryDate,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        formatFullDate(context, oldestDate),
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                ...appCategories.map((cat) {
                  final count = categoryCounts[cat.id] ?? 0;
                  if (count == 0) return const SizedBox.shrink();

                  // Percent for progress bar
                  final double percentage = count / totalCount;

                  // Get translated name
                  String label = cat.id;
                  if (cat.id == 'date') label = l10n.dateCategory;
                  if (cat.id == 'travel') label = l10n.travelCategory;
                  if (cat.id == 'milestone') label = l10n.milestoneCategory;
                  if (cat.id == 'daily') label = l10n.dailyCategory;
                  if (cat.id == 'party') label = l10n.partyCategory;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(cat.icon, size: 20, color: cat.color),
                            const SizedBox(width: 8),
                            Text(
                              label,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              "$count (${(percentage * 100).toStringAsFixed(0)}%)",
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: percentage,
                            backgroundColor: cat.color.withOpacity(0.2),
                            color: cat.color,
                            minHeight: 8,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }

  // Helper for categories names
  String _getCategoryName(BuildContext context, String? catId) {
    if (catId == null) return "-";
    final l10n = AppLocalizations.of(context)!;
    if (catId == 'date') return l10n.dateCategory;
    if (catId == 'travel') return l10n.travelCategory;
    if (catId == 'milestone') return l10n.milestoneCategory;
    if (catId == 'daily') return l10n.dailyCategory;
    if (catId == 'party') return l10n.partyCategory;
    return catId;
  }
}

// Widget for cards
class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
