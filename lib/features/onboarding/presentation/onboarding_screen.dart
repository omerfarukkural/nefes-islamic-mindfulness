import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../shared/models/user_profile.dart';
import '../../../shared/providers/user_profile_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  static const int _totalSteps = 7;

  // Collected answers
  String _name = '';
  String _ageGroup = '';
  final Set<String> _concerns = {};
  final Set<String> _goals = {};
  String _spirituality = '';
  int _dailyMinutes = 10;
  String _preferredTime = '';

  void _nextStep() {
    if (_currentStep < _totalSteps - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  bool _canProceed() {
    switch (_currentStep) {
      case 0:
        return _name.trim().isNotEmpty;
      case 1:
        return _ageGroup.isNotEmpty;
      case 2:
        return _concerns.isNotEmpty;
      case 3:
        return _goals.isNotEmpty;
      case 4:
        return _spirituality.isNotEmpty;
      case 5:
        return true;
      case 6:
        return _preferredTime.isNotEmpty;
      default:
        return false;
    }
  }

  Future<void> _finishOnboarding() async {
    final profile = UserProfile(
      name: _name.trim(),
      ageGroup: _ageGroup,
      concerns: _concerns.toList(),
      goals: _goals.toList(),
      spirituality: _spirituality,
      dailyMinutes: _dailyMinutes,
      preferredTime: _preferredTime,
      completedAt: DateTime.now(),
    );
    await ref.read(userProfileProvider.notifier).saveProfile(profile);
    if (mounted) context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildProgressBar(),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) => setState(() => _currentStep = i),
                children: [
                  _buildNameStep(),
                  _buildAgeStep(),
                  _buildConcernsStep(),
                  _buildGoalsStep(),
                  _buildSpiritualityStep(),
                  _buildDailyMinutesStep(),
                  _buildPreferredTimeStep(),
                ],
              ),
            ),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_currentStep + 1} / $_totalSteps',
                style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500),
              ),
              if (_currentStep > 0)
                TextButton(
                  onPressed: () {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: const Text('Geri'),
                ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (_currentStep + 1) / _totalSteps,
              minHeight: 6,
              backgroundColor: Colors.grey.shade200,
              valueColor:
                  AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _canProceed() ? _nextStep : null,
          child:
              Text(_currentStep == _totalSteps - 1 ? 'Başla!' : 'Devam Et'),
        ),
      ),
    );
  }

  Widget _buildNameStep() {
    return _buildStepWrapper(
      emoji: '👋',
      title: 'Sana nasıl hitap edelim?',
      subtitle: 'Seni daha iyi tanımak için birkaç soru sormak istiyoruz.',
      child: TextField(
        autofocus: true,
        textCapitalization: TextCapitalization.words,
        decoration: InputDecoration(
          hintText: 'Adın...',
          filled: true,
          fillColor: AppColors.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          prefixIcon: const Icon(Icons.person_outline),
        ),
        onChanged: (v) => setState(() => _name = v),
      ),
    );
  }

  Widget _buildAgeStep() {
    const options = ['13-17', '18-25', '26-35', '36-50', '50+'];
    return _buildStepWrapper(
      emoji: '🎂',
      title: 'Yaş grubun?',
      subtitle: 'Sana uygun içerikler sunabilmemiz için.',
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: options
            .map((o) => _SelectChip(
                  label: o,
                  selected: _ageGroup == o,
                  onTap: () => setState(() => _ageGroup = o),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildConcernsStep() {
    return _buildStepWrapper(
      emoji: '🌧️',
      title: 'Seni en çok ne zorluyor?',
      subtitle: 'Birden fazla seçebilirsin.',
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: UserProfile.allConcerns
            .map((c) => _SelectChip(
                  label: c,
                  selected: _concerns.contains(c),
                  onTap: () => setState(() {
                    if (_concerns.contains(c)) {
                      _concerns.remove(c);
                    } else {
                      _concerns.add(c);
                    }
                  }),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildGoalsStep() {
    return _buildStepWrapper(
      emoji: '🎯',
      title: 'Hedefin ne?',
      subtitle:
          'Nefes ile ne kazanmak istiyorsun? (Birden fazla seçebilirsin)',
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: UserProfile.allGoals
            .map((g) => _SelectChip(
                  label: g,
                  selected: _goals.contains(g),
                  onTap: () => setState(() {
                    if (_goals.contains(g)) {
                      _goals.remove(g);
                    } else {
                      _goals.add(g);
                    }
                  }),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildSpiritualityStep() {
    return _buildStepWrapper(
      emoji: '✨',
      title: 'Manevi yönelimin?',
      subtitle:
          'Günlük içeriklerimizi sana özel hazırlamak için sormamız gerekiyor.',
      child: Column(
        children: UserProfile.spiritualityOptions
            .map((s) => _RadioTile(
                  label: s,
                  selected: _spirituality == s,
                  onTap: () => setState(() => _spirituality = s),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildDailyMinutesStep() {
    const options = [5, 10, 15, 30];
    return _buildStepWrapper(
      emoji: '⏱️',
      title: 'Günlük kaç dakika ayırabilirsin?',
      subtitle: 'Daha sonra değiştirebilirsin.',
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: options
            .map((m) => _SelectChip(
                  label: '$m dakika',
                  selected: _dailyMinutes == m,
                  onTap: () => setState(() => _dailyMinutes = m),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildPreferredTimeStep() {
    const options = {
      'Sabah': '🌅',
      'Öğle': '☀️',
      'Akşam': '🌇',
      'Stresli anlarda': '😤',
    };
    return _buildStepWrapper(
      emoji: '🕐',
      title: 'Ne zaman kullanmak istersin?',
      subtitle: 'Bildirimleri bu saate göre ayarlayacağız.',
      child: Column(
        children: options.entries
            .map((e) => _RadioTile(
                  label: '${e.value}  ${e.key}',
                  selected: _preferredTime == e.key,
                  onTap: () => setState(() => _preferredTime = e.key),
                ))
            .toList(),
      ),
    );
  }

  Widget _buildStepWrapper({
    required String emoji,
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 52)),
          const SizedBox(height: 16),
          Text(title,
              style: const TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(subtitle,
              style: TextStyle(
                  fontSize: 14, color: AppColors.textSecondary)),
          const SizedBox(height: 28),
          child,
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class _SelectChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SelectChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: selected ? AppColors.primary : Colors.grey.shade300,
            width: selected ? 2 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : AppColors.textPrimary,
            fontWeight:
                selected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class _RadioTile extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _RadioTile({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withOpacity(0.1)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color:
                selected ? AppColors.primary : Colors.grey.shade300,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              selected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              color: selected ? AppColors.primary : Colors.grey,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: selected
                      ? FontWeight.w600
                      : FontWeight.normal,
                  color: selected
                      ? AppColors.primary
                      : AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
