import 'package:hive/hive.dart';

part 'weight_record.g.dart';

@HiveType(typeId: 3) 
class WeightRecord extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String petId;

  @HiveField(2)
  DateTime date;

  @HiveField(3)
  double weight;

  WeightRecord({
    required this.id,
    required this.petId,
    required this.date,
    required this.weight,
  });
}