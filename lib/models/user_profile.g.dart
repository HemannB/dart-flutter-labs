// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserProfileAdapter extends TypeAdapter<UserProfile> {
  @override
  final int typeId = 0;

  @override
  UserProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProfile(
      name: fields[0] as String,
      sex: fields[1] as String,
      weightKg: fields[2] as double,
      heightCm: fields[3] as double,
      age: fields[4] as int,
      totalXp: fields[5] as int,
      wakeUpTime: fields[6] as String,
      sleepTime: fields[7] as String,
      earnedBadgeIds: (fields[8] as List?)?.cast<String>(),
      createdAt: fields[9] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, UserProfile obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.sex)
      ..writeByte(2)
      ..write(obj.weightKg)
      ..writeByte(3)
      ..write(obj.heightCm)
      ..writeByte(4)
      ..write(obj.age)
      ..writeByte(5)
      ..write(obj.totalXp)
      ..writeByte(6)
      ..write(obj.wakeUpTime)
      ..writeByte(7)
      ..write(obj.sleepTime)
      ..writeByte(8)
      ..write(obj.earnedBadgeIds)
      ..writeByte(9)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
