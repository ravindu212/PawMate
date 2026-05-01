import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/pet.dart';
import '../data/repositories/pet_repository.dart';

final petRepositoryProvider = Provider((ref) => PetRepository());

final petsProvider = FutureProvider<List<Pet>>((ref) async {
  final repo = ref.read(petRepositoryProvider);
  return repo.getAllPets();
});