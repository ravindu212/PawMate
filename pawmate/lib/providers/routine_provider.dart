import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/routine.dart';
import '../data/repositories/routine_repository.dart';

final routineRepositoryProvider = Provider<RoutineRepository>((ref) {
  return RoutineRepository();
});

class RoutineNotifier extends StateNotifier<List<Routine>> {
  final RoutineRepository _repository;
  final String petId;

  RoutineNotifier(this._repository, this.petId) : super([]) {
    loadRoutines();
  }

  void loadRoutines() {
    state = _repository.getRoutinesForPet(petId);
  }

  Future<void> addRoutine({
    required String title,
    required DateTime time,
    required String category,
  }) async {
    final routine = Routine(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      petId: petId,
      title: title,
      time: time,
      category: category,
    );
    await _repository.saveRoutine(routine);
    loadRoutines();
  }

  Future<void> deleteRoutine(String id) async {
    await _repository.deleteRoutine(id);
    loadRoutines();
  }
}

final routineProvider = StateNotifierProvider.family<RoutineNotifier, List<Routine>, String>((ref, petId) {
  final repository = ref.watch(routineRepositoryProvider);
  return RoutineNotifier(repository, petId);
});