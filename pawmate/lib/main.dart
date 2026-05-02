import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'data/models/pet.dart'; 
import 'data/models/reminder.dart'; 
import 'data/models/health_record.dart';
import 'data/models/weight_record.dart';
import 'data/models/routine.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  
  // Pet Database
  Hive.registerAdapter(PetAdapter());
  await Hive.openBox<Pet>('petsBox'); 
  
  // Reminder Database 
  Hive.registerAdapter(ReminderAdapter());
  await Hive.openBox<Reminder>('remindersBox'); 
  
  // Health Record Database (Add these two lines!)
  Hive.registerAdapter(HealthRecordAdapter());
  await Hive.openBox<HealthRecord>('healthRecordsBox'); 

  Hive.registerAdapter(WeightRecordAdapter());
  await Hive.openBox<WeightRecord>('weightBox');

  Hive.registerAdapter(RoutineAdapter()); // You will see a red line here, ignore it for a moment!
  await Hive.openBox<Routine>('routineBox');
  
  runApp(const ProviderScope(child: PawMateApp())); 
}