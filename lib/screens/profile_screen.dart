import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:couple_timeline/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:couple_timeline/l10n/app_localizations.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final _nameFocusNode = FocusNode();
  bool _isEditing = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // Initialize with current name if exists
    _nameController.text = FirebaseAuth.instance.currentUser?.displayName ?? '';
  }

  // Clean up resources
  @override
  void dispose() {
    _nameController.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  void _updateName() async {
    final l10n = AppLocalizations.of(context)!;

    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.fieldUnfilledError), backgroundColor: Colors.orange));
      return;
    }

    setState(() => _isLoading = true);

    try {
      await DatabaseService().updateUserName(_nameController.text.trim());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.nameUpdatedMsg)));
        setState(() {
          _isEditing = false;
          _isLoading = false;
        });
        _nameFocusNode.unfocus();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red));
      }
    }
  }

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
    });

    if (_isEditing) {
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          _nameFocusNode.requestFocus();
        }
      });
    } else {
      _nameFocusNode.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.profileTitle), centerTitle: true),
      body: StreamBuilder<DocumentSnapshot>(
        stream: DatabaseService().getUserStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Extract user data
          final userData = snapshot.data?.data() as Map<String, dynamic>?;
          final String inviteCode = userData?['inviteCode'] ?? '---';

          // Sync name controller if not editing
          if (!_isEditing && userData != null && userData['name'] != null) {
            // Only update if different to avoid cursor jump
            if (_nameController.text != userData['name']) {
              _nameController.text = userData['name'];
            }
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  child: Text(
                    (_nameController.text.isNotEmpty ? _nameController.text[0] : '?').toUpperCase(),
                    style: TextStyle(fontSize: 40, color: Theme.of(context).colorScheme.primary),
                  ),
                ),
                const SizedBox(height: 40),

                // Name Field
                TextField(
                  controller: _nameController,
                  focusNode: _nameFocusNode,
                  readOnly: !_isEditing,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: l10n.nameLabel,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                    prefixIcon: const Icon(Icons.person),
                    suffixIcon: IconButton(
                      icon: Icon(_isEditing ? Icons.check : Icons.edit),
                      onPressed: _isLoading
                          ? null
                          : () {
                              if (_isEditing) {
                                // Save name
                                _updateName();
                              } else {
                                // Enable editing
                                _toggleEditing();
                              }
                            },
                    ),
                    filled: !_isEditing,
                    fillColor: _isEditing ? null : Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
                  ),
                  onSubmitted: (_) => _updateName(),
                ),
                const SizedBox(height: 20),

                // Email Field (read-only)
                TextField(
                  readOnly: true,
                  controller: TextEditingController(text: user?.email),
                  decoration: InputDecoration(
                    labelText: l10n.emailLabel,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                    prefixIcon: const Icon(Icons.email),
                    filled: true,
                    fillColor: Theme.of(context).hoverColor,
                  ),
                ),
                const SizedBox(height: 20),

                // Invite Code Field
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          l10n.myCodeLabel,
                          style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              inviteCode,
                              style: const TextStyle(fontSize: 28, letterSpacing: 4, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(width: 10),
                            IconButton(
                              icon: const Icon(Icons.copy),
                              tooltip: l10n.copyCodeTooltip,
                              onPressed: () {
                                Clipboard.setData(ClipboardData(text: inviteCode));
                                ScaffoldMessenger.of(
                                  context,
                                ).showSnackBar(SnackBar(content: Text(l10n.codeCopiedMessage)));
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 60),

                // Logout Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context); // Close profile screen
                      FirebaseAuth.instance.signOut(); // Sign out
                    },
                    icon: const Icon(Icons.logout, color: Colors.red),
                    label: Text(l10n.logoutLabel, style: const TextStyle(color: Colors.red)),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
