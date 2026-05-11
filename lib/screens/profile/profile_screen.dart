import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:questlog/core/theme.dart';
import 'package:questlog/models/badge.dart';
import 'package:questlog/providers/goals_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    if (user == null) return const SizedBox();

    final water = ref.watch(waterProvider);
    final wakeUp = ref.watch(wakeUpProvider);
    final reading = ref.watch(readingProvider);

    final earnedIds = user.earnedBadgeIds;
    final allBadges = BadgeRegistry.all;
    final earned = allBadges.where((b) => earnedIds.contains(b.id)).toList();
    final locked = allBadges.where((b) => !earnedIds.contains(b.id)).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ───────────────────────────────────────────
            _ProfileHeader(user: user)
                .animate()
                .fadeIn()
                .slideY(begin: -0.1),
            const SizedBox(height: 20),

            // ── Stats ─────────────────────────────────────────────
            _StatsRow(
              badges: earnedIds.length,
              days: DateTime.now().difference(user.createdAt).inDays + 1,
              level: user.level,
            ).animate().fadeIn(delay: 100.ms),
            const SizedBox(height: 28),

            // ── Streaks ───────────────────────────────────────────
            _SectionTitle(
              title: 'Streaks',
              subtitle: 'consecutive days',
            ),
            const SizedBox(height: 12),
            _StreaksRow(
              waterStreak: water.streak,
              wakeUpStreak: wakeUp.streak,
              readingStreak: reading.streak,
            ).animate().fadeIn(delay: 150.ms),
            const SizedBox(height: 28),

            // ── Badges earned ─────────────────────────────────────
            _SectionTitle(
              title: 'Badges',
              subtitle: '${earnedIds.length} / ${allBadges.length}',
            ),
            const SizedBox(height: 12),
            if (earned.isEmpty)
              _EmptyBadges()
            else
              _BadgesGrid(badges: earned, isEarned: true)
                  .animate()
                  .fadeIn(delay: 200.ms),

            const SizedBox(height: 24),

            // ── Badges locked ─────────────────────────────────────
            _SectionTitle(
              title: 'Coming up',
              subtitle: 'keep going',
            ),
            const SizedBox(height: 12),
            _BadgesGrid(badges: locked, isEarned: false)
                .animate()
                .fadeIn(delay: 300.ms),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// ── Profile Header ────────────────────────────────────────────────────────

class _ProfileHeader extends StatelessWidget {
  final dynamic user;
  const _ProfileHeader({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primary.withValues(alpha: 0.2),
            AppTheme.wakeUp.withValues(alpha: 0.08),
          ],
        ),
        border: Border.all(
            color: AppTheme.primary.withValues(alpha: 0.2), width: 0.5),
      ),
      child: Row(
        children: [
          // Avatar
          Stack(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.primary.withValues(alpha: 0.2),
                  border: Border.all(color: AppTheme.primary, width: 2),
                ),
                child: Center(
                  child: Text(
                    user.name.isNotEmpty
                        ? user.name[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                      color: AppTheme.primary,
                      fontWeight: FontWeight.w800,
                      fontSize: 26,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.xpGold,
                    borderRadius: BorderRadius.circular(8),
                    border:
                    Border.all(color: AppTheme.bg, width: 1.5),
                  ),
                  child: Text(
                    'LV ${user.level}',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${user.totalXp} XP total',
                  style: const TextStyle(
                      color: Colors.white54, fontSize: 13),
                ),
                const SizedBox(height: 10),
                LinearPercentIndicator(
                  lineHeight: 6,
                  percent: user.levelProgress.clamp(0.0, 1.0),
                  backgroundColor:
                  Colors.white.withValues(alpha: 0.08),
                  linearGradient: const LinearGradient(
                    colors: [AppTheme.primary, AppTheme.wakeUp],
                  ),
                  barRadius: const Radius.circular(3),
                  padding: EdgeInsets.zero,
                ),
                const SizedBox(height: 4),
                Text(
                  '${user.xpInCurrentLevel} / ${user.xpForNextLevel} XP to level ${user.level + 1}',
                  style: const TextStyle(
                      color: Colors.white30, fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Stats Row ─────────────────────────────────────────────────────────────

class _StatsRow extends StatelessWidget {
  final int badges;
  final int days;
  final int level;
  const _StatsRow(
      {required this.badges,
        required this.days,
        required this.level});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatChip(icon: '🏆', label: 'Badges', value: '$badges'),
        const SizedBox(width: 10),
        _StatChip(icon: '📅', label: 'Days', value: '$days'),
        const SizedBox(width: 10),
        _StatChip(icon: '⚔️', label: 'Level', value: '$level'),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final String icon;
  final String label;
  final String value;
  const _StatChip(
      {required this.icon,
        required this.label,
        required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: AppTheme.surfaceCard,
          border: Border.all(
              color: Colors.white.withValues(alpha: 0.06),
              width: 0.5),
        ),
        child: Column(
          children: [
            Text(icon, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 4),
            Text(value,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 20)),
            Text(label,
                style: const TextStyle(
                    color: Colors.white38, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}

// ── Streaks Row ───────────────────────────────────────────────────────────

class _StreaksRow extends StatelessWidget {
  final int waterStreak;
  final int wakeUpStreak;
  final int readingStreak;
  const _StreaksRow({
    required this.waterStreak,
    required this.wakeUpStreak,
    required this.readingStreak,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StreakChip(
            icon: '💧', value: waterStreak, color: AppTheme.water),
        const SizedBox(width: 10),
        _StreakChip(
            icon: '⏰',
            value: wakeUpStreak,
            color: AppTheme.wakeUp),
        const SizedBox(width: 10),
        _StreakChip(
            icon: '📚',
            value: readingStreak,
            color: AppTheme.reading),
      ],
    );
  }
}

class _StreakChip extends StatelessWidget {
  final String icon;
  final int value;
  final Color color;
  const _StreakChip(
      {required this.icon,
        required this.value,
        required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: AppTheme.surfaceCard,
          border: Border.all(
              color: value > 0
                  ? color.withValues(alpha: 0.3)
                  : Colors.white.withValues(alpha: 0.06),
              width: 0.5),
        ),
        child: Column(
          children: [
            Text(icon, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (value > 0)
                  const Text('🔥',
                      style: TextStyle(fontSize: 12)),
                const SizedBox(width: 2),
                Text(
                  '$value',
                  style: TextStyle(
                    color: value > 0 ? color : Colors.white38,
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
            Text('days',
                style: const TextStyle(
                    color: Colors.white38, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}

// ── Section Title ─────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;
  const _SectionTitle({required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 16)),
        if (subtitle != null)
          Text(subtitle!,
              style: const TextStyle(
                  color: Colors.white38, fontSize: 12)),
      ],
    );
  }
}

// ── Badges Grid ───────────────────────────────────────────────────────────

class _BadgesGrid extends StatelessWidget {
  final List<BadgeDefinition> badges;
  final bool isEarned;
  const _BadgesGrid({required this.badges, required this.isEarned});

  @override
  Widget build(BuildContext context) {
    if (badges.isEmpty) return const SizedBox();
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.75,
      ),
      itemCount: badges.length,
      itemBuilder: (_, i) =>
          _BadgeCard(badge: badges[i], isEarned: isEarned),
    );
  }
}

class _BadgeCard extends StatelessWidget {
  final BadgeDefinition badge;
  final bool isEarned;
  const _BadgeCard({required this.badge, required this.isEarned});

  String _iconForGoal(String type) {
    switch (type) {
      case 'water':   return '💧';
      case 'wakeup':  return '⏰';
      case 'reading': return '📚';
      default:        return '🏆';
    }
  }

  String _tierLabel(BadgeTier tier) {
    switch (tier) {
      case BadgeTier.bronze:    return 'BRONZE';
      case BadgeTier.silver:    return 'SILVER';
      case BadgeTier.gold:      return 'GOLD';
      case BadgeTier.legendary: return 'LEGEND';
    }
  }

  @override
  Widget build(BuildContext context) {
    final tierColor = BadgeRegistry.tierColor(badge.tier);
    return GestureDetector(
      onTap: () => _showDetail(context),
      child: AnimatedOpacity(
        opacity: isEarned ? 1.0 : 0.35,
        duration: const Duration(milliseconds: 300),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: AppTheme.surfaceCard,
            border: Border.all(
              color: isEarned
                  ? tierColor.withValues(alpha: 0.5)
                  : Colors.white.withValues(alpha: 0.06),
              width: isEarned ? 1 : 0.5,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Ícone
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isEarned
                      ? tierColor.withValues(alpha: 0.15)
                      : Colors.white.withValues(alpha: 0.04),
                  border: Border.all(
                    color: isEarned
                        ? tierColor.withValues(alpha: 0.4)
                        : Colors.white12,
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    _iconForGoal(badge.goalType),
                    style: const TextStyle(fontSize: 22),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Nome
              Text(
                badge.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isEarned ? Colors.white : Colors.white38,
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 4),

              // Tier
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: tierColor
                      .withValues(alpha: isEarned ? 0.2 : 0.05),
                ),
                child: Text(
                  _tierLabel(badge.tier),
                  style: TextStyle(
                    fontSize: 8,
                    color: isEarned ? tierColor : Colors.white24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDetail(BuildContext context) {
    final tierColor = BadgeRegistry.tierColor(badge.tier);
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceCard,
      shape: const RoundedRectangleBorder(
        borderRadius:
        BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(28, 16, 28, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                color: Colors.white12,
              ),
            ),
            const SizedBox(height: 24),

            Text(
              _iconForGoal(badge.goalType),
              style: const TextStyle(fontSize: 52),
            ),
            const SizedBox(height: 12),

            Text(
              badge.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),

            Text(
              badge.quote,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppTheme.primary,
                fontStyle: FontStyle.italic,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 12),

            Text(
              badge.description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: Colors.white54, fontSize: 13),
            ),

            if (isEarned) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: tierColor.withValues(alpha: 0.15),
                ),
                child: Text(
                  '✓  Unlocked!',
                  style: TextStyle(
                    color: tierColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

// ── Empty Badges ──────────────────────────────────────────────────────────

class _EmptyBadges extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: AppTheme.surfaceCard,
        border: Border.all(
            color: Colors.white.withValues(alpha: 0.06), width: 0.5),
      ),
      child: const Column(
        children: [
          Text('🔒', style: TextStyle(fontSize: 36)),
          SizedBox(height: 8),
          Text(
            'No badges yet.',
            style:
            TextStyle(color: Colors.white54, fontSize: 14),
          ),
          SizedBox(height: 4),
          Text(
            '"Every legend starts somewhere."',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white24,
              fontSize: 11,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}