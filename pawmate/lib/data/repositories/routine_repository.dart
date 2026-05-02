import 'package:hive_flutter/hive_flutter.dart';
import '../models/routine.dart';

class RoutineRepository {
  final String _boxName = 'routineBox';

  Box<Routine> get _box => Hive.box<Routine>(_boxName);

  List<Routine> getRoutinesForPet(String petId) {
    final routines = _box.values.where((r) => r.petId == petId).toList();
    // Sort them so morning tasks always appear before evening tasks!
    routines.sort((a, b) => a.time.hour.compareTo(b.time.hour) != 0 
        ? a.time.hour.compareTo(b.time.hour) 
        : a.time.minute.compareTo(b.time.minute));
    return routines;
  }

  Future<void> saveRoutine(Routine routine) async {
    await _box.put(routine.id, routine);
  }

  Future<void> deleteRoutine(String id) async {
    await _box.delete(id);
  }
}