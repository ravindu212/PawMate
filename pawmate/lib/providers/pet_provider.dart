import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/pet.dart';
import '../data/repositories/pet_repository.dart';

final petRepositoryProvider = Provider<PetRepository>((ref) {
  return PetRepository();
});

class PetNotifier extends StateNotifier<List<Pet>> {
  final PetRepository _repository;

  PetNotifier(this._repository) : super([]) {
    loadPets();
  }

  void loadPets() {
    state = _repository.getAllPets();
  }

  // <-- We must include ALL named parameters here!
  Future<void> addPet({
    required String name,
    required String species,
    required DateTime dateOfBirth,
    String? breed,
    String? motherBreed,
    String? fatherBreed,
  }) async {
    final newPet = Pet(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      species: species,
      dateOfBirth: dateOfBirth,
      breed: breed,
      motherBreed: motherBreed,
      fatherBreed: fatherBreed,
    );
    await _repository.savePet(newPet);
    loadPets();
  }

  Future<void> deletePet(String id) async {
    await _repository.deletePet(id);
    loadPets();
  }
}

final petProvider = StateNotifierProvider<PetNotifier, List<Pet>>((ref) {
  final repository = ref.watch(petRepositoryProvider);
  return PetNotifier(repository);
});