import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/weight_record.dart';
import '../data/repositories/weight_repository.dart';

final weightRepositoryProvider = Provider<WeightRepository>((ref) {
  return WeightRepository();
});

class WeightNotifier extends StateNotifier<List<WeightRecord>> {
  final WeightRepository _repository;
  final String petId;

  WeightNotifier(this._repository, this.petId) : super([]) {
    loadWeights();
  }

  void loadWeights() {
    state = _repository.getWeightsForPet(petId);
  }

  Future<void> addWeight(double weight, DateTime date) async {
    final record = WeightRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      petId: petId,
      date: date,
      weight: weight,
    );
    await _repository.saveWeight(record);
    loadWeights();
  }

  Future<void> deleteWeight(String id) async {
    await _repository.deleteWeight(id);
    loadWeights();
  }
}

final weightProvider = StateNotifierProvider.family<WeightNotifier, List<WeightRecord>, String>((ref, petId) {
  final repository = ref.watch(weightRepositoryProvider);
  return WeightNotifier(repository, petId);
});