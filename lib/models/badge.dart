import 'package:flutter/material.dart';
import 'package:questlog/core/constants.dart';

enum BadgeTier { bronze, silver, gold, legendary }

class BadgeDefinition {
  final String id;
  final String name;
  final String quote;
  final String description;
  final String goalType;
  final String imagePath;
  final BadgeTier tier;

  const BadgeDefinition({
    required this.id,
    required this.name,
    required this.quote,
    required this.description,
    required this.goalType,
    required this.imagePath,
    required this.tier,
  });
}

class BadgeRegistry {
  static const List<BadgeDefinition> all = [

    // ── ÁGUA ────────────────────────────────────────────────────────
    BadgeDefinition(
      id: AppConstants.badgeWaterWeek,
      name: 'Hydration Wizard',
      quote: '"You shall not thirst"',
      description: 'Complete the water goal for 7 days in a row',
      goalType: 'water',
      imagePath: 'assets/badges/water_week.png',
      tier: BadgeTier.bronze,
    ),
    BadgeDefinition(
      id: AppConstants.badgeWaterMonth,
      name: 'Precious Hydration',
      quote: '"My precioussss... water bottle"',
      description: 'Complete the water goal for 30 days in a row',
      goalType: 'water',
      imagePath: 'assets/badges/water_month.png',
      tier: BadgeTier.silver,
    ),
    BadgeDefinition(
      id: AppConstants.badgeWater100,
      name: 'Not All Who Wander Are Dehydrated',
      quote: '"Aragorn always carried a canteen"',
      description: 'Complete the water goal 100 total days',
      goalType: 'water',
      imagePath: 'assets/badges/water_100.png',
      tier: BadgeTier.gold,
    ),

    // ── ACORDAR CEDO ────────────────────────────────────────────────
    BadgeDefinition(
      id: AppConstants.badgeWakeWeek,
      name: 'Wake Up, Neo',
      quote: '"Wake up, Neo... the alarm rings"',
      description: 'Wake up on time for 7 days in a row',
      goalType: 'wakeup',
      imagePath: 'assets/badges/wake_week.png',
      tier: BadgeTier.bronze,
    ),
    BadgeDefinition(
      id: AppConstants.badgeWakeMonth,
      name: 'Hey, You\'re Finally Awake',
      quote: '"You were trying to cross the border?"',
      description: 'Wake up on time for 30 days in a row',
      goalType: 'wakeup',
      imagePath: 'assets/badges/wake_month.png',
      tier: BadgeTier.silver,
    ),
    BadgeDefinition(
      id: AppConstants.badgeWake90,
      name: 'The Early Bird Gets the Dragon',
      quote: '"FUS RO DAH — good morning!"',
      description: 'Wake up on time for 90 days in a row',
      goalType: 'wakeup',
      imagePath: 'assets/badges/wake_90.png',
      tier: BadgeTier.gold,
    ),

    // ── LEITURA ─────────────────────────────────────────────────────
    BadgeDefinition(
      id: AppConstants.badgeBook1,
      name: 'One Does Not Simply Stop Reading',
      quote: '"One does not simply close a good book"',
      description: 'Finish your first book',
      goalType: 'reading',
      imagePath: 'assets/badges/book_first.png',
      tier: BadgeTier.bronze,
    ),
    BadgeDefinition(
      id: AppConstants.badgeReadMonth,
      name: 'Read the Damn Manual',
      quote: '"Certified space nerd"',
      description: 'Hit your daily reading goal for 30 days',
      goalType: 'reading',
      imagePath: 'assets/badges/read_month.png',
      tier: BadgeTier.silver,
    ),
    BadgeDefinition(
      id: AppConstants.badgeBook5,
      name: 'Knowledge Is Power, Guardian',
      quote: '"Ghost approves your dedication"',
      description: 'Finish 5 books',
      goalType: 'reading',
      imagePath: 'assets/badges/book_five.png',
      tier: BadgeTier.legendary,
    ),
  ];

  static BadgeDefinition? findById(String id) {
    try {
      return all.firstWhere((b) => b.id == id);
    } catch (_) {
      return null;
    }
  }

  static List<BadgeDefinition> forGoalType(String type) {
    return all.where((b) => b.goalType == type).toList();
  }

  static Color tierColor(BadgeTier tier) {
    switch (tier) {
      case BadgeTier.bronze:    return const Color(0xFFCD7F32);
      case BadgeTier.silver:    return const Color(0xFFC0C0C0);
      case BadgeTier.gold:      return const Color(0xFFFFD700);
      case BadgeTier.legendary: return const Color(0xFF9C59D1);
    }
  }

  static String tierEmoji(BadgeTier tier) {
    switch (tier) {
      case BadgeTier.bronze:    return '🥉';
      case BadgeTier.silver:    return '🥈';
      case BadgeTier.gold:      return '🥇';
      case BadgeTier.legendary: return '💜';
    }
  }
}