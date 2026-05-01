import 'package:hive/hive.dart';

part 'reminder.g.dart';

@HiveType(typeId: 1) 
class Reminder extends HiveObject { // <-- Flutter is looking for this exact word 'Reminder'
  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  bool isCompleted;

  Reminder({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });
}