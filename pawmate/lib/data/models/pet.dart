import 'package:hive/hive.dart';

part 'pet.g.dart';

@HiveType(typeId: 0)
class Pet extends HiveObject {
  @HiveField(0)
  late String name;

  @HiveField(1)
  late String species;

  @HiveField(2)
  late String breed;

  @HiveField(3)
  late DateTime dateOfBirth;

  @HiveField(4)
  String? profilePhotoPath;

  @HiveField(5)
  late int genderIndex; // 0=male, 1=female, 2=unknown

  PetGender get gender => PetGender.values[genderIndex];
  set gender(PetGender g) => genderIndex = g.index;
}

enum PetGender { male, female, unknown }