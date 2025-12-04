import 'package:couple_timeline/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:couple_timeline/l10n/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_timeline/screens/pairing_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
      body: StreamBuilder<DocumentSnapshot>(
        stream: DatabaseService().getUserStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text(l10n.homeErrorLoadingData));
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final String? coupleId = userData['coupleId'];
          final String inviteCode = userData['inviteCode'] ?? '---';

          // If not paired, show pairing screen
          if (coupleId == null) {
            return PairingScreen(myInviteCode: inviteCode);
          } else {
            // If paired, show couple timeline placeholder
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.favorite, size: 100, color: Colors.pink),
                  const SizedBox(height: 20),
                  Text(l10n.homePairedMessage, style: Theme.of(context).textTheme.headlineMedium),
                  Text(l10n.idLabel, style: TextStyle(color: Colors.grey)),
                  Text(coupleId, style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            );
          }
        },
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
