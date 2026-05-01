import 'package:hive_flutter/hive_flutter.dart';
import '../models/pet.dart';

class PetRepository {
  final String _boxName = 'petsBox';

  // Get the box
  Box<Pet> get _box => Hive.box<Pet>(_boxName);

  // Read all pets
  List<Pet> getAllPets() {
    return _box.values.toList();
  }

  // Add a new pet
  Future<void> addPet(Pet pet) async {
    await _box.put(pet.id, pet);
  }

  // Delete a pet
  Future<void> deletePet(String id) async {
    await _box.delete(id);
  }
}