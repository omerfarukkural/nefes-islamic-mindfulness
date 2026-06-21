import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/offline_storage_service.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> _pages = [
    {
      'title': 'Hoş Geldin',
      'subtitle': 'Nefes ile iç huzurunu keşfet',
      'description':
          'İslami değerlerle desteklenmiş meditasyon ve mindfulness pratikleri ile ruhunu dinlendir.',
      'emoji': '🧘',
      'gradient': AppColors.headerGradient,
    },
    {
      'title': 'AI Sohbet Arkadaşın',
      'subtitle': 'Seni anlayan bir dost',
      'description':
          'Yapay zeka destekli sohbet arkadaşın her an yanında. Duygularını paylaş, destek al.',
      'emoji': '🤖',
      'gradient': const LinearGradient(
        colors: [Color(0xFF1565C0), Color(0xFF0288D1)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    },
    {
      'title': 'Ruh Halini Takip Et',
      'subtitle': 'Kendini tanı',
      'description':
          'Günlük ruh hali kaydı tut, duygusal kalıplarını keşfet ve iç dünyanı anla.',
      'emoji': '📊',
      'gradient': const LinearGradient(
        colors: [Color(0xFF6A1B9A), Color(0xFF8E24AA)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    },
    {
      'title': 'Dua & Zikir',
      'subtitle': 'Manevi rehberlik',
      'description':
          'Sabah-akşam duaları, sıkıntı anı duaları ve zikir pratikleri ile huzur bul.',
      'emoji': '📿',
      'gradient': AppColors.accentGradient,
    },
  ];

  Future<void> _finish() async {
    await OfflineStorageService.markOnboardingDone();
    if (mounted) context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Full-page swiper
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) => _buildPage(index),
          ),
          // Bottom overlay
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _buildBottom(),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(int index) {
    final page = _pages[index];
    return Container(
      decoration: BoxDecoration(
        gradient: page['gradient'] as LinearGradient,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(32, 60, 32, 160),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                page['emoji'] as String,
                style: const TextStyle(fontSize: 96),
              ),
              const SizedBox(height: 40),
              Text(
                page['title'] as String,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                page['subtitle'] as String,
                style: const TextStyle(
                  fontSize: 17,
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                page['description'] as String,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  color: Colors.white60,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottom() {
    return Container(
      padding: const EdgeInsets.fromLTRB(32, 20, 32, 40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withOpacity(0.5),
          ],
        ),
      ),
      child: Column(
        children: [
          // Page indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_pages.length, (index) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: _currentPage == index ? 28 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _currentPage == index
                      ? Colors.white
                      : Colors.white.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_currentPage < _pages.length - 1) {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                } else {
                  _finish();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF1B5E20),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
              child: Text(
                _currentPage < _pages.length - 1 ? 'Devam Et' : 'Başla!',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          if (_currentPage < _pages.length - 1) ...[
            const SizedBox(height: 12),
            TextButton(
              onPressed: _finish,
              child: const Text(
                'Atla',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ),
          ],
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
