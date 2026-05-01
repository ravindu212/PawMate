import 'package:hive_flutter/hive_flutter.dart';
import '../models/health_record.dart';

class HealthRepository {
  final String _boxName = 'healthRecordsBox';

  Box<HealthRecord> get _box => Hive.box<HealthRecord>(_boxName);

  List<HealthRecord> getRecordsForPet(String petId) {
    final records = _box.values.where((record) => record.petId == petId).toList();
    records.sort((a, b) => b.date.compareTo(a.date)); // Newest at the top!
    return records;
  }

  Future<void> saveRecord(HealthRecord record) async {
    await _box.put(record.id, record);
  }

  Future<void> deleteRecord(String id) async {
    await _box.delete(id);
  }
}