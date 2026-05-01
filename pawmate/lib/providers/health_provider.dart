import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/health_record.dart';
import '../data/repositories/health_repository.dart';

final healthRepositoryProvider = Provider<HealthRepository>((ref) {
  return HealthRepository();
});

class HealthNotifier extends StateNotifier<List<HealthRecord>> {
  final HealthRepository _repository;
  final String petId;

  HealthNotifier(this._repository, this.petId) : super([]) {
    loadRecords();
  }

  void loadRecords() {
    state = _repository.getRecordsForPet(petId);
  }

  Future<void> addRecord({
    required String title,
    required String category,
    required DateTime date,
    String? notes,
    DateTime? nextDueDate,
  }) async {
    final record = HealthRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      petId: petId,
      date: date,
      title: title,
      category: category,
      notes: notes,
      nextDueDate: nextDueDate,
    );
    await _repository.saveRecord(record);
    loadRecords();
  }

  Future<void> deleteRecord(String id) async {
    await _repository.deleteRecord(id);
    loadRecords();
  }
}

final healthProvider = StateNotifierProvider.family<HealthNotifier, List<HealthRecord>, String>((ref, petId) {
  final repository = ref.watch(healthRepositoryProvider);
  return HealthNotifier(repository, petId);
});