import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:questlog/core/constants.dart';
import 'package:questlog/models/goal.dart';
import 'package:questlog/models/goal_log.dart';
import 'package:questlog/models/user_profile.dart';
import 'package:questlog/services/hive_service.dart';

const _uuid = Uuid();

// ── User Provider ─────────────────────────────────────────────────────────

class UserNotifier extends Notifier<UserProfile?> {
  @override
  UserProfile? build() => HiveService.getUser();

  Future<void> createUser(UserProfile user) async {
    await HiveService.saveUser(user);
    state = user;
  }

  Future<void> addXp(int amount) async {
    final user = state;
    if (user == null) return;
    user.addXp(amount);
    state = user;
  }

  Future<bool> tryEarnBadge(String badgeId) async {
    final user = state;
    if (user == null || user.hasBadge(badgeId)) return false;
    user.earnBadge(badgeId);
    user.addXp(AppConstants.xpBadgeUnlocked);
    state = user;
    return true;
  }

  void refresh() => state = HiveService.getUser();
}

final userProvider = NotifierProvider<UserNotifier, UserProfile?>(
  UserNotifier.new,
);

// ── Water Provider ────────────────────────────────────────────────────────

class WaterNotifier extends Notifier<WaterState> {
  @override
  WaterState build() => _load();

  WaterState _load() {
    final user = HiveService.getUser();
    final goal = HiveService.getGoalByType(GoalType.water);
    if (user == null || goal == null) return WaterState.empty();

    final logs = HiveService.getLogsForGoalOnDate(goal.id, DateTime.now());
    final consumed = logs
        .where((l) => l.type == LogType.waterGlass)
        .fold(0, (sum, l) => sum + (l.intValue ?? 0));

    return WaterState(
      goal: goal,
      consumedMl: consumed,
      goalMl: goal.dailyWaterGoalMl ?? user.dailyWaterGoalMl,
      glassVolumeMl: goal.glassVolumeMl ?? AppConstants.waterGlassDefault,
      streak: HiveService.getStreakForGoal(goal.id),
      totalCompletedDays: HiveService.getTotalCompletedDaysForGoal(goal.id),
    );
  }

  Future<WaterLogResult> logGlass() async {
    final user = HiveService.getUser();
    Goal? goal = HiveService.getGoalByType(GoalType.water);

    if (goal == null) {
      goal = Goal(id: _uuid.v4(), type: GoalType.water);
      await HiveService.saveGoal(goal);
    }

    final logs = HiveService.getLogsForGoalOnDate(goal.id, DateTime.now());
    final consumed = logs
        .where((l) => l.type == LogType.waterGlass)
        .fold(0, (sum, l) => sum + (l.intValue ?? 0));

    final goalMl = goal.dailyWaterGoalMl ?? user!.dailyWaterGoalMl;
    final glassVol = goal.glassVolumeMl ?? AppConstants.waterGlassDefault;
    final newConsumed = consumed + glassVol;
    final justCompleted = consumed < goalMl && newConsumed >= goalMl;

    await HiveService.addLog(GoalLog(
      id: _uuid.v4(),
      goalId: goal.id,
      type: LogType.waterGlass,
      intValue: glassVol,
      goalCompletedToday: justCompleted,
    ));

    int xpEarned = 0;
    final List<String> badgesEarned = [];

    if (justCompleted) {
      xpEarned += AppConstants.xpWaterComplete;
      await ref.read(userProvider.notifier).addXp(xpEarned);

      final streak = HiveService.getStreakForGoal(goal.id);
      final total = HiveService.getTotalCompletedDaysForGoal(goal.id);

      if (streak >= 7) {
        final earned = await ref
            .read(userProvider.notifier)
            .tryEarnBadge(AppConstants.badgeWaterWeek);
        if (earned) badgesEarned.add(AppConstants.badgeWaterWeek);
      }
      if (streak >= 30) {
        final earned = await ref
            .read(userProvider.notifier)
            .tryEarnBadge(AppConstants.badgeWaterMonth);
        if (earned) badgesEarned.add(AppConstants.badgeWaterMonth);
      }
      if (total >= 100) {
        final earned = await ref
            .read(userProvider.notifier)
            .tryEarnBadge(AppConstants.badgeWater100);
        if (earned) badgesEarned.add(AppConstants.badgeWater100);
      }
      if (streak > 0 && streak % 7 == 0) {
        xpEarned += AppConstants.xpStreakWeekly;
        await ref
            .read(userProvider.notifier)
            .addXp(AppConstants.xpStreakWeekly);
      }
    }

    state = _load();
    return WaterLogResult(
      newConsumedMl: newConsumed,
      goalMl: goalMl,
      justCompleted: justCompleted,
      xpEarned: xpEarned,
      badgesEarned: badgesEarned,
    );
  }

  void refresh() => state = _load();
}

final waterProvider = NotifierProvider<WaterNotifier, WaterState>(
  WaterNotifier.new,
);

// ── Water State ───────────────────────────────────────────────────────────

class WaterState {
  final Goal? goal;
  final int consumedMl;
  final int goalMl;
  final int glassVolumeMl;
  final int streak;
  final int totalCompletedDays;

  const WaterState({
    required this.goal,
    required this.consumedMl,
    required this.goalMl,
    required this.glassVolumeMl,
    required this.streak,
    required this.totalCompletedDays,
  });

  factory WaterState.empty() => const WaterState(
    goal: null,
    consumedMl: 0,
    goalMl: 2000,
    glassVolumeMl: 200,
    streak: 0,
    totalCompletedDays: 0,
  );

  double get progress =>
      goalMl > 0 ? (consumedMl / goalMl).clamp(0.0, 1.0) : 0;
  bool get isCompleted => consumedMl >= goalMl;
  int get remainingMl => (goalMl - consumedMl).clamp(0, goalMl);
}

class WaterLogResult {
  final int newConsumedMl;
  final int goalMl;
  final bool justCompleted;
  final int xpEarned;
  final List<String> badgesEarned;

  const WaterLogResult({
    required this.newConsumedMl,
    required this.goalMl,
    required this.justCompleted,
    required this.xpEarned,
    required this.badgesEarned,
  });
}

// ── WakeUp Provider ───────────────────────────────────────────────────────

class WakeUpNotifier extends Notifier<WakeUpState> {
  @override
  WakeUpState build() => _load();

  WakeUpState _load() {
    final goal = HiveService.getGoalByType(GoalType.wakeup);
    if (goal == null) return WakeUpState.empty();

    final logs = HiveService.getLogsForGoalOnDate(goal.id, DateTime.now());
    final checkedToday = logs.any((l) => l.type == LogType.wakeUpChecked);

    return WakeUpState(
      goal: goal,
      checkedToday: checkedToday,
      streak: HiveService.getStreakForGoal(goal.id),
    );
  }

  Future<WakeUpLogResult> checkIn() async {
    final goal = HiveService.getGoalByType(GoalType.wakeup);
    if (goal == null) return const WakeUpLogResult(xpEarned: 0, badgesEarned: []);

    final logs = HiveService.getLogsForGoalOnDate(goal.id, DateTime.now());
    if (logs.any((l) => l.type == LogType.wakeUpChecked)) {
      return const WakeUpLogResult(xpEarned: 0, badgesEarned: [], alreadyDone: true);
    }

    await HiveService.addLog(GoalLog(
      id: _uuid.v4(),
      goalId: goal.id,
      type: LogType.wakeUpChecked,
      goalCompletedToday: true,
    ));

    int xpEarned = AppConstants.xpWakeUpComplete;
    await ref.read(userProvider.notifier).addXp(xpEarned);

    final streak = HiveService.getStreakForGoal(goal.id);
    final List<String> badgesEarned = [];

    if (streak >= 7) {
      final earned = await ref
          .read(userProvider.notifier)
          .tryEarnBadge(AppConstants.badgeWakeWeek);
      if (earned) badgesEarned.add(AppConstants.badgeWakeWeek);
    }
    if (streak >= 30) {
      final earned = await ref
          .read(userProvider.notifier)
          .tryEarnBadge(AppConstants.badgeWakeMonth);
      if (earned) badgesEarned.add(AppConstants.badgeWakeMonth);
    }
    if (streak >= 90) {
      final earned = await ref
          .read(userProvider.notifier)
          .tryEarnBadge(AppConstants.badgeWake90);
      if (earned) badgesEarned.add(AppConstants.badgeWake90);
    }
    if (streak > 0 && streak % 7 == 0) {
      xpEarned += AppConstants.xpStreakWeekly;
      await ref.read(userProvider.notifier).addXp(AppConstants.xpStreakWeekly);
    }

    state = _load();
    return WakeUpLogResult(xpEarned: xpEarned, badgesEarned: badgesEarned);
  }

  Future<void> configure({
    required String targetTime,
    required bool alarmEnabled,
  }) async {
    Goal? goal = HiveService.getGoalByType(GoalType.wakeup);
    goal ??= Goal(id: _uuid.v4(), type: GoalType.wakeup);
    goal.targetWakeUpTime = targetTime;
    goal.alarmEnabled = alarmEnabled;
    await HiveService.saveGoal(goal);
    state = _load();
  }

  void refresh() => state = _load();
}

final wakeUpProvider = NotifierProvider<WakeUpNotifier, WakeUpState>(
  WakeUpNotifier.new,
);

// ── WakeUp State ──────────────────────────────────────────────────────────

class WakeUpState {
  final Goal? goal;
  final bool checkedToday;
  final int streak;

  const WakeUpState({
    required this.goal,
    required this.checkedToday,
    required this.streak,
  });

  factory WakeUpState.empty() => const WakeUpState(
    goal: null,
    checkedToday: false,
    streak: 0,
  );
}

class WakeUpLogResult {
  final int xpEarned;
  final List<String> badgesEarned;
  final bool alreadyDone;

  const WakeUpLogResult({
    required this.xpEarned,
    required this.badgesEarned,
    this.alreadyDone = false,
  });
}

// ── Reading Provider ──────────────────────────────────────────────────────

class ReadingNotifier extends Notifier<ReadingState> {
  @override
  ReadingState build() => _load();

  ReadingState _load() {
    final goal = HiveService.getGoalByType(GoalType.reading);
    if (goal == null) return ReadingState.empty();

    final logs = HiveService.getLogsForGoalOnDate(goal.id, DateTime.now());
    final pagesReadToday = logs
        .where((l) => l.type == LogType.readingPages)
        .fold(0, (sum, l) => sum + (l.intValue ?? 0));

    return ReadingState(
      goal: goal,
      pagesReadToday: pagesReadToday,
      streak: HiveService.getStreakForGoal(goal.id),
    );
  }

  Future<ReadingLogResult> logPages(int pages) async {
    Goal? goal = HiveService.getGoalByType(GoalType.reading);
    if (goal == null) {
      goal = Goal(id: _uuid.v4(), type: GoalType.reading);
      await HiveService.saveGoal(goal);
    }

    final logs = HiveService.getLogsForGoalOnDate(goal.id, DateTime.now());
    final pagesAlready = logs
        .where((l) => l.type == LogType.readingPages)
        .fold(0, (sum, l) => sum + (l.intValue ?? 0));

    final dailyGoal = goal.dailyReadingGoalPages ?? 20;
    final newTotal = pagesAlready + pages;
    final justCompleted = pagesAlready < dailyGoal && newTotal >= dailyGoal;

    // Atualiza página atual do livro
    if (goal.currentBookTotalPages != null) {
      goal.currentBookCurrentPage =
          ((goal.currentBookCurrentPage ?? 0) + pages)
              .clamp(0, goal.currentBookTotalPages!);
      await goal.save();
    }

    final bookFinished = goal.currentBookTotalPages != null &&
        (goal.currentBookCurrentPage ?? 0) >= goal.currentBookTotalPages!;

    await HiveService.addLog(GoalLog(
      id: _uuid.v4(),
      goalId: goal.id,
      type: LogType.readingPages,
      intValue: pages,
      goalCompletedToday: justCompleted,
    ));

    int xpEarned = 0;
    final List<String> badgesEarned = [];

    if (justCompleted) {
      xpEarned += AppConstants.xpReadingComplete;
      await ref.read(userProvider.notifier).addXp(xpEarned);
    }

    if (bookFinished) {
      xpEarned += AppConstants.xpBookFinished;
      await ref.read(userProvider.notifier).addXp(AppConstants.xpBookFinished);
      goal.totalBooksFinished++;
      await goal.save();

      await HiveService.addLog(GoalLog(
        id: _uuid.v4(),
        goalId: goal.id,
        type: LogType.bookFinished,
        stringValue: goal.currentBookTitle,
      ));

      if (goal.totalBooksFinished >= 1) {
        final earned = await ref
            .read(userProvider.notifier)
            .tryEarnBadge(AppConstants.badgeBook1);
        if (earned) badgesEarned.add(AppConstants.badgeBook1);
      }
      if (goal.totalBooksFinished >= 5) {
        final earned = await ref
            .read(userProvider.notifier)
            .tryEarnBadge(AppConstants.badgeBook5);
        if (earned) badgesEarned.add(AppConstants.badgeBook5);
      }
    }

    final total = HiveService.getTotalCompletedDaysForGoal(goal.id);
    if (total >= 30) {
      final earned = await ref
          .read(userProvider.notifier)
          .tryEarnBadge(AppConstants.badgeReadMonth);
      if (earned) badgesEarned.add(AppConstants.badgeReadMonth);
    }

    final streak = HiveService.getStreakForGoal(goal.id);
    if (streak > 0 && streak % 7 == 0) {
      xpEarned += AppConstants.xpStreakWeekly;
      await ref.read(userProvider.notifier).addXp(AppConstants.xpStreakWeekly);
    }

    state = _load();
    return ReadingLogResult(
      xpEarned: xpEarned,
      badgesEarned: badgesEarned,
      bookFinished: bookFinished,
      bookTitle: goal.currentBookTitle,
    );
  }

  Future<void> configureBook({
    required String title,
    required int totalPages,
    int startPage = 0,
    int? dailyGoalPages,
  }) async {
    Goal? goal = HiveService.getGoalByType(GoalType.reading);
    goal ??= Goal(id: _uuid.v4(), type: GoalType.reading);
    goal.currentBookTitle = title;
    goal.currentBookTotalPages = totalPages;
    goal.currentBookCurrentPage = startPage;
    if (dailyGoalPages != null) goal.dailyReadingGoalPages = dailyGoalPages;
    await HiveService.saveGoal(goal);
    state = _load();
  }

  void refresh() => state = _load();
}

final readingProvider = NotifierProvider<ReadingNotifier, ReadingState>(
  ReadingNotifier.new,
);

// ── Reading State ─────────────────────────────────────────────────────────

class ReadingState {
  final Goal? goal;
  final int pagesReadToday;
  final int streak;

  const ReadingState({
    required this.goal,
    required this.pagesReadToday,
    required this.streak,
  });

  factory ReadingState.empty() => const ReadingState(
    goal: null,
    pagesReadToday: 0,
    streak: 0,
  );

  int get dailyGoal => goal?.dailyReadingGoalPages ?? 20;
  bool get isTodayCompleted => pagesReadToday >= dailyGoal;
  double get todayProgress =>
      dailyGoal > 0 ? (pagesReadToday / dailyGoal).clamp(0.0, 1.0) : 0;
  double get bookProgress {
    final g = goal;
    if (g == null || g.currentBookTotalPages == null) return 0;
    return ((g.currentBookCurrentPage ?? 0) / g.currentBookTotalPages!)
        .clamp(0.0, 1.0);
  }
}

class ReadingLogResult {
  final int xpEarned;
  final List<String> badgesEarned;
  final bool bookFinished;
  final String? bookTitle;

  const ReadingLogResult({
    required this.xpEarned,
    required this.badgesEarned,
    this.bookFinished = false,
    this.bookTitle,
  });
}