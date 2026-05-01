// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pet.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PetAdapter extends TypeAdapter<Pet> {
  @override
  final int typeId = 0;

  @override
  Pet read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Pet()
      ..name = fields[0] as String
      ..species = fields[1] as String
      ..breed = fields[2] as String
      ..dateOfBirth = fields[3] as DateTime
      ..profilePhotoPath = fields[4] as String?
      ..genderIndex = fields[5] as int;
  }

  @override
  void write(BinaryWriter writer, Pet obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.species)
      ..writeByte(2)
      ..write(obj.breed)
      ..writeByte(3)
      ..write(obj.dateOfBirth)
      ..writeByte(4)
      ..write(obj.profilePhotoPath)
      ..writeByte(5)
      ..write(obj.genderIndex);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PetAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
