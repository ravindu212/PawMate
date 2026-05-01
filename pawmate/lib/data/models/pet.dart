import 'package:hive/hive.dart';

// This line is crucial! It tells Flutter to look for a generated file.
// It will show a red error at first—don't panic, we will generate it in Step 2.
part 'pet.g.dart';

@HiveType(typeId: 0)
class Pet extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String species; // e.g., Dog, Cat, Bird

  @HiveField(3)
  int? age;

  Pet({
    required this.id,
    required this.name,
    required this.species,
    this.age,
  });
}