import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/reminder_provider.dart';


class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the list of reminders
    final reminders = ref.watch(reminderProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Today\'s Tasks'),
      ),
      body: reminders.isEmpty
          ? const Center(
              child: Text('All caught up! Tap + to add a task.'),
            )
          : ListView.builder(
              itemCount: reminders.length,
              itemBuilder: (context, index) {
                final reminder = reminders[index];
                
                return CheckboxListTile(
                  title: Text(
                    reminder.title,
                    style: TextStyle(
                      // Put a line through the text if it's completed!
                      decoration: reminder.isCompleted 
                          ? TextDecoration.lineThrough 
                          : null,
                    ),
                  ),
                  value: reminder.isCompleted,
                  onChanged: (bool? newValue) {
                    // Toggle the status in the database
                    ref.read(reminderProvider.notifier).toggleReminder(reminder);
                  },
                  secondary: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.grey),
                    onPressed: () {
                      ref.read(reminderProvider.notifier).deleteReminder(reminder.id);
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  // A simple pop-up box to type a new task
  void _showAddDialog(BuildContext context, WidgetRef ref) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('New Task'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'e.g., Feed the dog'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  ref.read(reminderProvider.notifier).addReminder(controller.text);
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