import 'package:hive_flutter/hive_flutter.dart';
import '../models/health_record.dart';

class HealthRecordRepository {
  final String _boxName = 'healthRecordsBox';

  Box<HealthRecord> get _box => Hive.box<HealthRecord>(_boxName);

  // Notice this method! It filters the box to only return records for ONE specific pet.
  List<HealthRecord> getRecordsForPet(String petId) {
    return _box.values.where((record) => record.petId == petId).toList();
  }

  // Add or update a record
  Future<void> saveRecord(HealthRecord record) async {
    await _box.put(record.id, record);
  }

  // Delete a record
  Future<void> deleteRecord(String id) async {
    await _box.delete(id);
  }
}