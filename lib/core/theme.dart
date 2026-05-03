import 'package:flutter/material.dart';

class AppTheme {
  // Cores principais
  static const Color primary      = Color(0xFF6C63FF);
  static const Color primaryLight = Color(0xFF9C95FF);
  static const Color water        = Color(0xFF378ADD);
  static const Color wakeUp       = Color(0xFF7F77DD);
  static const Color reading      = Color(0xFF1D9E75);
  static const Color xpGold       = Color(0xFFBA7517);
  static const Color xpGoldLight  = Color(0xFFFAEEDA);

  // Superfícies dark
  static const Color bg          = Color(0xFF13131F);
  static const Color surface     = Color(0xFF1C1C2E);
  static const Color surfaceCard = Color(0xFF252538);
  static const Color surfaceHigh = Color(0xFF2E2E45);

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bg,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: xpGold,
        surface: surface,
        onSurface: Colors.white,
        tertiary: reading,
      ),
      // Flutter 3.29: CardTheme → CardThemeData
      cardTheme: CardThemeData(
        color: surfaceCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.06), width: 0.5),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: bg,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      textTheme: const TextTheme(
        displayLarge:   TextStyle(color: Colors.white, fontWeight: FontWeight.w700, letterSpacing: -1),
        headlineMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        titleLarge:     TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        titleMedium:    TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        bodyLarge:      TextStyle(color: Colors.white, fontSize: 16),
        bodyMedium:     TextStyle(color: Color(0xFFB0B0C8), fontSize: 14),
        bodySmall:      TextStyle(color: Color(0xFF7A7A9A), fontSize: 12),
        labelSmall:     TextStyle(color: Color(0xFF7A7A9A), fontSize: 11),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceHigh,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primary, width: 1.5),
        ),
        labelStyle: const TextStyle(color: Color(0xFF7A7A9A)),
        hintStyle:  const TextStyle(color: Color(0xFF4A4A6A)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: const BorderSide(color: primary),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: Colors.white.withValues(alpha: 0.06),
        thickness: 0.5,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surface,
        indicatorColor: primary.withValues(alpha: 0.2),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(color: primary, fontSize: 11, fontWeight: FontWeight.w600);
          }
          return const TextStyle(color: Color(0xFF555570), fontSize: 11);
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: primary);
          }
          return const IconThemeData(color: Color(0xFF555570));
        }),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: primary,
        inactiveTrackColor: Colors.white.withValues(alpha: 0.1),
        thumbColor: primary,
        overlayColor: primary.withValues(alpha: 0.2),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected) ? primary : Colors.white38),
        trackColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected)
                ? primary.withValues(alpha: 0.4)
                : Colors.white.withValues(alpha: 0.1)),
      ),
    );
  }

  // Cor por tipo de meta
  static Color goalColor(String type) {
    switch (type) {
      case 'water':   return water;
      case 'wakeup':  return wakeUp;
      case 'reading': return reading;
      default:        return primary;
    }
  }
}