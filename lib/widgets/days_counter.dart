import 'package:flutter/material.dart';
import 'package:couple_timeline/l10n/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_timeline/services/database_service.dart';

class DaysCounter extends StatelessWidget {
  final String coupleId;
  const DaysCounter({super.key, required this.coupleId});

  void _pickDate(BuildContext context, DateTime? currentDate) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: currentDate ?? DateTime.now(),
      lastDate: DateTime.now(),
      firstDate: DateTime(1900),
    );
    if (picked != null) {
      await DatabaseService().updateRelationshipStart(coupleId, picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return StreamBuilder(
      stream: DatabaseService().getCoupleStream(coupleId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const SizedBox();

        final data = snapshot.data!.data() as Map<String, dynamic>?;
        final Timestamp? startTimestamp = data?['startedAt'];

        if (startTimestamp == null) {
          return Center(
            child: TextButton.icon(
              onPressed: () => _pickDate(context, null),
              icon: const Icon(Icons.favorite_border),
              label: Text(l10n.setStartDate),
            ),
          );
        }

        final startDate = startTimestamp.toDate();
        final days = DateTime.now().difference(startDate).inDays;

        return InkWell(
          onTap: () => _pickDate(context, startDate),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 30),
            alignment: Alignment.center,
            child: Column(
              children: [
                Text(
                  days.toString(),
                  style: TextStyle(
                    fontSize: 70,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                    height: 1,
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.daysCount,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey[600]),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.edit_calendar, size: 16, color: Colors.grey[400]),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
