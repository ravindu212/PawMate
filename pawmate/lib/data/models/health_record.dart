import 'package:hive/hive.dart';

part 'health_record.g.dart';

@HiveType(typeId: 2)
class HealthRecord extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String petId;

  @HiveField(2)
  DateTime date;

  @HiveField(3)
  String title; // e.g., "Rabies" or "Annual Checkup"

  @HiveField(4)
  String category; // 'Vaccination', 'Checkup', 'Medication', 'Surgery'

  @HiveField(5)
  String? notes;

  @HiveField(6)
  DateTime? nextDueDate; // For future reminders!

  HealthRecord({
    required this.id,
    required this.petId,
    required this.date,
    required this.title,
    required this.category,
    this.notes,
    this.nextDueDate,
  });
}