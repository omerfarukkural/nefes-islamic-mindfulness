import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/tesbihat_data.dart';

final _countProvider = StateProvider<int>((ref) => 0);
final _selectedZikirProvider = StateProvider<int>((ref) => 0);
final _totalTodayProvider = StateProvider<int>((ref) => 0);

class TesbihatScreen extends ConsumerStatefulWidget {
  const TesbihatScreen({super.key});

  @override
  ConsumerState<TesbihatScreen> createState() => _TesbihatScreenState();
}

class _TesbihatScreenState extends ConsumerState<TesbihatScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseCtrl;
  late AnimationController _beadCtrl;
  late Animation<double> _pulseAnim;
  late Animation<double> _beadAnim;
  bool _showCompletion = false;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _beadCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _pulseAnim = Tween<double>(begin: 1.0, end: 0.93).animate(
      CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut),
    );
    _beadAnim = CurvedAnimation(parent: _beadCtrl, curve: Curves.elasticOut);
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _beadCtrl.dispose();
    super.dispose();
  }

  void _onTap() {
    final idx = ref.read(_selectedZikirProvider);
    final entry = defaultZikirler[idx];
    final current = ref.read(_countProvider);
    final newCount = current + 1;

    TesbihatService.haptic();
    _pulseCtrl.forward().then((_) => _pulseCtrl.reverse());
    _beadCtrl.forward(from: 0);

    ref.read(_countProvider.notifier).state = newCount;
    ref.read(_totalTodayProvider.notifier).state++;

    if (newCount >= entry.targetCount) {
      _onComplete();
    }
  }

  void _onComplete() {
    TesbihatService.hapticSuccess();
    setState(() => _showCompletion = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _showCompletion = false);
        ref.read(_countProvider.notifier).state = 0;
      }
    });
  }

  void _reset() {
    ref.read(_countProvider.notifier).state = 0;
    setState(() => _showCompletion = false);
  }

  void _selectZikir(int idx) {
    ref.read(_selectedZikirProvider.notifier).state = idx;
    ref.read(_countProvider.notifier).state = 0;
    setState(() => _showCompletion = false);
  }

  @override
  Widget build(BuildContext context) {
    final idx = ref.watch(_selectedZikirProvider);
    final count = ref.watch(_countProvider);
    final totalToday = ref.watch(_totalTodayProvider);
    final entry = defaultZikirler[idx];
    final progress = count / entry.targetCount;
    final bgColor = Color(entry.color);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Gradient background
          AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0, -0.3),
                radius: 1.2,
                colors: [
                  bgColor.withOpacity(0.6),
                  Colors.black,
                ],
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                _buildTopBar(context, totalToday),
                Expanded(child: _buildMainCounter(entry, count, progress)),
                _buildZikirSelector(idx),
                const SizedBox(height: 16),
              ],
            ),
          ),

          // Completion overlay
          if (_showCompletion) _buildCompletionOverlay(entry),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context, int totalToday) {
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
                '$totalToday',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'bugün',
                style: TextStyle(color: Colors.white54, fontSize: 11),
              ),
            ],
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: _reset,
            icon: const Icon(Icons.refresh, color: Colors.white54),
          ),
        ],
      ),
    );
  }

  Widget _buildMainCounter(
    TesbihatEntry entry,
    int count,
    double progress,
  ) {
    final bgColor = Color(entry.color);
    return GestureDetector(
      onTap: _onTap,
      child: AnimatedBuilder(
        animation: _pulseAnim,
        builder: (context, child) {
          return Transform.scale(
            scale: _pulseAnim.value,
            child: child,
          );
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Arabic text
              Text(
                entry.arabic,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.w600,
                  shadows: [
                    Shadow(
                      color: bgColor.withOpacity(0.8),
                      blurRadius: 20,
                    ),
                  ],
                ),
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                entry.transliteration,
                style: const TextStyle(color: Colors.white60, fontSize: 14),
              ),
              const SizedBox(height: 48),

              // Circular bead counter
              SizedBox(
                width: 240,
                height: 240,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Background ring
                    CustomPaint(
                      size: const Size(240, 240),
                      painter: _BeadRingPainter(
                        progress: progress,
                        count: entry.targetCount,
                        color: bgColor,
                        currentBead: count,
                      ),
                    ),

                    // Count display
                    AnimatedBuilder(
                      animation: _beadAnim,
                      builder: (context, _) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '$count',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 72,
                                fontWeight: FontWeight.w200,
                                height: 1,
                                shadows: [
                                  Shadow(
                                    color: bgColor,
                                    blurRadius: 24 * _beadAnim.value,
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '/ ${entry.targetCount}',
                              style: const TextStyle(
                                color: Colors.white38,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),
              Text(
                entry.turkish,
                style: const TextStyle(color: Colors.white60, fontSize: 13),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Ekrana dokun',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildZikirSelector(int selectedIdx) {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: defaultZikirler.length,
        itemBuilder: (context, i) {
          final z = defaultZikirler[i];
          final isSelected = i == selectedIdx;
          final color = Color(z.color);
          return GestureDetector(
            onTap: () => _selectZikir(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(
                        colors: [color, color.withOpacity(0.6)],
                      )
                    : null,
                color: isSelected ? null : Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? color : Colors.white12,
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    z.transliteration,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.white60,
                      fontSize: 13,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                  Text(
                    '× ${z.targetCount}',
                    style: TextStyle(
                      color: isSelected ? Colors.white70 : Colors.white30,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCompletionOverlay(TesbihatEntry entry) {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('✨', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            Text(
              '${entry.targetCount} kez tamamlandı',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              entry.transliteration,
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

class _BeadRingPainter extends CustomPainter {
  final double progress;
  final int count;
  final Color color;
  final int currentBead;

  _BeadRingPainter({
    required this.progress,
    required this.count,
    required this.color,
    required this.currentBead,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 16;
    final beadCount = math.min(count, 99);
    final beadRadius =
        math.min(6.0, (2 * math.pi * radius) / (beadCount * 2.4));

    // Draw track
    final trackPaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, radius, trackPaint);

    // Draw beads
    for (int i = 0; i < beadCount; i++) {
      final angle = (i / beadCount) * 2 * math.pi - math.pi / 2;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      final isCounted = i <
          (currentBead % beadCount == 0 && currentBead > 0
              ? beadCount
              : currentBead % beadCount);

      final beadPaint = Paint()
        ..color = isCounted ? color : Colors.white.withOpacity(0.15)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(x, y), beadRadius, beadPaint);

      if (isCounted) {
        final glowPaint = Paint()
          ..color = color.withOpacity(0.4)
          ..style = PaintingStyle.fill
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
        canvas.drawCircle(Offset(x, y), beadRadius + 2, glowPaint);
      }
    }
  }

  @override
  bool shouldRepaint(_BeadRingPainter old) =>
      old.currentBead != currentBead || old.progress != progress;
}
