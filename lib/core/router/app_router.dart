import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/home/presentation/home_screen.dart';
import '../../features/meditation/presentation/meditation_screen.dart';
import '../../features/chat/presentation/chat_screen.dart';
import '../../features/mood/presentation/mood_screen.dart';
import '../../features/dua/presentation/dua_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/paywall/paywall_screen.dart';
import '../services/offline_storage_service.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final bool hasSeenOnboarding =
      OfflineStorageService.getSetting('onboarding_complete',
          defaultValue: false) as bool? ??
          false;

  return GoRouter(
    initialLocation: hasSeenOnboarding ? '/' : '/onboarding',
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/paywall',
        builder: (context, state) => const PaywallScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/meditation',
            builder: (context, state) => const MeditationScreen(),
          ),
          GoRoute(
            path: '/chat',
            builder: (context, state) => const ChatScreen(),
          ),
          GoRoute(
            path: '/mood',
            builder: (context, state) => const MoodScreen(),
          ),
          GoRoute(
            path: '/dua',
            builder: (context, state) => const DuaScreen(),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
    ],
  );
});

class MainShell extends StatefulWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
          switch (index) {
            case 0: context.go('/'); break;
            case 1: context.go('/meditation'); break;
            case 2: context.go('/chat'); break;
            case 3: context.go('/mood'); break;
            case 4: context.go('/dua'); break;
          }
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_rounded), label: 'Ana Sayfa'),
          NavigationDestination(icon: Icon(Icons.self_improvement), label: 'Meditasyon'),
          NavigationDestination(icon: Icon(Icons.chat_bubble_rounded), label: 'AI Sohbet'),
          NavigationDestination(icon: Icon(Icons.mood_rounded), label: 'Ruh Hali'),
          NavigationDestination(icon: Icon(Icons.menu_book_rounded), label: 'Dua'),
        ],
      ),
    );
  }
}
