import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:questlog/screens/onboarding/onboarding_screen.dart';
import 'package:questlog/screens/home/home_screen.dart';
import 'package:questlog/screens/profile/profile_screen.dart';
import 'package:questlog/services/hive_service.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final done = HiveService.isOnboardingDone();
    if (!done && state.matchedLocation != '/onboarding') return '/onboarding';
    if (done && state.matchedLocation == '/onboarding') return '/home';
    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      redirect: (_, __) =>
      HiveService.isOnboardingDone() ? '/home' : '/onboarding',
    ),
    GoRoute(
      path: '/onboarding',
      builder: (_, __) => const OnboardingScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: '/home',
          builder: (_, __) => const HomeScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (_, __) => const ProfileScreen(),
        ),
      ],
    ),
  ],
);

class MainShell extends StatefulWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  static const _routes = ['/home', '/profile'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (i) {
          setState(() => _selectedIndex = i);
          context.go(_routes[i]);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}