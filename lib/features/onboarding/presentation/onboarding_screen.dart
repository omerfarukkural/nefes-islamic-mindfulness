import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _pages = [
    {
      'title': 'Hoş Geldin',
      'subtitle': 'Nefes ile iç huzurunu keşfet',
      'description': 'İslami değerlerle desteklenmiş meditasyon ve mindfulness pratikleri ile ruhunu dinlendir.',
      'emoji': '🧘',
    },
    {
      'title': 'AI Sohbet Arkadaşın',
      'subtitle': 'Seni anlayan bir dost',
      'description': 'Yapay zeka destekli sohbet arkadaşın her an yanında. Duygularını paylaş, destek al.',
      'emoji': '🤖',
    },
    {
      'title': 'Ruh Halini Takip Et',
      'subtitle': 'Kendini tanı',
      'description': 'Günlük ruh hali kaydı tut, duygusal kalıplarını keşfet ve iç dünyanı anla.',
      'emoji': '📊',
    },
    {
      'title': 'Dua & Zikir',
      'subtitle': 'Manevi rehberlik',
      'description': 'Sabah-akşam duaları, sıkıntı anı duaları ve zikir pratikleri ile huzur bul.',
      'emoji': '📿',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(page['emoji']!, style: const TextStyle(fontSize: 80)),
                        const SizedBox(height: 32),
                        Text(page['title']!,
                            style: const TextStyle(
                                fontSize: 28, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text(page['subtitle']!,
                            style: TextStyle(
                                fontSize: 16, color: AppColors.primary)),
                        const SizedBox(height: 16),
                        Text(page['description']!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 14, color: AppColors.textSecondary)),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Page Indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_pages.length, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? AppColors.primary
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_currentPage < _pages.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      context.go('/');
                    }
                  },
                  child: Text(_currentPage < _pages.length - 1
                      ? 'Devam Et'
                      : 'Başla!'),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (_currentPage < _pages.length - 1)
              TextButton(
                onPressed: () => context.go('/'),
                child: const Text('Atla'),
              ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
