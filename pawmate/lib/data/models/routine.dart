import 'package:hive/hive.dart';

part 'routine.g.dart';

@HiveType(typeId: 4)
class Routine extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String petId;

  @HiveField(2)
  String title; // e.g., "Morning Walk"

  @HiveField(3)
  DateTime time; // We will use this specifically for the Time (e.g., 08:00 AM)

  @HiveField(4)
  String category; // e.g., 'Food', 'Walk', 'Meds', 'Potty'

  Routine({
    required this.id,
    required this.petId,
    required this.title,
    required this.time,
    required this.category,
  });
}