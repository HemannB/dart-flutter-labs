class AppConstants {
  // Hive boxes
  static const String userBox     = 'user_box';
  static const String goalsBox    = 'goals_box';
  static const String logsBox     = 'logs_box';
  static const String settingsBox = 'settings_box';

  // XP por ação
  static const int xpWaterComplete   = 80;
  static const int xpWakeUpComplete  = 50;
  static const int xpReadingComplete = 60;
  static const int xpBookFinished    = 200;
  static const int xpStreakWeekly    = 150;
  static const int xpBadgeUnlocked   = 100;

  // XP para subir de nível (nível × 200)
  static int xpForLevel(int level) => level * 200;

  // Água
  static const int waterGlassDefault       = 200;
  static const List<int> waterGlassOptions = [150, 200, 250, 300, 350, 500];

  // IDs de notificação
  static const int notifWaterBase = 1000;
  static const int notifAlarmId   = 2000;

  // Badge IDs
  static const String badgeWaterWeek  = 'water_week';
  static const String badgeWaterMonth = 'water_month';
  static const String badgeWater100   = 'water_100';
  static const String badgeWakeWeek   = 'wake_week';
  static const String badgeWakeMonth  = 'wake_month';
  static const String badgeWake90     = 'wake_90';
  static const String badgeBook1      = 'book_first';
  static const String badgeReadMonth  = 'read_month';
  static const String badgeBook5      = 'book_five';
}