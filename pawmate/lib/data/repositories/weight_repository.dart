import 'package:hive_flutter/hive_flutter.dart';
import '../models/weight_record.dart';

class WeightRepository {
  final String _boxName = 'weightBox';

  Box<WeightRecord> get _box => Hive.box<WeightRecord>(_boxName);

  // Fetch weights for ONE pet and sort them chronologically
  List<WeightRecord> getWeightsForPet(String petId) {
    final records = _box.values.where((record) => record.petId == petId).toList();
    records.sort((a, b) => a.date.compareTo(b.date)); 
    return records;
  }

  Future<void> saveWeight(WeightRecord record) async {
    await _box.put(record.id, record);
  }

  Future<void> deleteWeight(String id) async {
    await _box.delete(id);
  }
}