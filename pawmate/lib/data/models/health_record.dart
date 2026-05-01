import 'package:hive/hive.dart';

// This tells Hive to generate our adapter
part 'health_record.g.dart';

@HiveType(typeId: 2) 
class HealthRecord extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String petId; // <-- This is the secret link to the Pet!

  @HiveField(2)
  String title; // e.g., "Rabies Vaccine", "Annual Checkup"

  @HiveField(3)
  DateTime date; // When it happened

  @HiveField(4)
  String notes; // Any extra details from the vet

  HealthRecord({
    required this.id,
    required this.petId,
    required this.title,
    required this.date,
    this.notes = '',
  });
}