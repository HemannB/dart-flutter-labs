import 'package:hive_flutter/hive_flutter.dart';
import 'package:questlog/core/constants.dart';
import 'package:questlog/models/goal.dart';
import 'package:questlog/models/goal_log.dart';
import 'package:questlog/models/user_profile.dart';

class HiveService {
  // ── Init ──────────────────────────────────────────────────────────

  static Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(UserProfileAdapter());
    Hive.registerAdapter(GoalTypeAdapter());
    Hive.registerAdapter(GoalAdapter());
    Hive.registerAdapter(LogTypeAdapter());
    Hive.registerAdapter(GoalLogAdapter());

    await Hive.openBox<UserProfile>(AppConstants.userBox);
    await Hive.openBox<Goal>(AppConstants.goalsBox);
    await Hive.openBox<GoalLog>(AppConstants.logsBox);
    await Hive.openBox(AppConstants.settingsBox);
  }

  // ── User ──────────────────────────────────────────────────────────

  static Box<UserProfile> get _userBox =>
      Hive.box<UserProfile>(AppConstants.userBox);

  static UserProfile? getUser() =>
      _userBox.values.isNotEmpty ? _userBox.values.first : null;

  static Future<void> saveUser(UserProfile user) async {
    if (_userBox.isEmpty) {
      await _userBox.add(user);
    } else {
      await user.save();
    }
  }

  // ── Goals ─────────────────────────────────────────────────────────

  static Box<Goal> get _goalsBox =>
      Hive.box<Goal>(AppConstants.goalsBox);

  static List<Goal> getGoals() => _goalsBox.values.toList();

  static Goal? getGoalByType(GoalType type) {
    try {
      return _goalsBox.values.firstWhere((g) => g.type == type);
    } catch (_) {
      return null;
    }
  }

  static Future<void> saveGoal(Goal goal) async {
    final existing = getGoalByType(goal.type);
    if (existing == null) {
      await _goalsBox.add(goal);
    } else {
      await goal.save();
    }
  }

  // ── Logs ──────────────────────────────────────────────────────────

  static Box<GoalLog> get _logsBox =>
      Hive.box<GoalLog>(AppConstants.logsBox);

  static Future<void> addLog(GoalLog log) async {
    await _logsBox.add(log);
  }

  static List<GoalLog> getLogsForGoalOnDate(String goalId, DateTime date) {
    final dateKey = GoalLog.dateKeyFromDate(date);
    return _logsBox.values
        .where((l) => l.goalId == goalId && l.dateKey == dateKey)
        .toList();
  }

  static List<GoalLog> getLogsForGoal(String goalId) =>
      _logsBox.values.where((l) => l.goalId == goalId).toList();

  // ── Streaks ───────────────────────────────────────────────────────

  /// Quantos dias consecutivos a meta foi concluída até hoje
  static int getStreakForGoal(String goalId) {
    final today = DateTime.now();
    int streak = 0;

    for (int i = 0; i < 365; i++) {
      final day = today.subtract(Duration(days: i));
      final dateKey = GoalLog.dateKeyFromDate(day);
      final completed = _logsBox.values.any(
            (l) => l.goalId == goalId &&
            l.dateKey == dateKey &&
            l.goalCompletedToday,
      );
      if (completed) {
        streak++;
      } else if (i > 0) {
        // dia de hoje pode não ter completado ainda — não quebra streak
        break;
      }
    }
    return streak;
  }

  /// Total de dias distintos em que a meta foi concluída
  static int getTotalCompletedDaysForGoal(String goalId) {
    return _logsBox.values
        .where((l) => l.goalId == goalId && l.goalCompletedToday)
        .map((l) => l.dateKey)
        .toSet()
        .length;
  }

  // ── Settings ──────────────────────────────────────────────────────

  static Box get _settingsBox => Hive.box(AppConstants.settingsBox);

  static bool isOnboardingDone() =>
      _settingsBox.get('onboarding_done', defaultValue: false) as bool;

  static Future<void> setOnboardingDone() async =>
      _settingsBox.put('onboarding_done', true);

  static bool isDarkMode() =>
      _settingsBox.get('dark_mode', defaultValue: true) as bool;

  static Future<void> setDarkMode(bool value) async =>
      _settingsBox.put('dark_mode', value);
}