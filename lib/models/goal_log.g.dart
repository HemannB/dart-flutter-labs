// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_log.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GoalLogAdapter extends TypeAdapter<GoalLog> {
  @override
  final int typeId = 4;

  @override
  GoalLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GoalLog(
      id: fields[0] as String,
      goalId: fields[1] as String,
      type: fields[2] as LogType,
      timestamp: fields[3] as DateTime?,
      intValue: fields[4] as int?,
      stringValue: fields[5] as String?,
      goalCompletedToday: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, GoalLog obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.goalId)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.timestamp)
      ..writeByte(4)
      ..write(obj.intValue)
      ..writeByte(5)
      ..write(obj.stringValue)
      ..writeByte(6)
      ..write(obj.goalCompletedToday);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GoalLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class LogTypeAdapter extends TypeAdapter<LogType> {
  @override
  final int typeId = 3;

  @override
  LogType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return LogType.waterGlass;
      case 1:
        return LogType.wakeUpChecked;
      case 2:
        return LogType.readingPages;
      case 3:
        return LogType.bookFinished;
      default:
        return LogType.waterGlass;
    }
  }

  @override
  void write(BinaryWriter writer, LogType obj) {
    switch (obj) {
      case LogType.waterGlass:
        writer.writeByte(0);
        break;
      case LogType.wakeUpChecked:
        writer.writeByte(1);
        break;
      case LogType.readingPages:
        writer.writeByte(2);
        break;
      case LogType.bookFinished:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LogTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
