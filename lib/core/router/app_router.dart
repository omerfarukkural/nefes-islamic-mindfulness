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
import '../../features/prayer/presentation/prayer_screen.dart';
import '../../features/kesket/presentation/kesket_screen.dart';
import '../../features/profil/presentation/profil_screen.dart';
import '../../features/ebced/presentation/ebced_screen.dart';
import '../../features/pusula/presentation/pusula_screen.dart';
import '../../features/mizac/presentation/mizac_screen.dart';
import '../../features/mizac/presentation/mizac_sorular_screen.dart';
import '../../features/icsel_alan/presentation/icsel_alan_screen.dart';
import '../../features/icsel_alan/presentation/nefs_screen.dart';
import '../../features/icsel_alan/presentation/esma_screen.dart';
import '../../features/gunluk/presentation/gunluk_screen.dart';
import '../../features/gunluk/presentation/gunluk_yeni_screen.dart';
import '../services/offline_storage_service.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final showOnboarding = !OfflineStorageService.hasSeenOnboarding();
  return GoRouter(
    initialLocation: showOnboarding ? '/onboarding' : '/',
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/profil',
        builder: (context, state) => const ProfilScreen(),
      ),
      GoRoute(
        path: '/ebced',
        builder: (context, state) => const EbcedScreen(),
      ),
      GoRoute(
        path: '/pusula',
        builder: (context, state) => const PusulaScreen(),
      ),
      GoRoute(
        path: '/mizac',
        builder: (context, state) => const MizacScreen(),
        routes: [
          GoRoute(
            path: 'sorular',
            builder: (context, state) => const MizacSorularScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/icsel_alan',
        builder: (context, state) => const IcselAlanScreen(),
      ),
      GoRoute(
        path: '/nefs',
        builder: (context, state) => const NefsScreen(),
      ),
      GoRoute(
        path: '/esma',
        builder: (context, state) => const EsmaScreen(),
      ),
      GoRoute(
        path: '/gunluk',
        builder: (context, state) => const GunlukScreen(),
        routes: [
          GoRoute(
            path: 'yeni',
            builder: (context, state) => const GunlukYeniScreen(),
          ),
        ],
      ),
      ShellRoute(
        builder: (context, state, child) => MainShell(
          location: state.uri.toString(),
          child: child,
        ),
        routes: [
          GoRoute(path: '/', builder: (_, __) => const HomeScreen()),
          GoRoute(path: '/meditation', builder: (_, __) => const MeditationScreen()),
          GoRoute(path: '/chat', builder: (_, __) => const ChatScreen()),
          GoRoute(path: '/mood', builder: (_, __) => const MoodScreen()),
          GoRoute(path: '/dua', builder: (_, __) => const DuaScreen()),
          GoRoute(path: '/kesket', builder: (_, __) => const KesketScreen()),
          GoRoute(path: '/prayer', builder: (_, __) => const PrayerScreen()),
          GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
        ],
      ),
    ],
  );
});

class MainShell extends StatelessWidget {
  final String location;
  final Widget child;

  const MainShell({super.key, required this.location, required this.child});

  static const _routes = ['/', '/meditation', '/kesket', '/dua', '/chat'];

  int get _currentIndex {
    final idx = _routes.indexOf(location);
    return idx == -1 ? 0 : idx;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          context.go(_routes[index]);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Ana Sayfa',
          ),
          NavigationDestination(
            icon: Icon(Icons.self_improvement_outlined),
            selectedIcon: Icon(Icons.self_improvement),
            label: 'Meditasyon',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore_rounded),
            label: 'Keşfet',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book_rounded),
            label: 'Dua & Zikir',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline_rounded),
            selectedIcon: Icon(Icons.chat_bubble_rounded),
            label: 'AI Sohbet',
          ),
        ],
      ),
    );
  }
}
