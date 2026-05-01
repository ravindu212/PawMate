import 'package:hive_flutter/hive_flutter.dart';
import '../models/reminder.dart';

// Flutter is looking for this exact word 'ReminderRepository'
class ReminderRepository { 
  final String _boxName = 'remindersBox';

  Box<Reminder> get _box => Hive.box<Reminder>(_boxName);

  List<Reminder> getAllReminders() {
    return _box.values.toList();
  }

  Future<void> saveReminder(Reminder reminder) async {
    await _box.put(reminder.id, reminder);
  }

  Future<void> deleteReminder(String id) async {
    await _box.delete(id);
  }
}