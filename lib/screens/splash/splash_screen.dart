import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:questlog/core/theme.dart';
import 'package:questlog/services/hive_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    // Tempo mínimo para ver a splash
    await Future.delayed(const Duration(milliseconds: 2200));
    if (!mounted) return;

    if (HiveService.isOnboardingDone()) {
      context.go('/home');
    } else {
      context.go('/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),

            // Logo / ícone
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.primary.withValues(alpha: 0.8),
                    AppTheme.wakeUp,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primary.withValues(alpha: 0.4),
                    blurRadius: 32,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: const Center(
                child: Text('⚔️', style: TextStyle(fontSize: 48)),
              ),
            )
                .animate()
                .scale(
              duration: 600.ms,
              curve: Curves.elasticOut,
            )
                .fadeIn(duration: 400.ms),

            const SizedBox(height: 28),

            // Nome do app
            const Text(
              'QuestLog',
              style: TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.w800,
                letterSpacing: -1.5,
              ),
            )
                .animate()
                .fadeIn(delay: 300.ms, duration: 500.ms)
                .slideY(begin: 0.3, curve: Curves.easeOut),

            const SizedBox(height: 8),

            // Tagline
            const Text(
              'Level up your habits',
              style: TextStyle(
                color: Colors.white38,
                fontSize: 14,
                letterSpacing: 0.5,
              ),
            )
                .animate()
                .fadeIn(delay: 500.ms, duration: 500.ms),

            const Spacer(),

            SizedBox(
              width: 120,
              child: LinearProgressIndicator(
                backgroundColor: Colors.white.withValues(alpha: 0.06),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppTheme.primary,
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            )
                .animate()
                .fadeIn(delay: 700.ms, duration: 400.ms),

            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}