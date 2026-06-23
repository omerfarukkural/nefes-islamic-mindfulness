import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/models/user_profile.dart';
import '../../../core/providers/profile_provider.dart';
import '../../../core/providers/mizac_provider.dart';
import '../../../core/services/ebced_service.dart';
import '../../mizac/domain/mizac_model.dart';

class ProfilScreen extends ConsumerStatefulWidget {
  const ProfilScreen({super.key});

  @override
  ConsumerState<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends ConsumerState<ProfilScreen> {
  final _nameCtrl = TextEditingController();
  final _arabicNameCtrl = TextEditingController();
  DateTime _birthDate = DateTime(1990, 6, 15);
  String _gender = 'Erkek';
  bool _editing = false;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(profileProvider);
    if (profile != null) {
      _nameCtrl.text = profile.name;
      _arabicNameCtrl.text = profile.arabicName;
      _birthDate = profile.birthDate;
      _gender = profile.gender;
    } else {
      _editing = true;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _arabicNameCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_nameCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('İsim boş bırakılamaz')),
      );
      return;
    }
    final profile = UserProfile(
      name: _nameCtrl.text.trim(),
      arabicName: _arabicNameCtrl.text.trim(),
      birthDate: _birthDate,
      gender: _gender,
      mizac: ref.read(profileProvider)?.mizac ?? '',
    );
    await ref.read(profileProvider.notifier).save(profile);
    if (mounted) {
      setState(() => _editing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil kaydedildi ✓')),
      );
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate,
      firstDate: DateTime(1930),
      lastDate: DateTime.now(),
      helpText: 'Doğum Tarihini Seç',
    );
    if (picked != null) setState(() => _birthDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileProvider);
    final mizac = ref.watch(mizacProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profilim'),
        actions: [
          if (!_editing && profile != null)
            IconButton(
              icon: const Icon(Icons.edit_rounded),
              onPressed: () => setState(() => _editing = true),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_editing)
              _buildEditForm(context)
            else
              _buildProfileView(context, profile!, mizac),
            if (!_editing && profile != null) ...[
              const SizedBox(height: 24),
              _buildPersonalNumbers(context, profile),
              const SizedBox(height: 24),
              _buildMizacCard(context, mizac),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEditForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: AppColors.headerGradient,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            children: [
              Text('👤', style: TextStyle(fontSize: 36)),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Profil Bilgilerini Gir',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Kişiselleştirilmiş manevi rehberlik için',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _buildLabel('İsim *'),
        const SizedBox(height: 8),
        TextField(
          controller: _nameCtrl,
          decoration: const InputDecoration(
            hintText: 'Adınızı girin',
            prefixIcon: Icon(Icons.person_rounded),
          ),
          textCapitalization: TextCapitalization.words,
        ),
        const SizedBox(height: 16),
        _buildLabel('Arapça İsim (varsa)'),
        const SizedBox(height: 8),
        TextField(
          controller: _arabicNameCtrl,
          decoration: const InputDecoration(
            hintText: 'مثلاً: محمد',
            prefixIcon: Icon(Icons.translate_rounded),
          ),
          textDirection: TextDirection.rtl,
        ),
        const SizedBox(height: 16),
        _buildLabel('Doğum Tarihi *'),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickDate,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).dividerColor),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today_rounded, size: 20),
                const SizedBox(width: 12),
                Text(
                  '${_birthDate.day}/${_birthDate.month}/${_birthDate.year}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const Spacer(),
                const Icon(Icons.edit_rounded, size: 16),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildLabel('Cinsiyet'),
        const SizedBox(height: 8),
        SegmentedButton<String>(
          segments: const [
            ButtonSegment(
                value: 'Erkek',
                label: Text('Erkek'),
                icon: Icon(Icons.male_rounded)),
            ButtonSegment(
                value: 'Kadın',
                label: Text('Kadın'),
                icon: Icon(Icons.female_rounded)),
          ],
          selected: {_gender},
          onSelectionChanged: (s) => setState(() => _gender = s.first),
        ),
        const SizedBox(height: 28),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _save,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
            child: const Text(
              'Kaydet',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileView(
      BuildContext context, UserProfile profile, MizacType? mizac) {
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
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    profile.name.isNotEmpty
                        ? profile.name[0].toUpperCase()
                        : '?',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w800),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.name,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                    ),
                    if (profile.arabicName.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        profile.arabicName,
                        style: AppTheme.arabicTextStyle(
                            color: Colors.white70, fontSize: 18),
                      ),
                    ],
                    const SizedBox(height: 4),
                    Text(
                      '${profile.gender} • ${profile.birthDate.day}/${profile.birthDate.month}/${profile.birthDate.year}',
                      style:
                          const TextStyle(color: Colors.white60, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (mizac != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(mizac.emoji, style: const TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  Text(
                    'Mizaç: ${mizac.label}',
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPersonalNumbers(BuildContext context, UserProfile profile) {
    final lifePathNumber = profile.lifePathNumber;
    int ebcedValue = 0;
    int turkishNum = 0;
    if (profile.arabicName.isNotEmpty) {
      ebcedValue = EbcedService.calculateEbced(profile.arabicName);
    }
    if (profile.name.isNotEmpty) {
      turkishNum = EbcedService.reduceToDigit(
        EbcedService.calculateTurkishNumerology(profile.name),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '🔢 Kişisel Sayılarım',
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
                child: _buildNumberCard(
              context,
              '🌟',
              'Yaşam Yolu',
              '$lifePathNumber',
              EbcedService.getNumberMeaning(lifePathNumber),
              AppColors.primary,
            )),
            const SizedBox(width: 10),
            Expanded(
                child: _buildNumberCard(
              context,
              '🔤',
              'İsim Sayısı',
              '$turkishNum',
              EbcedService.getNumberMeaning(turkishNum),
              const Color(0xFF1565C0),
            )),
          ],
        ),
        if (profile.arabicName.isNotEmpty) ...[
          const SizedBox(height: 10),
          _buildNumberCard(
            context,
            '☪️',
            'Ebced Değeri',
            '$ebcedValue',
            EbcedService.getEbcedMeaning(ebcedValue),
            AppColors.accent,
          ),
        ],
      ],
    );
  }

  Widget _buildNumberCard(BuildContext context, String emoji, String label,
      String value, String meaning, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            meaning,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  height: 1.4,
                  fontSize: 11,
                ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildMizacCard(BuildContext context, MizacType? mizac) {
    if (mizac == null) {
      return GestureDetector(
        onTap: () => context.push('/mizac'),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF2E7D32).withOpacity(0.08),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF2E7D32).withOpacity(0.3)),
          ),
          child: const Row(
            children: [
              Text('🌿', style: TextStyle(fontSize: 32)),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Mizacını Keşfet',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 16)),
                    SizedBox(height: 4),
                    Text('10 soruluk test ile 4 unsur mizacını öğren',
                        style: TextStyle(fontSize: 13)),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: mizac.color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: mizac.color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(mizac.emoji, style: const TextStyle(fontSize: 32)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mizac.label,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: mizac.color,
                      ),
                    ),
                    Text(
                      'Unsur: ${mizac.element} • Mevsim: ${mizac.season}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () => context.push('/mizac'),
                child: const Text('Detay'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            mizac.description,
            style:
                Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
          ),
          const SizedBox(height: 12),
          _buildMizacInfo('Esma', mizac.esma),
          const SizedBox(height: 4),
          _buildMizacInfo('Zikir', mizac.zikir),
        ],
      ),
    );
  }

  Widget _buildMizacInfo(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label: ',
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
        ),
        Expanded(
          child: Text(value, style: const TextStyle(fontSize: 13)),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
    );
  }
}
