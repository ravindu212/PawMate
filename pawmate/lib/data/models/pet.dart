import 'package:hive/hive.dart';

part 'pet.g.dart';

@HiveType(typeId: 0)
class Pet extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String species;

  @HiveField(3)
  DateTime dateOfBirth; 

  @HiveField(4)
  String? breed; 

  @HiveField(5)
  String? motherBreed;

  @HiveField(6)
  String? fatherBreed;

  Pet({
    required this.id,
    required this.name,
    required this.species,
    required this.dateOfBirth,
    this.breed,
    this.motherBreed,
    this.fatherBreed,
  });

  // Advanced Exact Age Calculator
  String get age {
    final now = DateTime.now();
    int years = now.year - dateOfBirth.year;
    int months = now.month - dateOfBirth.month;
    int days = now.day - dateOfBirth.day;

    // If days are negative, "borrow" a month
    if (days < 0) {
      months--;
      // Find out how many days were in the previous month to add them accurately
      final prevMonth = now.month == 1 ? 12 : now.month - 1;
      final yearOfPrevMonth = now.month == 1 ? now.year - 1 : now.year;
      // DateTime trick: Day '0' of the next month gives the last day of the target month
      final daysInPrevMonth = DateTime(yearOfPrevMonth, prevMonth + 1, 0).day;
      days += daysInPrevMonth;
    }

    // If months are negative, "borrow" a year
    if (months < 0) {
      years--;
      months += 12;
    }

    // Grammar helpers (handles plural vs singular)
    String yearStr = years == 1 ? '1 year' : '$years years';
    String monthStr = months == 1 ? '1 month' : '$months months';
    String dayStr = days == 1 ? '1 day' : '$days days';

    // Rule 1: Younger than 1 month
    if (years == 0 && months == 0) {
      return dayStr; // e.g., "11 days"
    } 
    // Rule 2: Younger than 1 year
    else if (years == 0) {
      if (days == 0) return monthStr; // Exactly X months
      return '$monthStr and $dayStr'; // e.g., "1 month and 2 days"
    } 
    // Rule 3: 1 year or older
    else {
      String result = yearStr;
      if (months > 0) result += ' and $monthStr';
      if (days > 0) result += ' and $dayStr';
      return result; // e.g., "2 years and 5 months and 15 days"
    }
  }
}