import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            // Greeting Card
            _buildGreetingCard(context),
            const SizedBox(height: 20),
            // Quick Actions
            const Text('Bugün Ne Yapmak İstersin?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildQuickActions(context),
            const SizedBox(height: 20),
            // Daily Verse
            _buildDailyVerse(),
            const SizedBox(height: 20),
            // Stats
            _buildStatsCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildGreetingCard(BuildContext context) {
    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 6) {
      greeting = 'Hayırlı Geceler 🌙';
    } else if (hour < 12) {
      greeting = 'Hayırlı Sabahlar ☀️';
    } else if (hour < 17) {
      greeting = 'Hayırlı Öğleden Sonralar 🌤️';
    } else {
      greeting = 'Hayırlı Akşamlar 🌅';
    }

    return Card(
      color: AppColors.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(greeting,
                style: const TextStyle(
                    fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Bugün kendine biraz zaman ayırmaya ne dersin?',
                style: TextStyle(fontSize: 14, color: Colors.white70)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/meditation'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primary,
              ),
              child: const Text('Meditasyona Başla'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      {'icon': Icons.self_improvement, 'label': 'Meditasyon', 'route': '/meditation'},
      {'icon': Icons.chat_bubble, 'label': 'AI Sohbet', 'route': '/chat'},
      {'icon': Icons.mood, 'label': 'Ruh Hali', 'route': '/mood'},
      {'icon': Icons.menu_book, 'label': 'Dua & Zikir', 'route': '/dua'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.5,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final action = actions[index];
        return Card(
          child: InkWell(
            onTap: () => context.go(action['route'] as String),
            borderRadius: BorderRadius.circular(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(action['icon'] as IconData,
                    size: 36, color: AppColors.primary),
                const SizedBox(height: 8),
                Text(action['label'] as String,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDailyVerse() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.auto_stories, color: AppColors.accent),
                const SizedBox(width: 8),
                const Text('Günün Ayeti',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              '"Dikkat edin, kalpler ancak Allah\'ı anmakla huzur bulur."',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 4),
            Text('Ra\'d Suresi, 28',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          ],
        ),
      ),
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
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
      ],
    );
  }
}
