import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:questlog/core/theme.dart';
import 'package:questlog/models/badge.dart';
import 'package:questlog/providers/goals_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final water = ref.watch(waterProvider);
    final wakeUp = ref.watch(wakeUpProvider);
    final reading = ref.watch(readingProvider);

    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── App Bar ──────────────────────────────────────────────
          SliverAppBar(
            floating: true,
            backgroundColor: AppTheme.bg,
            title: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _greeting(),
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white54,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Text(
                      user.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => context.go('/profile'),
                  child: _AvatarWidget(
                    name: user.name,
                    level: user.level,
                  ),
                ),
              ],
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // ── XP Bar ───────────────────────────────────────
                _XpBar(user: user),
                const SizedBox(height: 28),

                // ── Título ───────────────────────────────────────
                const Text(
                  'TODAY\'S QUESTS',
                  style: TextStyle(
                    color: Colors.white38,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 12),

                // ── Cards ────────────────────────────────────────
                _WaterCard(state: water)
                    .animate()
                    .fadeIn(delay: 100.ms)
                    .slideY(begin: 0.15),
                const SizedBox(height: 12),
                _WakeUpCard(state: wakeUp)
                    .animate()
                    .fadeIn(delay: 200.ms)
                    .slideY(begin: 0.15),
                const SizedBox(height: 12),
                _ReadingCard(state: reading)
                    .animate()
                    .fadeIn(delay: 300.ms)
                    .slideY(begin: 0.15),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning,';
    if (h < 18) return 'Good afternoon,';
    return 'Good evening,';
  }
}

// ── Avatar ────────────────────────────────────────────────────────────────

class _AvatarWidget extends StatelessWidget {
  final String name;
  final int level;
  const _AvatarWidget({required this.name, required this.level});

  @override
  Widget build(BuildContext context) {
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
    return Stack(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppTheme.primary.withValues(alpha: 0.2),
            border: Border.all(color: AppTheme.primary, width: 1.5),
          ),
          child: Center(
            child: Text(
              initial,
              style: const TextStyle(
                color: AppTheme.primary,
                fontWeight: FontWeight.w700,
                fontSize: 17,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            decoration: BoxDecoration(
              color: AppTheme.xpGold,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppTheme.bg, width: 1.5),
            ),
            child: Text(
              '$level',
              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── XP Bar ────────────────────────────────────────────────────────────────

class _XpBar extends StatelessWidget {
  final dynamic user;
  const _XpBar({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            AppTheme.primary.withValues(alpha: 0.15),
            AppTheme.wakeUp.withValues(alpha: 0.08),
          ],
        ),
        border: Border.all(
            color: AppTheme.primary.withValues(alpha: 0.2), width: 0.5),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppTheme.xpGold.withValues(alpha: 0.2),
                      border: Border.all(
                          color: AppTheme.xpGold.withValues(alpha: 0.4)),
                    ),
                    child: Text(
                      'LVL ${user.level}',
                      style: const TextStyle(
                        color: AppTheme.xpGold,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${user.xpInCurrentLevel} / ${user.xpForNextLevel} XP',
                    style: const TextStyle(
                        color: Colors.white54, fontSize: 12),
                  ),
                ],
              ),
              Text(
                '${user.totalXp} total',
                style: const TextStyle(
                    color: Colors.white24, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(height: 10),
          LinearPercentIndicator(
            lineHeight: 6,
            percent: user.levelProgress.clamp(0.0, 1.0),
            backgroundColor: Colors.white.withValues(alpha: 0.06),
            linearGradient: const LinearGradient(
              colors: [AppTheme.primary, AppTheme.wakeUp],
            ),
            barRadius: const Radius.circular(3),
            padding: EdgeInsets.zero,
          ),
        ],
      ),
    );
  }
}

// ── Goal Card Base ────────────────────────────────────────────────────────

class _GoalCard extends StatelessWidget {
  final Color color;
  final String icon;
  final String title;
  final bool isCompleted;
  final Widget child;
  final VoidCallback? onSettings;

  const _GoalCard({
    required this.color,
    required this.icon,
    required this.title,
    required this.isCompleted,
    required this.child,
    this.onSettings,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppTheme.surfaceCard,
        border: Border.all(
          color: isCompleted
              ? color.withValues(alpha: 0.5)
              : Colors.white.withValues(alpha: 0.06),
          width: isCompleted ? 1 : 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: color.withValues(alpha: 0.15),
                ),
                child: Center(
                  child: Text(icon,
                      style: const TextStyle(fontSize: 18)),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              if (isCompleted)
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: color.withValues(alpha: 0.2),
                  ),
                  child: Text(
                    '✓ Done',
                    style: TextStyle(
                      color: color,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              if (onSettings != null) ...[
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: onSettings,
                  child: const Icon(Icons.tune,
                      color: Colors.white24, size: 18),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

// ── Progress Bar ──────────────────────────────────────────────────────────

class _ProgressBar extends StatelessWidget {
  final double progress;
  final Color color;
  const _ProgressBar({required this.progress, required this.color});

  @override
  Widget build(BuildContext context) {
    return LinearPercentIndicator(
      lineHeight: 6,
      percent: progress,
      backgroundColor: Colors.white.withValues(alpha: 0.08),
      progressColor: color,
      barRadius: const Radius.circular(3),
      padding: EdgeInsets.zero,
    );
  }
}

// ── Log Button ────────────────────────────────────────────────────────────

class _LogButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _LogButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: color.withValues(alpha: 0.12),
          border:
          Border.all(color: color.withValues(alpha: 0.3), width: 0.5),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

// ── Streak Chip ───────────────────────────────────────────────────────────

class _StreakChip extends StatelessWidget {
  final int streak;
  const _StreakChip({required this.streak});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppTheme.xpGold.withValues(alpha: 0.1),
        border: Border.all(
            color: AppTheme.xpGold.withValues(alpha: 0.3), width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🔥', style: TextStyle(fontSize: 13)),
          const SizedBox(width: 4),
          Text(
            '$streak',
            style: const TextStyle(
              color: AppTheme.xpGold,
              fontWeight: FontWeight.w800,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Water Card ────────────────────────────────────────────────────────────

class _WaterCard extends ConsumerWidget {
  final WaterState state;
  const _WaterCard({required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _GoalCard(
      color: AppTheme.water,
      icon: '💧',
      title: 'Water',
      isCompleted: state.isCompleted,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${state.consumedMl}',
                style: TextStyle(
                  color: AppTheme.water,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  '/ ${state.goalMl} ml',
                  style: const TextStyle(
                      color: Colors.white38, fontSize: 14),
                ),
              ),
              const Spacer(),
              _StreakChip(streak: state.streak),
            ],
          ),
          const SizedBox(height: 10),
          _ProgressBar(progress: state.progress, color: AppTheme.water),
          const SizedBox(height: 12),
          _LogButton(
            label: '+ ${state.glassVolumeMl} ml',
            color: AppTheme.water,
            onTap: () async {
              final result =
              await ref.read(waterProvider.notifier).logGlass();
              if (context.mounted && result.justCompleted) {
                _showXpDialog(context, result.xpEarned,
                    result.badgesEarned);
              }
            },
          ),
          if (!state.isCompleted) ...[
            const SizedBox(height: 6),
            Text(
              '${state.remainingMl} ml remaining — '
                  '${(state.remainingMl / state.glassVolumeMl).ceil()} glasses',
              style: const TextStyle(
                  color: Colors.white24, fontSize: 11),
            ),
          ],
        ],
      ),
    );
  }
}

// ── WakeUp Card ───────────────────────────────────────────────────────────

class _WakeUpCard extends ConsumerWidget {
  final WakeUpState state;
  const _WakeUpCard({required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _GoalCard(
      color: AppTheme.wakeUp,
      icon: '⏰',
      title: 'Wake up early',
      isCompleted: state.checkedToday,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                state.goal?.targetWakeUpTime ?? '--:--',
                style: TextStyle(
                  color: AppTheme.wakeUp,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1,
                ),
              ),
              const Spacer(),
              _StreakChip(streak: state.streak),
            ],
          ),
          const SizedBox(height: 12),
          if (state.checkedToday)
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppTheme.wakeUp.withValues(alpha: 0.15),
                border: Border.all(
                    color: AppTheme.wakeUp.withValues(alpha: 0.3)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle,
                      color: AppTheme.wakeUp, size: 16),
                  SizedBox(width: 6),
                  Text(
                    'Checked in! +50 XP',
                    style: TextStyle(
                      color: AppTheme.wakeUp,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            )
          else
            _LogButton(
              label: "I'm awake! ✓",
              color: AppTheme.wakeUp,
              onTap: () async {
                final result =
                await ref.read(wakeUpProvider.notifier).checkIn();
                if (context.mounted && !result.alreadyDone) {
                  _showXpDialog(context, result.xpEarned,
                      result.badgesEarned);
                }
              },
            ),
        ],
      ),
    );
  }
}

// ── Reading Card ──────────────────────────────────────────────────────────

class _ReadingCard extends ConsumerWidget {
  final ReadingState state;
  const _ReadingCard({required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _GoalCard(
      color: AppTheme.reading,
      icon: '📚',
      title: 'Reading',
      isCompleted: state.isTodayCompleted,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (state.goal?.currentBookTitle != null)
            Text(
              state.goal!.currentBookTitle!,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          const SizedBox(height: 6),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${state.pagesReadToday}',
                style: TextStyle(
                  color: AppTheme.reading,
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  '/ ${state.dailyGoal} pages today',
                  style: const TextStyle(
                      color: Colors.white38, fontSize: 14),
                ),
              ),
              const Spacer(),
              _StreakChip(streak: state.streak),
            ],
          ),
          const SizedBox(height: 10),
          _ProgressBar(
              progress: state.todayProgress, color: AppTheme.reading),
          if (state.goal?.currentBookTotalPages != null) ...[
            const SizedBox(height: 6),
            _ProgressBar(
                progress: state.bookProgress,
                color: AppTheme.reading.withValues(alpha: 0.35)),
            const SizedBox(height: 2),
            Text(
              'Book: page ${state.goal!.currentBookCurrentPage}'
                  ' of ${state.goal!.currentBookTotalPages}',
              style: const TextStyle(
                  color: Colors.white24, fontSize: 10),
            ),
          ],
          const SizedBox(height: 12),
          _LogButton(
            label: '+ Log pages',
            color: AppTheme.reading,
            onTap: () => _showPagesDialog(context, ref),
          ),
        ],
      ),
    );
  }

  void _showPagesDialog(BuildContext context, WidgetRef ref) {
    int pages = 10;
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) => AlertDialog(
          backgroundColor: AppTheme.surfaceCard,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
          title: const Text('How many pages?',
              style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$pages',
                style: TextStyle(
                  fontSize: 52,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.reading,
                ),
              ),
              Slider(
                value: pages.toDouble(),
                min: 1,
                max: 150,
                divisions: 149,
                activeColor: AppTheme.reading,
                inactiveColor: Colors.white12,
                onChanged: (v) =>
                    setState(() => pages = v.round()),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel',
                  style: TextStyle(color: Colors.white38)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.reading),
              onPressed: () async {
                Navigator.pop(ctx);
                final result = await ref
                    .read(readingProvider.notifier)
                    .logPages(pages);
                if (context.mounted) {
                  if (result.bookFinished) {
                    _showBookFinishedDialog(
                        context, result.bookTitle);
                  } else if (result.xpEarned > 0) {
                    _showXpDialog(context, result.xpEarned,
                        result.badgesEarned);
                  }
                }
              },
              child: const Text('Log'),
            ),
          ],
        ),
      ),
    );
  }

  void _showBookFinishedDialog(BuildContext context, String? title) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surfaceCard,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title: const Text('📚 Book finished!',
            style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null)
              Text('"$title"',
                  style: TextStyle(
                      color: AppTheme.reading,
                      fontStyle: FontStyle.italic,
                      fontSize: 16)),
            const SizedBox(height: 12),
            const Text('+200 XP',
                style: TextStyle(
                    color: AppTheme.xpGold,
                    fontSize: 32,
                    fontWeight: FontWeight.w800)),
            const SizedBox(height: 8),
            const Text(
                '"One does not simply stop reading"',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white38,
                    fontSize: 12,
                    fontStyle: FontStyle.italic)),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Epic! 🎉'),
          ),
        ],
      ),
    );
  }
}

// ── XP Dialog ─────────────────────────────────────────────────────────────

void _showXpDialog(
    BuildContext context, int xp, List<String> badges) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (ctx) => AlertDialog(
      backgroundColor: AppTheme.surfaceCard,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🎉', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 8),
          const Text('Quest complete!',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 20)),
          const SizedBox(height: 8),
          Text('+$xp XP',
              style: const TextStyle(
                  color: AppTheme.xpGold,
                  fontWeight: FontWeight.w800,
                  fontSize: 36)),
          if (badges.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Divider(color: Colors.white12),
            const SizedBox(height: 8),
            const Text('🏆 Badge unlocked!',
                style: TextStyle(
                    color: AppTheme.xpGold,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            ...badges.map((id) {
              final b = BadgeRegistry.findById(id);
              return Text(
                b?.name ?? id,
                style: const TextStyle(
                    color: Colors.white70, fontSize: 13),
              );
            }),
          ],
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('⚔️  Let\'s go!'),
        ),
      ],
    ),
  );
}