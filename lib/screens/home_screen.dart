import 'package:couple_timeline/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:couple_timeline/l10n/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_timeline/screens/pairing_screen.dart';
import 'package:couple_timeline/screens/add_memory_screen.dart';
import 'package:couple_timeline/widgets/memory_card.dart';

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
            // Coupled: show memories list
            return Scaffold(
              body: StreamBuilder<QuerySnapshot>(
                stream: DatabaseService().getMemoriesStream(coupleId),
                builder: (context, memorySnapshot) {
                  if (memorySnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (memorySnapshot.hasError) {
                    return Center(child: Text("Error: ${memorySnapshot.error}"));
                  }
                  if (!memorySnapshot.hasData || memorySnapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.history_edu, size: 80, color: Colors.grey),
                          const SizedBox(height: 20),
                          Text(
                            "No memories yet.",
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey),
                          ),
                          const Text("Add your first memory using the + button below!"),
                        ],
                      ),
                    );
                  }

                  final memories = memorySnapshot.data!.docs;

                  return ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: memories.length,
                    itemBuilder: (context, index) {
                      final memoryData = memories[index].data() as Map<String, dynamic>;
                      return MemoryCard(data: memoryData);
                    },
                  );
                },
              ),

              // FLOATING ACTION BUTTON
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => AddMemoryScreen(coupleId: coupleId)));
                },
                child: const Icon(Icons.add),
              ),
            );
          }
        },
      ),
    );
  }
}
