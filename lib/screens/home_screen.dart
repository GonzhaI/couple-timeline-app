import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:couple_timeline/l10n/app_localizations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the current user
    final user = FirebaseAuth.instance.currentUser;
    final String displayName = user?.displayName ?? '';
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.homeTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.timeline_rounded, size: 100, color: Colors.deepPurple),
            const SizedBox(height: 20),

            Text('${l10n.welcomeMessage}, ${displayName}', style: Theme.of(context).textTheme.titleLarge),

            const SizedBox(height: 10),
            Text(l10n.defaultHomeMessage, style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),

      // Floating action button to add new timeline events (to be implemented)
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement adding new timeline event
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
