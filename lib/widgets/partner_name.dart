import 'package:couple_timeline/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:couple_timeline/l10n/app_localizations.dart';

class PartnerName extends StatelessWidget {
  final String coupleId;

  const PartnerName({super.key, required this.coupleId});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return FutureBuilder<String?>(
      future: DatabaseService().getPartnerName(coupleId),
      builder: (context, snapshot) {
        String text = "❤️";

        if (snapshot.hasData && snapshot.data != null) {
          text = "${l10n.connectedWith}: ${snapshot.data}";
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          text = "...";
        }

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            text,
            style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w500),
          ),
        );
      },
    );
  }
}
