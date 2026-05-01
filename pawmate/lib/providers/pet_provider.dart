import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/pet.dart';
import '../data/repositories/pet_repository.dart';

// 1. This provides our Repository so we can use it anywhere
final petRepositoryProvider = Provider<PetRepository>((ref) {
  return PetRepository();
});

// 2. This is the "Brain" that manages our list of pets
class PetNotifier extends StateNotifier<List<Pet>> {
  final PetRepository _repository;

  // When this starts, it starts with an empty list [], then immediately loads pets
  PetNotifier(this._repository) : super([]) {
    loadPets(); 
  }

  // Grab pets from Hive and update the state
  void loadPets() {
    state = _repository.getAllPets();
  }

  // Save a new pet to Hive, then refresh the state
  Future<void> addPet(Pet pet) async {
    await _repository.addPet(pet);
    loadPets(); 
  }

  // Delete a pet from Hive, then refresh the state
  Future<void> deletePet(String id) async {
    await _repository.deletePet(id);
    loadPets();
  }
}

// 3. This is the actual Provider the UI will listen to!
final petProvider = StateNotifierProvider<PetNotifier, List<Pet>>((ref) {
  final repository = ref.watch(petRepositoryProvider);
  return PetNotifier(repository);
});