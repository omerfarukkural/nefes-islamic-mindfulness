import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/mizac_provider.dart';
import '../../../core/providers/profile_provider.dart';
import '../domain/mizac_model.dart';
import '../domain/mizac_calculator.dart';

class MizacScreen extends ConsumerWidget {
  const MizacScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mizac = ref.watch(mizacProvider);
    final profile = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mizaç Rehberi'),
        actions: [
          if (mizac != null)
            TextButton(
              onPressed: () => context.push('/mizac/sorular'),
              child: const Text('Yeniden Test'),
            ),
        ],
      ),
      body: mizac == null
          ? _buildNoMizacView(context, profile)
          : _buildMizacView(context, ref, mizac),
    );
  }

  Widget _buildNoMizacView(BuildContext context, dynamic profile) {
    // Try birth season guess
    MizacType? guessed;
    if (profile != null) {
      guessed = MizacCalculator.fromBirthSeason(profile.birthDate as DateTime);
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildIntroCard(context),
          const SizedBox(height: 20),
          if (guessed != null) ...[
            Text(
              '🌱 Doğum Mevsimine Göre Tahmin',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 10),
            _buildMizacTypeCard(context, guessed, dimmed: true),
            const SizedBox(height: 8),
            const Text(
              'Bu tahminin doğruluğunu test ile teyit et.',
              style: TextStyle(fontSize: 13, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 20),
          ],
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => context.push('/mizac/sorular'),
              icon: const Icon(Icons.quiz_rounded),
              label: const Text(
                'Mizaç Testine Başla',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildAllMizacTypes(context),
        ],
      ),
    );
  }

  Widget _buildIntroCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('🌿', style: TextStyle(fontSize: 32)),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Ahlat-ı Erbaa',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            'İslam tıbbının temelini oluşturan 4 mizaç teorisi; insan bedenini, ruhunu ve kişiliğini 4 unsur üzerinden anlar: Dem (Hava), Safra (Ateş), Balgam (Su), Sevda (Toprak).',
            style: TextStyle(color: Colors.white70, height: 1.5, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildMizacView(BuildContext context, WidgetRef ref, MizacType mizac) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMizacTypeCard(context, mizac),
          const SizedBox(height: 20),
          _buildDetailSection(context, '🥗 Beslenme Önerileri', mizac.dietRecommendations),
          const SizedBox(height: 16),
          _buildDetailSection(context, '💤 Uyku Tavsiyeleri', mizac.sleepTips),
          const SizedBox(height: 16),
          _buildDetailSection(context, '🏃 Aktivite Önerileri', mizac.activityRecommendations),
          const SizedBox(height: 16),
          _buildSpiritualCard(context, mizac),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildMizacTypeCard(BuildContext context, MizacType mizac, {bool dimmed = false}) {
    final color = mizac.color;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: dimmed ? color.withOpacity(0.1) : null,
        gradient: dimmed
            ? null
            : LinearGradient(
                colors: [color.withOpacity(0.8), color],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        borderRadius: BorderRadius.circular(20),
        border: dimmed ? Border.all(color: color.withOpacity(0.4)) : null,
        boxShadow: dimmed
            ? null
            : [
                BoxShadow(
                  color: color.withOpacity(0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(mizac.emoji, style: const TextStyle(fontSize: 36)),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mizac.label,
                      style: TextStyle(
                        color: dimmed ? color : Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '${mizac.element} • ${mizac.season}',
                      style: TextStyle(
                        color: dimmed ? color.withOpacity(0.7) : Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            mizac.description,
            style: TextStyle(
              color: dimmed ? null : Colors.white,
              height: 1.5,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailSection(BuildContext context, String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 10),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  margin: const EdgeInsets.only(top: 7, right: 10),
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    shape: BoxShape.circle,
                  ),
                ),
                Expanded(
                  child: Text(
                    item,
                    style: const TextStyle(height: 1.4, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSpiritualCard(BuildContext context, MizacType mizac) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.accent.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accent.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🤲 Manevi Yönlendirme',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 14),
          _buildSpiritualRow('☪️ Esma', mizac.esma),
          const SizedBox(height: 8),
          _buildSpiritualRow('📿 Zikir', mizac.zikir),
        ],
      ),
    );
  }

  Widget _buildSpiritualRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
        ),
        Expanded(
          child: Text(value, style: const TextStyle(fontSize: 14)),
        ),
      ],
    );
  }

  Widget _buildAllMizacTypes(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '4 Mizaç Türü',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 12),
        ...MizacType.values.map(
          (m) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: m.color.withOpacity(0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: m.color.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Text(m.emoji, style: const TextStyle(fontSize: 28)),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          m.label,
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: m.color,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          '${m.element} • ${m.season}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
