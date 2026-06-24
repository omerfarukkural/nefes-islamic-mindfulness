import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/ilham_data.dart';

final _currentIndexProvider = StateProvider<int>((ref) => 0);

class IlhamScreen extends ConsumerStatefulWidget {
  const IlhamScreen({super.key});

  @override
  ConsumerState<IlhamScreen> createState() => _IlhamScreenState();
}

class _IlhamScreenState extends ConsumerState<IlhamScreen>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;
  final List<IlhamEntry> _entries = ilhamHavuzu;

  @override
  void initState() {
    super.initState();
    final todayIdx = (DateTime.now().year * 366 +
            DateTime.now().month * 31 +
            DateTime.now().day) %
        _entries.length;
    _pageController = PageController(initialPage: todayIdx);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(_currentIndexProvider.notifier).state = todayIdx;
    });
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
      value: 1.0,
    );
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _fadeCtrl.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    _fadeCtrl.forward(from: 0);
    ref.read(_currentIndexProvider.notifier).state = index;
  }

  @override
  Widget build(BuildContext context) {
    final currentIdx = ref.watch(_currentIndexProvider);
    final entry = _entries[currentIdx];
    final bgColor = Color(entry.color);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 700),
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0, -0.5),
                radius: 1.4,
                colors: [bgColor.withOpacity(0.55), Colors.black],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _buildTopBar(context, currentIdx),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _entries.length,
                    onPageChanged: _onPageChanged,
                    itemBuilder: (context, index) {
                      return _buildCard(_entries[index]);
                    },
                  ),
                ),
                _buildDots(currentIdx),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, int idx) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white70),
          ),
          const Spacer(),
          Column(
            children: [
              Text(
                'İlham',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
              Text(
                '${idx + 1} / ${_entries.length}',
                style: const TextStyle(color: Colors.white38, fontSize: 11),
              ),
            ],
          ),
          const Spacer(),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildCard(IlhamEntry entry) {
    final color = Color(entry.color);
    return FadeTransition(
      opacity: _fadeAnim,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
              decoration: BoxDecoration(
                color: color.withOpacity(0.3),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: color.withOpacity(0.5), width: 1),
              ),
              child: Text(
                entry.category,
                style: TextStyle(
                  color: color.withOpacity(0.9),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 40),
            Text(
              entry.arabic,
              style: TextStyle(
                color: Colors.white,
                fontSize: entry.arabic.length > 60 ? 22 : 28,
                fontWeight: FontWeight.w500,
                height: 1.8,
                shadows: [
                  Shadow(
                    color: color.withOpacity(0.7),
                    blurRadius: 24,
                  ),
                ],
              ),
              textDirection: TextDirection.rtl,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Container(
              height: 1,
              margin: const EdgeInsets.symmetric(horizontal: 40),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    color.withOpacity(0.6),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                '"${entry.turkish}"',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  height: 1.7,
                  fontWeight: FontWeight.w300,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              entry.source,
              style: TextStyle(
                color: color.withOpacity(0.7),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            Text(
              '← kaydır →',
              style: const TextStyle(
                color: Colors.white24,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDots(int currentIdx) {
    const maxDots = 5;
    final total = _entries.length;
    final start =
        (currentIdx - maxDots ~/ 2).clamp(0, (total - maxDots).clamp(0, total));
    final end = (start + maxDots).clamp(0, total);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(end - start, (i) {
        final idx = start + i;
        final isActive = idx == currentIdx;
        final color = Color(_entries[currentIdx].color);
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 20 : 6,
          height: 6,
          decoration: BoxDecoration(
            color: isActive ? color : Colors.white24,
            borderRadius: BorderRadius.circular(3),
          ),
        );
      }),
    );
  }
}
