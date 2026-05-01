import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/health_record.dart';
import '../data/repositories/health_record_repository.dart';

// 1. The Repository Provider (The Kitchen)
final healthRecordRepositoryProvider = Provider<HealthRecordRepository>((ref) {
  return HealthRecordRepository();
});

// 2. The State Notifier (The Waiter's Brain)
class HealthRecordNotifier extends StateNotifier<List<HealthRecord>> {
  final HealthRecordRepository _repository;
  final String petId; // We store the specific pet's ID here!

  HealthRecordNotifier(this._repository, this.petId) : super([]) {
    loadRecords();
  }

  // Fetch only the records for this specific pet
  void loadRecords() {
    state = _repository.getRecordsForPet(petId);
  }

  // Add a new medical record
  Future<void> addRecord({
    required String title,
    required DateTime date,
    String notes = '',
  }) async {
    final newRecord = HealthRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      petId: petId, // Automatically link it to this pet
      title: title,
      date: date,
      notes: notes,
    );
    await _repository.saveRecord(newRecord);
    loadRecords(); // Refresh the list
  }

  // Delete a record
  Future<void> deleteRecord(String id) async {
    await _repository.deleteRecord(id);
    loadRecords();
  }
}

// 3. The Family Provider (The Waiter)
// The `.family` part tells Riverpod to expect a String (the petId) when called
final healthRecordProvider = StateNotifierProvider.family<HealthRecordNotifier, List<HealthRecord>, String>((ref, petId) {
  final repository = ref.watch(healthRecordRepositoryProvider);
  return HealthRecordNotifier(repository, petId);
});