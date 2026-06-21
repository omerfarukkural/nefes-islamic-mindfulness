import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hijri/hijri_calendar.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/offline_storage_service.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../core/providers/profile_provider.dart';
import '../../../core/models/user_profile.dart';
import '../../../core/providers/mizac_provider.dart';
import '../../../core/services/ebced_service.dart';
import '../../pusula/domain/kozmik_calculator.dart';
import '../../mizac/domain/mizac_model.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streak = OfflineStorageService.getMeditationStreak();
    final minutes = OfflineStorageService.getTotalMeditationMinutes();
    final sessions = OfflineStorageService.getTotalMeditationSessions();
    final isDark = ref.watch(themeProvider) == ThemeMode.dark;
    final profile = ref.watch(profileProvider);
    final mizac = ref.watch(mizacProvider);

    final now = DateTime.now();
    final dailyEnergy = KozmikCalculator.dailyEnergyNumber(now);
    final guidance = KozmikCalculator.dailyGuidance(dailyEnergy);
    final element = KozmikCalculator.elementOfNumber(dailyEnergy);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nefes'),
        actions: [
          IconButton(
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Icon(
                isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                key: ValueKey(isDark),
              ),
            ),
            onPressed: () => ref.read(themeProvider.notifier).toggle(),
            tooltip: isDark ? 'Aydınlık Mod' : 'Karanlık Mod',
          ),
          IconButton(
            icon: const Icon(Icons.access_time_rounded),
            onPressed: () => context.go('/prayer'),
            tooltip: 'Namaz Vakitleri',
          ),
          IconButton(
            icon: const Icon(Icons.settings_rounded),
            onPressed: () => context.go('/settings'),
            tooltip: 'Ayarlar',
          ),
        ],
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () async {},
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildGreetingCard(context, profile),
              const SizedBox(height: 16),
              _buildHijriCard(context),
              const SizedBox(height: 16),
              _buildDailyEnergyCard(context, dailyEnergy, element, guidance),
              const SizedBox(height: 20),
              if (profile != null && mizac != null) ...[
                _buildPersonalZikirCard(context, profile, mizac),
                const SizedBox(height: 16),
              ],
              Text(
                'Bugün Ne Yapmak İstersin?',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              _buildQuickActions(context),
              const SizedBox(height: 20),
              _buildDailyVerse(context),
              const SizedBox(height: 20),
              _buildStatsCard(context, streak, minutes, sessions),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGreetingCard(BuildContext context, UserProfile? profile) {
    final hour = DateTime.now().hour;
    final String greeting;
    final String subText;
    final String emoji;
    if (hour < 6) {
      greeting = 'Hayırlı Geceler';
      subText = 'Gece de olsa kalpler Allah\'la huzur bulur.';
      emoji = '🌙';
    } else if (hour < 12) {
      greeting = 'Hayırlı Sabahlar';
      subText = 'Güne besmeleyle başlamak en güzel başlangıçtır.';
      emoji = '☀️';
    } else if (hour < 17) {
      greeting = 'Hayırlı Öğleden Sonralar';
      subText = 'Bir anlık tefekkür yüz yıllık ibadetten hayırlıdır.';
      emoji = '🌤️';
    } else {
      greeting = 'Hayırlı Akşamlar';
      subText = 'Günü şükranla tamamlamak kalbi sakinleştirir.';
      emoji = '🌅';
    }

    final name = profile?.name;
    final displayGreeting = (name != null && name.isNotEmpty)
        ? '$greeting, $name'
        : greeting;

    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.headerGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(emoji, style: const TextStyle(fontSize: 32)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    displayGreeting,
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              subText,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.white70,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => context.go('/meditation'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Meditasyona Başla',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                if (profile == null) ...[
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.push('/profil'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: const BorderSide(color: Colors.white54),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Profil Kur'),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHijriCard(BuildContext context) {
    final hijri = HijriCalendar.now();
    final monthNames = [
      'Muharrem', 'Safer', 'Rebiülevvel', 'Rebiülahir',
      'Cemaziyelevvel', 'Cemaziyelahir', 'Recep', 'Şaban',
      'Ramazan', 'Şevval', 'Zilkade', 'Zilhicce',
    ];
    final monthName = monthNames[(hijri.hMonth - 1).clamp(0, 11)];
    final now = DateTime.now();
    final weekDays = ['Pazartesi', 'Salı', 'Çarşamba', 'Perşembe', 'Cuma', 'Cumartesi', 'Pazar'];
    final weekDay = weekDays[now.weekday - 1];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.accent.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.accent.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: AppColors.accentGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text('📅', style: TextStyle(fontSize: 20)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$weekDay, ${now.day} ${_monthTR(now.month)} ${now.year}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${hijri.hDay} $monthName ${hijri.hYear} H',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.accent,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => context.go('/prayer'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                gradient: AppColors.headerGradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Vakitler',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _monthTR(int m) {
    const months = [
      'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
      'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık',
    ];
    return months[m - 1];
  }

  Widget _buildDailyEnergyCard(
      BuildContext context, int energy, String element, String guidance) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4A148C), Color(0xFF6A1B9A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Text(
                  '$energy',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  element.split(' ').last,
                  style: const TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ],
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '🔮 Günün Enerjisi',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  guidance.split('. ').first + '.',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => context.push('/pusula'),
            child: const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalZikirCard(BuildContext context, UserProfile profile, MizacType mizac) {
    final lifePathNumber = profile.lifePathNumber;
    int ebcedVal = 0;
    if (profile.arabicName.isNotEmpty) {
      ebcedVal = EbcedService.reduceToDigit(
        EbcedService.calculateEbced(profile.arabicName),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: mizac.color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: mizac.color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(mizac.emoji, style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 8),
              Text(
                'Bana Özel Manevi Plan',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: mizac.color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildPersonalRow('📿 Mizaç Zikirm', mizac.zikir),
          _buildPersonalRow('☪️ Esma\'m', mizac.esma),
          _buildPersonalRow('🌟 Yaşam Yolu', '$lifePathNumber — ${EbcedService.getNumberMeaning(lifePathNumber).split('.').first}'),
          if (ebcedVal > 0)
            _buildPersonalRow('🔢 Ebced', '$ebcedVal — ${EbcedService.getEbcedMeaning(ebcedVal).split(' —').first}'),
        ],
      ),
    );
  }

  Widget _buildPersonalRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      {
        'icon': Icons.self_improvement,
        'label': 'Meditasyon',
        'route': '/meditation',
        'color': AppColors.primary,
        'bg': AppColors.primary.withOpacity(0.1),
      },
      {
        'icon': Icons.explore_rounded,
        'label': 'Keşfet',
        'route': '/kesket',
        'color': const Color(0xFF6A1B9A),
        'bg': const Color(0xFF6A1B9A).withOpacity(0.1),
      },
      {
        'icon': Icons.mood_rounded,
        'label': 'Ruh Hali',
        'route': '/mood',
        'color': const Color(0xFF1565C0),
        'bg': const Color(0xFF1565C0).withOpacity(0.1),
      },
      {
        'icon': Icons.menu_book_rounded,
        'label': 'Dua & Zikir',
        'route': '/dua',
        'color': AppColors.accent,
        'bg': AppColors.accentLight,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.6,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final a = actions[index];
        return Material(
          color: a['bg'] as Color,
          borderRadius: BorderRadius.circular(20),
          child: InkWell(
            onTap: () => context.go(a['route'] as String),
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: (a['color'] as Color).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      a['icon'] as IconData,
                      color: a['color'] as Color,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      a['label'] as String,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: a['color'] as Color,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDailyVerse(BuildContext context) {
    final verses = [
      {
        'text': '"Dikkat edin, kalpler ancak Allah\'ı anmakla huzur bulur."',
        'ref': 'Ra\'d Suresi, 28',
      },
      {
        'text': '"Allah hiçbir nefse gücünün yetmeyeceği yükü yüklemez."',
        'ref': 'Bakara Suresi, 286',
      },
      {
        'text': '"Güçlüğün yanında kolaylık vardır."',
        'ref': 'İnşirah Suresi, 5',
      },
      {
        'text': '"Allah sabredenlerle beraberdir."',
        'ref': 'Bakara Suresi, 153',
      },
      {
        'text': '"Kim Allah\'a tevekkül ederse O ona yeter."',
        'ref': 'Talak Suresi, 3',
      },
      {
        'text': '"Şüphesiz zorlukla birlikte kolaylık vardır."',
        'ref': 'İnşirah Suresi, 6',
      },
      {
        'text': '"O, beni yaratan ve doğru yolu gösteren O\'dur."',
        'ref': 'Şuara Suresi, 78',
      },
    ];
    final verse = verses[DateTime.now().day % verses.length];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.accent.withOpacity(0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: AppColors.accentGradient,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.auto_stories, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 10),
              Text(
                'Günün Ayeti',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            verse['text']!,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontStyle: FontStyle.italic,
                  height: 1.5,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            verse['ref']!,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard(BuildContext context, int streak, int minutes, int sessions) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.headerGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'İstatistiklerim',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem('🔥', '$streak', 'Gün Serisi'),
              _buildDivider(),
              _buildStatItem('🧘', '$minutes', 'Dakika'),
              _buildDivider(),
              _buildStatItem('📅', '$sessions', 'Oturum'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 40,
      color: Colors.white.withOpacity(0.2),
    );
  }

  Widget _buildStatItem(String emoji, String value, String label) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 22)),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.white60,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
