import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/profile_provider.dart';
import '../../../core/providers/mizac_provider.dart';
import '../../../core/models/user_profile.dart';
import '../../mizac/domain/mizac_model.dart';

class KesketScreen extends ConsumerWidget {
  const KesketScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    final mizac = ref.watch(mizacProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Keşfet'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_rounded),
            onPressed: () => context.push('/profil'),
            tooltip: 'Profilim',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (profile != null) _buildProfileBanner(context, profile, mizac),
            if (profile == null) _buildSetupBanner(context),
            const SizedBox(height: 20),
            _buildSectionTitle(context, '✨ Kadim İlimler'),
            const SizedBox(height: 12),
            _buildKadimIlimler(context),
            const SizedBox(height: 24),
            _buildSectionTitle(context, '🌙 Manevi Araçlar'),
            const SizedBox(height: 12),
            _buildManeviAraclar(context),
            const SizedBox(height: 24),
            _buildSectionTitle(context, '📓 Günlük & Takip'),
            const SizedBox(height: 12),
            _buildGunlukTakip(context),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileBanner(BuildContext context, UserProfile profile, MizacType? mizac) {
    final name = profile.name;
    final mizacLabel = mizac != null ? mizac.label : 'Belirsiz';
    final mizacEmoji = mizac != null ? mizac.emoji : '❓';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.headerGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : '?',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Merhaba, $name',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$mizacEmoji Mizaç: $mizacLabel',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => context.push('/profil'),
            child: const Icon(Icons.chevron_right, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildSetupBanner(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/profil'),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.accent.withOpacity(0.8), AppColors.accent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            const Text('👤', style: TextStyle(fontSize: 36)),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Profilini Oluştur',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Kişiselleştirilmiş manevi rehberlik için bilgilerini gir.',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
    );
  }

  Widget _buildKadimIlimler(BuildContext context) {
    final items = [
      {
        'title': 'Kozmik Pusula',
        'subtitle': 'Numeroloji & Enerji',
        'emoji': '🔮',
        'route': '/pusula',
        'color': const Color(0xFF6A1B9A),
      },
      {
        'title': 'Mizaç Rehberi',
        'subtitle': '4 Unsur & Ahlat-ı Erbaa',
        'emoji': '🌿',
        'route': '/mizac',
        'color': const Color(0xFF2E7D32),
      },
      {
        'title': 'Ebced Hesabı',
        'subtitle': 'Harf & Sayı Sırları',
        'emoji': '🔢',
        'route': '/ebced',
        'color': const Color(0xFFE65100),
      },
      {
        'title': 'Esmaül Hüsna',
        'subtitle': '99 İsim Meditasyonu',
        'emoji': '📿',
        'route': '/esma',
        'color': const Color(0xFF00695C),
      },
    ];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.3,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) => _buildFeatureCard(context, items[index]),
    );
  }

  Widget _buildManeviAraclar(BuildContext context) {
    final items = [
      {
        'title': 'İçsel Alan',
        'subtitle': 'Nefs & Tasavvuf',
        'emoji': '🕊️',
        'route': '/icsel_alan',
        'color': const Color(0xFF1565C0),
      },
      {
        'title': 'Nefs Mertebesi',
        'subtitle': '7 Kademe Yolculuğu',
        'emoji': '🌟',
        'route': '/nefs',
        'color': const Color(0xFF4A148C),
      },
    ];
    return Row(
      children: items
          .map((item) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 6, left: 6),
                  child: _buildFeatureCard(context, item),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildGunlukTakip(BuildContext context) {
    final items = [
      {
        'title': 'Rüya Günlüğü',
        'subtitle': 'İslami yorum & semboller',
        'emoji': '🌙',
        'route': '/gunluk',
        'color': const Color(0xFF37474F),
      },
      {
        'title': 'Niyet & Dua',
        'subtitle': 'Kişisel dua planın',
        'emoji': '🤲',
        'route': '/dua',
        'color': AppColors.accent,
      },
    ];
    return Row(
      children: items
          .map((item) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 6, left: 6),
                  child: _buildFeatureCard(context, item),
                ),
              ))
          .toList(),
    );
  }

  Widget _buildFeatureCard(BuildContext context, Map<String, dynamic> item) {
    final color = item['color'] as Color;
    return Material(
      color: color.withOpacity(0.08),
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: () => context.push(item['route'] as String),
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item['emoji'] as String,
                style: const TextStyle(fontSize: 30),
              ),
              const SizedBox(height: 10),
              Text(
                item['title'] as String,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: color,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                item['subtitle'] as String,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontSize: 11,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
