import 'package:flutter/material.dart';

class AddMemoryScreen extends StatefulWidget {
  const AddMemoryScreen({super.key});

  @override
  State<AddMemoryScreen> createState() => _AddMemoryScreenState();
}

class _AddMemoryScreenState extends State<AddMemoryScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("New Memory"), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Title TextField
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                prefixIcon: const Icon(Icons.title),
              ),
            ),
            const SizedBox(height: 20),

            // Description TextField
            TextField(
              controller: _descController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: 'Description',
                alignLabelWithHint: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
                prefixIcon: const Icon(Icons.notes),
              ),
            ),
            const SizedBox(height: 20),

            // Date Picker
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
                side: BorderSide(color: Colors.grey.shade400),
              ),
              leading: const Icon(Icons.calendar_today, color: Colors.deepPurple),
              title: const Text('Date'),
              subtitle: Text('${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}'),
              onTap: () {
                // Date picker logic here
              },
            ),
            const SizedBox(height: 40),

            // Save Button
            FilledButton.icon(
              onPressed: () {
                // Pendient Logic
                Navigator.pop(context);
              },
              icon: const Icon(Icons.save),
              label: const Text('Save Memory'),
              style: FilledButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
            ),
          ],
        ),
      ),
    );
  }
}
