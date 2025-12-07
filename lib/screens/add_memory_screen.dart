import 'package:flutter/material.dart';
import 'package:couple_timeline/services/database_service.dart';
import 'package:couple_timeline/l10n/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddMemoryScreen extends StatefulWidget {
  final String coupleId;
  final String? memoryId;
  final Map<String, dynamic>? initialData;
  const AddMemoryScreen({super.key, required this.coupleId, this.memoryId, this.initialData});

  @override
  State<AddMemoryScreen> createState() => _AddMemoryScreenState();
}

class _AddMemoryScreenState extends State<AddMemoryScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _locationController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // If editing, pre-fill fields
    if (widget.initialData != null) {
      _titleController.text = widget.initialData!['title'] ?? '';
      _descController.text = widget.initialData!['description'] ?? '';
      _locationController.text = widget.initialData!['location'] ?? '';

      if (widget.initialData!['date'] != null) {
        final timestamp = widget.initialData!['date'];
        if (timestamp is DateTime) {
          _selectedDate = timestamp;
        } else {
          _selectedDate = timestamp.toDate();
        }
      }
    }
  }

  // Function to open date picker
  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Function to save memory
  void _saveMemory() async {
    final l10n = AppLocalizations.of(context)!;
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.enterTitleError)));
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (widget.memoryId == null) {
        // Adding new memory
        await DatabaseService().addMemory(
          coupleId: widget.coupleId,
          title: _titleController.text.trim(),
          description: _descController.text.trim(),
          date: _selectedDate,
          location: _locationController.text.trim(),
        );
      } else {
        // Updating existing memory
        await DatabaseService().updateMemory(
          memoryId: widget.memoryId!,
          title: _titleController.text.trim(),
          description: _descController.text.trim(),
          date: _selectedDate,
          location: _locationController.text.trim(),
        );
      }

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.memorySavedMsg)));
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('${l10n.saveError}: $e'), backgroundColor: Colors.red));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dateString = '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}';
    final isEditing = widget.memoryId != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? l10n.editMemoryTitle : l10n.newMemoryTitle), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // TITLE
            TextField(
              controller: _titleController,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: l10n.titleLabel,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                prefixIcon: const Icon(Icons.title),
              ),
            ),
            const SizedBox(height: 20),

            // DATE
            InkWell(
              onTap: _pickDate,
              borderRadius: BorderRadius.circular(12.0),
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: l10n.dateLabel,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                  prefixIcon: const Icon(Icons.calendar_today),
                ),
                child: Text(dateString, style: const TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(height: 20),

            // LOCATION
            TextField(
              controller: _locationController,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                labelText: l10n.locationLabel,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                prefixIcon: const Icon(Icons.location_on_outlined),
              ),
            ),
            const SizedBox(height: 20),

            // DESCRIPTION
            TextField(
              controller: _descController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: l10n.descriptionLabel,
                alignLabelWithHint: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                prefixIcon: const Icon(Icons.notes),
              ),
            ),
            const SizedBox(height: 20),

            // SAVE BUTTON
            FilledButton.icon(
              onPressed: _isLoading ? null : _saveMemory,
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.save),
              label: Text(_isLoading ? l10n.savingButton : (isEditing ? l10n.updateButton : l10n.saveButton)),
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
