import 'package:hive/hive.dart';

part 'goal_log.g.dart';

@HiveType(typeId: 3)
enum LogType {
  @HiveField(0)
  waterGlass,     // registrou um copo de água

  @HiveField(1)
  wakeUpChecked,  // confirmou que acordou

  @HiveField(2)
  readingPages,   // registrou páginas lidas

  @HiveField(3)
  bookFinished,   // finalizou um livro
}

@HiveType(typeId: 4)
class GoalLog extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String goalId;

  @HiveField(2)
  LogType type;

  @HiveField(3)
  DateTime timestamp;

  @HiveField(4)
  int? intValue; // ml de água ou páginas lidas

  @HiveField(5)
  String? stringValue; // título do livro, etc

  @HiveField(6)
  bool goalCompletedToday; // esse registro completou a meta do dia?

  GoalLog({
    required this.id,
    required this.goalId,
    required this.type,
    DateTime? timestamp,
    this.intValue,
    this.stringValue,
    this.goalCompletedToday = false,
  }) : timestamp = timestamp ?? DateTime.now();

  // Chave no formato 'YYYY-MM-DD' para agrupar por dia
  String get dateKey {
    final d = timestamp;
    return '${d.year}-'
        '${d.month.toString().padLeft(2, '0')}-'
        '${d.day.toString().padLeft(2, '0')}';
  }

  static String dateKeyFromDate(DateTime d) {
    return '${d.year}-'
        '${d.month.toString().padLeft(2, '0')}-'
        '${d.day.toString().padLeft(2, '0')}';
  }
}