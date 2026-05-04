// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GoalAdapter extends TypeAdapter<Goal> {
  @override
  final int typeId = 2;

  @override
  Goal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Goal(
      id: fields[0] as String,
      type: fields[1] as GoalType,
      isActive: fields[2] as bool,
      dailyWaterGoalMl: fields[3] as int?,
      glassVolumeMl: fields[4] as int?,
      targetWakeUpTime: fields[5] as String?,
      alarmEnabled: fields[6] as bool?,
      currentBookTitle: fields[7] as String?,
      currentBookTotalPages: fields[8] as int?,
      currentBookCurrentPage: fields[9] as int?,
      dailyReadingGoalPages: fields[10] as int?,
      totalBooksFinished: fields[11] as int,
      createdAt: fields[12] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Goal obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.isActive)
      ..writeByte(3)
      ..write(obj.dailyWaterGoalMl)
      ..writeByte(4)
      ..write(obj.glassVolumeMl)
      ..writeByte(5)
      ..write(obj.targetWakeUpTime)
      ..writeByte(6)
      ..write(obj.alarmEnabled)
      ..writeByte(7)
      ..write(obj.currentBookTitle)
      ..writeByte(8)
      ..write(obj.currentBookTotalPages)
      ..writeByte(9)
      ..write(obj.currentBookCurrentPage)
      ..writeByte(10)
      ..write(obj.dailyReadingGoalPages)
      ..writeByte(11)
      ..write(obj.totalBooksFinished)
      ..writeByte(12)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GoalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class GoalTypeAdapter extends TypeAdapter<GoalType> {
  @override
  final int typeId = 1;

  @override
  GoalType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return GoalType.water;
      case 1:
        return GoalType.wakeup;
      case 2:
        return GoalType.reading;
      default:
        return GoalType.water;
    }
  }

  @override
  void write(BinaryWriter writer, GoalType obj) {
    switch (obj) {
      case GoalType.water:
        writer.writeByte(0);
        break;
      case GoalType.wakeup:
        writer.writeByte(1);
        break;
      case GoalType.reading:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GoalTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
