import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'data/models/pet.dart'; 
import 'data/models/reminder.dart'; // <-- 1. Added the reminder model import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  
  // Pet Database
  Hive.registerAdapter(PetAdapter());
  await Hive.openBox<Pet>('petsBox'); 
  
  // Reminder Database 
  Hive.registerAdapter(ReminderAdapter()); // <-- 2. Register the Reminder adapter
  await Hive.openBox<Reminder>('remindersBox'); // <-- 3. Open the reminders box
  
  // Wrap PawMateApp in ProviderScope!
  runApp(const ProviderScope(child: PawMateApp())); 
}