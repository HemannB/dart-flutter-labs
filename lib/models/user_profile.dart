import 'package:hive/hive.dart';

part 'user_profile.g.dart';

@HiveType(typeId: 0)
class UserProfile extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String sex; // 'male' | 'female'

  @HiveField(2)
  double weightKg;

  @HiveField(3)
  double heightCm;

  @HiveField(4)
  int age;

  @HiveField(5)
  int totalXp;

  @HiveField(6)
  String wakeUpTime; // 'HH:mm'

  @HiveField(7)
  String sleepTime; // 'HH:mm'

  @HiveField(8)
  List<String> earnedBadgeIds;

  @HiveField(9)
  DateTime createdAt;

  UserProfile({
    required this.name,
    required this.sex,
    required this.weightKg,
    required this.heightCm,
    required this.age,
    this.totalXp = 0,
    this.wakeUpTime = '07:00',
    this.sleepTime = '22:00',
    List<String>? earnedBadgeIds,
    DateTime? createdAt,
  })  : earnedBadgeIds = earnedBadgeIds ?? [],
        createdAt = createdAt ?? DateTime.now();

  // Meta de água em ml (35ml/kg homem, 31ml/kg mulher)
  int get dailyWaterGoalMl {
    final multiplier = sex == 'male' ? 35.0 : 31.0;
    return (weightKg * multiplier).round();
  }

  // Nível baseado no XP total
  int get level {
    int lvl = 1;
    int accumulated = 0;
    while (true) {
      final needed = lvl * 200;
      if (accumulated + needed > totalXp) break;
      accumulated += needed;
      lvl++;
    }
    return lvl;
  }

  // XP acumulado dentro do nível atual
  int get xpInCurrentLevel {
    int lvl = 1;
    int accumulated = 0;
    while (true) {
      final needed = lvl * 200;
      if (accumulated + needed > totalXp) break;
      accumulated += needed;
      lvl++;
    }
    return totalXp - accumulated;
  }

  // XP necessário para o próximo nível
  int get xpForNextLevel => level * 200;

  // Progresso 0.0 → 1.0 dentro do nível atual
  double get levelProgress =>
      xpInCurrentLevel / xpForNextLevel;

  void addXp(int amount) {
    totalXp += amount;
    save();
  }

  bool hasBadge(String badgeId) =>
      earnedBadgeIds.contains(badgeId);

  void earnBadge(String badgeId) {
    if (!hasBadge(badgeId)) {
      earnedBadgeIds.add(badgeId);
      save();
    }
  }
}