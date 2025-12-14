import 'package:couple_timeline/services/database_service.dart';
import 'package:couple_timeline/widgets/days_counter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:couple_timeline/l10n/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_timeline/screens/pairing_screen.dart';
import 'package:couple_timeline/screens/add_memory_screen.dart';
import 'package:couple_timeline/widgets/memory_card.dart';
import 'package:couple_timeline/utils/memory_categories.dart';
import 'dart:async';
import 'package:couple_timeline/widgets/partner_name.dart';
import 'package:couple_timeline/screens/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Search functionality
  final TextEditingController _searchController = TextEditingController();
  final Debouncer _debouncer = Debouncer(milliseconds: 500);
  String _searchQuery = '';
  String _selectedCategoryFilter = 'all';

  @override
  void dispose() {
    _searchController.dispose(); // Memory leak prevention
    super.dispose();
  }

  // Clear search input and hide keyboard
  void _cleanSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
    });
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return StreamBuilder<DocumentSnapshot>(
      stream: DatabaseService().getUserStream(),
      builder: (context, snapshot) {
        // Loading (white screen with spinner)
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        // Error or no data
        if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
          return Scaffold(body: Center(child: Text(l10n.homeErrorLoadingData)));
        }

        final userData = snapshot.data!.data() as Map<String, dynamic>;
        final String? coupleId = userData['coupleId'];
        final String inviteCode = userData['inviteCode'] ?? '---';

        // If not paired, show pairing screen
        if (coupleId == null) {
          return Scaffold(
            appBar: AppBar(
              title: Text(l10n.homeTitle),
              actions: [
                IconButton(icon: const Icon(Icons.logout_rounded), onPressed: () => FirebaseAuth.instance.signOut()),
              ],
            ),
            body: PairingScreen(myInviteCode: inviteCode),
          );
        }

        // If paired, show home screen with memories
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Column(
              children: [
                Text(l10n.homeTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
                PartnerName(coupleId: coupleId),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.person_rounded),
                onPressed: () {
                  // Navigate to profile screen
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfileScreen()));
                },
              ),
            ],
          ),
          body: Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Column(
                  children: [
                    // Search Bar
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: l10n.searchPlaceholder,
                        prefixIcon: const Icon(Icons.search),
                        // Clear button
                        suffixIcon: ValueListenableBuilder<TextEditingValue>(
                          valueListenable: _searchController,
                          builder: (context, value, child) {
                            // If empty, show invisible widget
                            if (value.text.isEmpty) {
                              return const SizedBox.shrink();
                            }

                            // If not empty, show clear button
                            return IconButton(icon: const Icon(Icons.clear), onPressed: _cleanSearch);
                          },
                        ),
                        filled: true,
                        fillColor: Theme.of(context).cardColor,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (value) {
                        _debouncer.run(() {
                          setState(() {
                            _searchQuery = value.toLowerCase();
                          });
                        });
                      },
                    ),
                    const SizedBox(height: 12),
                    // Category Filter Chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterChip(
                            label: l10n.filterAll,
                            id: 'all',
                            isSelected: _selectedCategoryFilter == 'all',
                            icon: Icons.all_inclusive,
                          ),
                          ...appCategories.map((cat) {
                            String label = cat.id;
                            if (cat.id == 'date') label = l10n.dateCategory;
                            if (cat.id == 'travel') label = l10n.travelCategory;
                            if (cat.id == 'milestone') label = l10n.milestoneCategory;
                            if (cat.id == 'daily') label = l10n.dailyCategory;
                            if (cat.id == 'party') label = l10n.partyCategory;

                            return _buildFilterChip(
                              label: label,
                              id: cat.id,
                              isSelected: _selectedCategoryFilter == cat.id,
                              icon: cat.icon,
                              color: cat.color,
                            );
                          }),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Memories List
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: DatabaseService().getMemoriesStream(coupleId),
                  builder: (context, memorySnapshot) {
                    // Loading validations
                    if (memorySnapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    // No memories found
                    if (!memorySnapshot.hasData || memorySnapshot.data!.docs.isEmpty) {
                      if (_searchQuery.isEmpty && _selectedCategoryFilter == 'all') {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.history_edu, size: 80, color: Colors.grey),
                              const SizedBox(height: 20),
                              Text(
                                l10n.noMemoriesYet,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey),
                              ),
                              Text(l10n.addFirstMemory),
                            ],
                          ),
                        );
                      } else {
                        return Center(child: Text(l10n.noMemoriesFound));
                      }
                    }

                    final allMemories = memorySnapshot.data!.docs;
                    final filteredMemories = allMemories.where((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final title = (data['title'] as String? ?? '').toLowerCase();
                      final description = (data['description'] as String? ?? '').toLowerCase();
                      final category = data['category'] as String? ?? 'daily';

                      // Category filter
                      if (_selectedCategoryFilter != 'all' && category != _selectedCategoryFilter) {
                        return false;
                      }

                      // Text filter
                      if (_searchQuery.isNotEmpty) {
                        return title.contains(_searchQuery) || description.contains(_searchQuery);
                      }

                      return true;
                    }).toList();

                    return ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: filteredMemories.length + 1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return _searchQuery.isEmpty && _selectedCategoryFilter == 'all'
                              ? DaysCounter(coupleId: coupleId)
                              : const SizedBox.shrink();
                        }

                        final memoryDoc = filteredMemories[index - 1];
                        final memoryData = memoryDoc.data() as Map<String, dynamic>;

                        return MemoryCard(memoryId: memoryDoc.id, data: memoryData);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          // Floating action button to add new memory
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddMemoryScreen(coupleId: coupleId)));
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  // Filter chip builder
  Widget _buildFilterChip({
    required String label,
    required String id,
    required bool isSelected,
    required IconData icon,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: isSelected ? Colors.white : (color ?? Colors.grey)),
            const SizedBox(width: 6),
            Text(label),
          ],
        ),
        selected: isSelected,
        onSelected: (bool selected) {
          setState(() {
            _selectedCategoryFilter = id;
          });
        },
        checkmarkColor: Colors.white,
        selectedColor: Theme.of(context).primaryColor,
        labelStyle: TextStyle(color: isSelected ? Colors.white : Theme.of(context).textTheme.bodyMedium?.color),
      ),
    );
  }
}

// Debouncer class to handle search input delay
class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
