import 'package:hive_flutter/hive_flutter.dart';
import '../models/pet.dart';

class PetRepository {
  static const _boxName = 'pets';

  Future<Box<Pet>> get _box async => Hive.openBox<Pet>(_boxName);

  Future<List<Pet>> getAllPets() async {
    final box = await _box;
    return box.values.toList();
  }

  Future<void> addPet(Pet pet) async {
    final box = await _box;
    await box.add(pet);
  }

  Future<void> deletePet(Pet pet) async {
    await pet.delete();
  }
}