import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart'; // This makes our dates look pretty!
import '../../../providers/health_record_provider.dart';
import '../../../data/models/pet.dart';

class HealthRecordsScreen extends ConsumerWidget {
  final Pet pet; // This screen REQUIRES a pet to be passed into it

  const HealthRecordsScreen({Key? key, required this.pet}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Here is the magic! We use pet.id to ask the waiter for THIS pet's specific records
    final records = ref.watch(healthRecordProvider(pet.id));

    return Scaffold(
      appBar: AppBar(
        title: Text('${pet.name}\'s Health Records'),
      ),
      body: records.isEmpty
          ? Center(
              child: Text('No records for ${pet.name} yet. Tap + to add one!'),
            )
          : ListView.builder(
              itemCount: records.length,
              itemBuilder: (context, index) {
                final record = records[index];
                // Format the date (e.g., Oct 12, 2023)
                final formattedDate = DateFormat.yMMMd().format(record.date);

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: const Icon(Icons.medical_services, color: Colors.teal),
                    title: Text(record.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('$formattedDate\n${record.notes}'),
                    isThreeLine: record.notes.isNotEmpty,
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                      onPressed: () {
                        // Delete this specific record
                        ref.read(healthRecordProvider(pet.id).notifier).deleteRecord(record.id);
                      },
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddRecordDialog(context, ref, pet.id),
        child: const Icon(Icons.add),
      ),
    );
  }

  // A pop-up dialog to add a new medical record
  void _showAddRecordDialog(BuildContext context, WidgetRef ref, String petId) {
    final titleController = TextEditingController();
    final notesController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Medical Record'),
          content: Column(
            mainAxisSize: MainAxisSize.min, // Shrinks to fit the content
            children: [
              TextField(
                controller: titleController,
                autofocus: true,
                decoration: const InputDecoration(labelText: 'Title (e.g., Rabies Vaccine)'),
              ),
              TextField(
                controller: notesController,
                decoration: const InputDecoration(labelText: 'Notes (Optional)'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (titleController.text.isNotEmpty) {
                  // Save the record using our Waiter!
                  ref.read(healthRecordProvider(petId).notifier).addRecord(
                        title: titleController.text,
                        date: DateTime.now(), // We use today's date automatically
                        notes: notesController.text,
                      );
                  Navigator.pop(context); // Close the dialog
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}