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
        final now = DateTime.now();
        final days = DateTime.now().difference(startDate).inDays;

        return InkWell(
          onTap: () => _pickDate(context, startDate),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  days.toString(),
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.daysTogether,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(
                          context,
                        ).textTheme.bodyMedium?.color?.withOpacity(0.7),
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.edit_calendar,
                      size: 14,
                      color: Theme.of(context).disabledColor,
                    ),
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
