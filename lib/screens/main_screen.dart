import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_timeline/screens/add_memory_screen.dart';
import 'package:couple_timeline/screens/home_screen.dart';
import 'package:couple_timeline/screens/pairing_screen.dart';
import 'package:couple_timeline/screens/profile_screen.dart';
import 'package:couple_timeline/screens/stats_screen.dart';
import 'package:couple_timeline/services/database_service.dart';
import 'package:couple_timeline/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return StreamBuilder(
      stream: DatabaseService().getUserStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Scaffold(body: Center(child: Text(l10n.errorLoadingUser)));
        }

        final userData = snapshot.data!.data() as Map<String, dynamic>;
        final String? coupleId = userData['coupleId'];

        // If not paired
        if (coupleId == null) {
          return PairingScreen(myInviteCode: userData['inviteCode'] ?? '---');
        }

        // If paired
        return MainContent(coupleId: coupleId);
      },
    );
  }
}

class MainContent extends StatefulWidget {
  final String coupleId;
  const MainContent({super.key, required this.coupleId});

  @override
  State<MainContent> createState() => _MainContentState();
}

class _MainContentState extends State<MainContent> {
  int _selectedIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        physics: const BouncingScrollPhysics(),
        children: [
          // Screen 0: Home
          HomeScreen(isEmbedded: true),
          // Screen 1: Statistics
          StatsScreen(coupleId: widget.coupleId),
          // Screen 2: Profile
          const ProfileScreen(),
        ],
      ),

      // FAB only in Home
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        AddMemoryScreen(coupleId: widget.coupleId),
                  ),
                );
              },
              child: const Icon(Icons.add),
            )
          : null,

      // Bottom Bar
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: l10n.navHome ?? 'Error',
          ),
          NavigationDestination(
            icon: const Icon(Icons.bar_chart_rounded),
            label: l10n.navStats ?? "Error",
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outlined),
            selectedIcon: const Icon(Icons.person),
            label: l10n.navProfile ?? "Error",
          ),
        ],
      ),
    );
  }
}
