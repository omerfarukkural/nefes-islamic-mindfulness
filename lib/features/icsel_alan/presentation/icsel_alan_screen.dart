import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';

class IcselAlanScreen extends StatelessWidget {
  const IcselAlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('İçsel Alan')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderCard(context),
            const SizedBox(height: 24),
            _buildSectionTitle(context, '🌟 Nefs Mertebeleri'),
            const SizedBox(height: 12),
            _buildNefsBanner(context),
            const SizedBox(height: 24),
            _buildSectionTitle(context, '📿 Esmaül Hüsna Meditasyonu'),
            const SizedBox(height: 12),
            _buildEsmaBanner(context),
            const SizedBox(height: 24),
            _buildSectionTitle(context, '🧘 Murâkabe Rehberi'),
            const SizedBox(height: 12),
            _buildMurakabe(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1A237E), Color(0xFF283593)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A237E).withOpacity(0.4),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('🕊️', style: TextStyle(fontSize: 36)),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'İçsel Alan',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            'Sufi geleneğinde nefs terbiyesi, kalbin arınması ve Allah\'a yakınlaşma yolculuğu. Her gün bir adım, her zikir bir ışık.',
            style: TextStyle(color: Colors.white70, height: 1.5, fontSize: 14),
          ),
        ],
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

  Widget _buildNefsBanner(BuildContext context) {
    final stages = [
      {'emoji': '🔴', 'name': 'Emmare', 'level': 1},
      {'emoji': '🟠', 'name': 'Levvame', 'level': 2},
      {'emoji': '🟡', 'name': 'Mülhime', 'level': 3},
      {'emoji': '🟢', 'name': 'Mutmainne', 'level': 4},
      {'emoji': '🔵', 'name': 'Radiyye', 'level': 5},
      {'emoji': '🟣', 'name': 'Mardiyye', 'level': 6},
      {'emoji': '⚪', 'name': 'Kâmile', 'level': 7},
    ];

    return GestureDetector(
      onTap: () => context.push('/nefs'),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: const Color(0xFF4A148C).withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF4A148C).withOpacity(0.25)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '7 Nefs Mertebesi',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
                const Icon(Icons.arrow_forward_ios, size: 14),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: stages.map((s) {
                return Column(
                  children: [
                    Text(s['emoji'] as String,
                        style: const TextStyle(fontSize: 20)),
                    const SizedBox(height: 4),
                    Text(
                      s['name'] as String,
                      style: const TextStyle(
                          fontSize: 9, fontWeight: FontWeight.w500),
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEsmaBanner(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/esma'),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.accent.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.accent.withOpacity(0.25)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: AppColors.accentGradient,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Text('📿', style: TextStyle(fontSize: 28)),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '99 İsim Meditasyonu',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Her ismin anlamı, zikir sayısı ve nefs mertebesine katkısı',
                    style: TextStyle(fontSize: 12, height: 1.4),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14),
          ],
        ),
      ),
    );
  }

  Widget _buildMurakabe(BuildContext context) {
    final practices = [
      {
        'title': 'Sabah Murâkabesi',
        'desc':
            'Sabah namazından sonra 10 dakika sessizce otur. Allah\'ın huzurunda olduğunu hissederek nefes al.',
        'emoji': '🌅',
        'duration': '10 dk',
      },
      {
        'title': 'Akşam Muhasebesi',
        'desc':
            'Güneş batmadan önce günü değerlendir: Bugün ne yaptım? Neyi daha iyi yapabilirdim?',
        'emoji': '🌇',
        'duration': '5 dk',
      },
      {
        'title': 'Zikir Seansı',
        'desc':
            '"La ilahe illallah" zikrini 100 kez oku, her tekrarda kalbini bu anlama aç.',
        'emoji': '📿',
        'duration': '15 dk',
      },
      {
        'title': 'Kur\'an Tefekkürü',
        'desc':
            'Günde bir ayet seç ve onunla uzun uzun kal. Sadece okuma değil, anlama ve yaşama.',
        'emoji': '📖',
        'duration': '20 dk',
      },
    ];

    return Column(
      children: practices.map((p) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardTheme.color,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A237E).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child:
                      Text(p['emoji']!, style: const TextStyle(fontSize: 22)),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              p['title']!,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 14),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              p['duration']!,
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        p['desc']!,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(height: 1.4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
