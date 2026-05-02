import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/providers/user_profile_provider.dart';
import '../../../shared/providers/daily_content_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(userProfileProvider);
    final concerns = ref.watch(activeConcernsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nefes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.go('/settings'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGreetingCard(context, profile?.name),
            const SizedBox(height: 20),
            _buildDailyContentCard(ref),
            const SizedBox(height: 20),
            const Text('Bugün Ne Yapmak İstersin?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildDynamicActions(context, concerns),
            const SizedBox(height: 20),
            _buildStatsCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildGreetingCard(BuildContext context, String? name) {
    final hour = DateTime.now().hour;
    String timeGreeting;
    if (hour < 6) {
      timeGreeting = 'İyi Geceler 🌙';
    } else if (hour < 12) {
      timeGreeting = 'Günaydın ☀️';
    } else if (hour < 17) {
      timeGreeting = 'İyi Günler 🌤️';
    } else {
      timeGreeting = 'İyi Akşamlar 🌅';
    }

    final greeting = name != null && name.isNotEmpty
        ? '$timeGreeting, $name!'
        : timeGreeting;

    return Card(
      color: AppColors.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(greeting,
                style: const TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Bugün kendine biraz zaman ayırmaya ne dersin?',
                style: TextStyle(fontSize: 14, color: Colors.white70)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/breathing'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primary,
              ),
              child: const Text('Nefes Egzersizi Başlat'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyContentCard(WidgetRef ref) {
    final asyncContent = ref.watch(dailyContentProvider);
    return asyncContent.when(
      loading: () => const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (_, __) => const SizedBox.shrink(),
      data: (content) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.format_quote, color: AppColors.accent),
                  const SizedBox(width: 8),
                  const Text('Günün Nefesi',
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                '"${content.text}"',
                style: const TextStyle(
                    fontSize: 15, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 4),
              Text(content.source,
                  style: TextStyle(
                      color: AppColors.textSecondary, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDynamicActions(
      BuildContext context, Set<String> concerns) {
    // All possible feature cards
    final allActions = <_FeatureCard>[
      _FeatureCard(
        icon: Icons.air,
        label: 'Nefes\nTeknikleri',
        route: '/breathing',
        color: Colors.blue.shade600,
        triggers: {'Kaygı', 'Stres', 'Öfke kontrolü'},
        priority: 10,
      ),
      _FeatureCard(
        icon: Icons.chat_bubble,
        label: 'AI\nSohbet',
        route: '/chat',
        color: AppColors.primary,
        triggers: {'Yalnızlık', 'Kaygı', 'Keder & kayıp'},
        priority: 9,
      ),
      _FeatureCard(
        icon: Icons.self_improvement,
        label: 'Meditasyon',
        route: '/meditation',
        color: Colors.teal.shade600,
        triggers: {'Stres', 'Uyku sorunları', 'Odaklanma güçlüğü'},
        priority: 8,
      ),
      _FeatureCard(
        icon: Icons.mood,
        label: 'Ruh Hali\nTakibi',
        route: '/mood',
        color: Colors.orange.shade600,
        triggers: {'Kaygı', 'Keder & kayıp', 'Beden imajı'},
        priority: 7,
      ),
      _FeatureCard(
        icon: Icons.book,
        label: 'Günlük',
        route: '/journal',
        color: Colors.purple.shade600,
        triggers: {'Keder & kayıp', 'Amaç kaybı', 'İlişki problemleri'},
        priority: 6,
      ),
      _FeatureCard(
        icon: Icons.build_circle,
        label: 'Araç\nKutusu',
        route: '/toolbox',
        color: Colors.red.shade600,
        triggers: {'Kaygı', 'Öfke kontrolü', 'Stres'},
        priority: 5,
      ),
      _FeatureCard(
        icon: Icons.check_circle,
        label: 'Alışkanlık\nTakibi',
        route: '/habits',
        color: Colors.green.shade700,
        triggers: {'Amaç kaybı', 'Odaklanma güçlüğü', 'Bağımlılık'},
        priority: 4,
      ),
      _FeatureCard(
        icon: Icons.auto_stories,
        label: 'Pratikler',
        route: '/practices',
        color: AppColors.accent,
        triggers: {},
        priority: 3,
      ),
    ];

    // Sort: cards matching user concerns come first
    final sorted = List<_FeatureCard>.from(allActions);
    sorted.sort((a, b) {
      final aMatch = a.triggers.intersection(concerns).isNotEmpty ? 1 : 0;
      final bMatch = b.triggers.intersection(concerns).isNotEmpty ? 1 : 0;
      if (aMatch != bMatch) return bMatch - aMatch;
      return b.priority - a.priority;
    });

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.8,
      ),
      itemCount: sorted.length,
      itemBuilder: (context, index) {
        final card = sorted[index];
        final isHighlighted =
            card.triggers.intersection(concerns).isNotEmpty;
        return GestureDetector(
          onTap: () => context.go(card.route),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: isHighlighted
                      ? card.color
                      : card.color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  card.icon,
                  size: 28,
                  color: isHighlighted ? Colors.white : card.color,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                card.label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isHighlighted
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: isHighlighted
                      ? card.color
                      : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatsCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('İstatistiklerim',
                style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('🔥', '0', 'Gün Serisi'),
                _buildStatItem('🧘', '0', 'Dakika'),
                _buildStatItem('📅', '0', 'Oturum'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String emoji, String value, String label) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 24)),
        const SizedBox(height: 4),
        Text(value,
            style:
                const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label,
            style: TextStyle(
                fontSize: 12, color: AppColors.textSecondary)),
      ],
    );
  }
}

class _FeatureCard {
  final IconData icon;
  final String label;
  final String route;
  final Color color;
  final Set<String> triggers;
  final int priority;

  const _FeatureCard({
    required this.icon,
    required this.label,
    required this.route,
    required this.color,
    required this.triggers,
    required this.priority,
  });
}
