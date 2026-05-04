import 'package:hive/hive.dart';

part 'goal.g.dart';

@HiveType(typeId: 1)
enum GoalType {
  @HiveField(0)
  water,
  @HiveField(1)
  wakeup,
  @HiveField(2)
  reading,
}

@HiveType(typeId: 2)
class Goal extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  GoalType type;

  @HiveField(2)
  bool isActive;

  // ── Água ──────────────────────────────
  @HiveField(3)
  int? dailyWaterGoalMl; // null = usa cálculo do perfil

  @HiveField(4)
  int? glassVolumeMl;

  // ── Acordar cedo ──────────────────────
  @HiveField(5)
  String? targetWakeUpTime; // 'HH:mm'

  @HiveField(6)
  bool? alarmEnabled;

  // ── Leitura ───────────────────────────
  @HiveField(7)
  String? currentBookTitle;

  @HiveField(8)
  int? currentBookTotalPages;

  @HiveField(9)
  int? currentBookCurrentPage;

  @HiveField(10)
  int? dailyReadingGoalPages;

  @HiveField(11)
  int totalBooksFinished;

  @HiveField(12)
  DateTime createdAt;

  Goal({
    required this.id,
    required this.type,
    this.isActive = true,
    this.dailyWaterGoalMl,
    this.glassVolumeMl = 200,
    this.targetWakeUpTime,
    this.alarmEnabled = false,
    this.currentBookTitle,
    this.currentBookTotalPages,
    this.currentBookCurrentPage = 0,
    this.dailyReadingGoalPages = 20,
    this.totalBooksFinished = 0,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  String get displayName {
    switch (type) {
      case GoalType.water:   return 'Água';
      case GoalType.wakeup:  return 'Acordar cedo';
      case GoalType.reading: return 'Leitura';
    }
  }

  String get emoji {
    switch (type) {
      case GoalType.water:   return '💧';
      case GoalType.wakeup:  return '⏰';
      case GoalType.reading: return '📚';
    }
  }
}