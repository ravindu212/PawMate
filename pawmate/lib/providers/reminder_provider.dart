import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/reminder.dart';
import '../data/repositories/reminder_repository.dart';

final reminderRepositoryProvider = Provider<ReminderRepository>((ref) {
  return ReminderRepository();
});

class ReminderNotifier extends StateNotifier<List<Reminder>> {
  final ReminderRepository _repository;

  ReminderNotifier(this._repository) : super([]) {
    loadReminders();
  }

  void loadReminders() {
    state = _repository.getAllReminders();
  }

  // Create and save a new reminder
  Future<void> addReminder(String title) async {
    final newReminder = Reminder(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
    );
    await _repository.saveReminder(newReminder);
    loadReminders();
  }

  // Toggle the checkbox between done and not done
  Future<void> toggleReminder(Reminder reminder) async {
    reminder.isCompleted = !reminder.isCompleted;
    await _repository.saveReminder(reminder);
    loadReminders(); // Refresh the UI
  }

  // Delete a reminder
  Future<void> deleteReminder(String id) async {
    await _repository.deleteReminder(id);
    loadReminders();
  }
}

final reminderProvider = StateNotifierProvider<ReminderNotifier, List<Reminder>>((ref) {
  final repository = ref.watch(reminderRepositoryProvider);
  return ReminderNotifier(repository);
});