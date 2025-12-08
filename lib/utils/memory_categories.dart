import 'package:flutter/material.dart';

// Category definition
class MemoryCategory {
  final String id;
  final IconData icon;
  final Color color;
  final String labelKey;

  const MemoryCategory({required this.id, required this.icon, required this.color, required this.labelKey});
}

// List of predefined categories
final List<MemoryCategory> appCategories = [
  const MemoryCategory(id: 'date', icon: Icons.restaurant, color: Colors.pinkAccent, labelKey: 'dateCategory'),
  const MemoryCategory(id: 'travel', icon: Icons.flight, color: Colors.lightBlue, labelKey: 'travelCategory'),
  const MemoryCategory(id: 'milestone', icon: Icons.flag, color: Colors.orange, labelKey: 'milestoneCategory'),
  const MemoryCategory(id: 'daily', icon: Icons.home, color: Colors.green, labelKey: 'dailyCategory'),
  const MemoryCategory(id: 'party', icon: Icons.celebration, color: Colors.purple, labelKey: 'partyCategory'),
];

// Function to get category by ID
MemoryCategory getCategoryById(String id) {
  return appCategories.firstWhere(
    (cat) => cat.id == id,
    orElse: () => appCategories[3], // Default to 'daily' category
  );
}
