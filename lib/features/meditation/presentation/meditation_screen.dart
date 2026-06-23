import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/offline_storage_service.dart';

class MeditationScreen extends StatefulWidget {
  const MeditationScreen({super.key});

  @override
  State<MeditationScreen> createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen>
    with TickerProviderStateMixin {
  int _selectedMinutes = 5;
  bool _isRunning = false;
  bool _isPaused = false;
  int _remainingSeconds = 0;
  int _totalSeconds = 0;
  Timer? _timer;
  String _selectedType = 'Nefes Egzersizi';

  late AnimationController _breatheController;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  final List<Map<String, dynamic>> _meditationTypes = [
    {
      'title': 'Nefes Egzersizi',
      'icon': Icons.air,
      'duration': 5,
      'color': AppColors.primary,
      'desc': 'Nefes alıp vererek zihni sakinleştir',
    },
    {
      'title': 'Tefekkür',
      'icon': Icons.visibility_rounded,
      'duration': 10,
      'color': const Color(0xFF1565C0),
      'desc': 'Derin düşünce ve iç gözlem',
    },
    {
      'title': 'Şükür Meditasyonu',
      'icon': Icons.favorite_rounded,
      'duration': 7,
      'color': const Color(0xFFAD1457),
      'desc': 'Allah\'ın nimetlerine şükret',
    },
    {
      'title': 'Sabır Pratiği',
      'icon': Icons.spa_rounded,
      'duration': 10,
      'color': const Color(0xFF558B2F),
      'desc': 'Sabır ve tevekkülü pekiştir',
    },
    {
      'title': 'Uyku Rahatlama',
      'icon': Icons.bedtime_rounded,
      'duration': 15,
      'color': const Color(0xFF4527A0),
      'desc': 'Gece huzurla uyu',
    },
    {
      'title': 'Stres Azaltma',
      'icon': Icons.self_improvement,
      'duration': 10,
      'color': const Color(0xFF00695C),
      'desc': 'Gerginliği bırak, huzur bul',
    },
  ];

  @override
  void initState() {
    super.initState();
    _breatheController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _pulseAnim = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _breatheController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _startMeditation({String? type, int? minutes}) {
    if (type != null) setState(() => _selectedType = type);
    final mins = minutes ?? _selectedMinutes;
    setState(() {
      _isRunning = true;
      _isPaused = false;
      _remainingSeconds = mins * 60;
      _totalSeconds = mins * 60;
    });
    _breatheController.repeat(reverse: true);
    _runTimer();
  }

  void _runTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0 && !_isPaused) {
        setState(() => _remainingSeconds--);
      } else if (_remainingSeconds == 0) {
        _completeMeditation();
      }
    });
  }

  void _togglePause() {
    setState(() => _isPaused = !_isPaused);
    if (_isPaused) {
      _breatheController.stop();
    } else {
      _breatheController.repeat(reverse: true);
    }
  }

  void _stopMeditation() {
    _timer?.cancel();
    _breatheController.stop();
    setState(() {
      _isRunning = false;
      _isPaused = false;
    });
  }

  Future<void> _completeMeditation() async {
    _timer?.cancel();
    _breatheController.stop();
    final completedMinutes = _totalSeconds ~/ 60;
    await OfflineStorageService.saveMeditationSession({
      'type': _selectedType,
      'duration_minutes': completedMinutes,
      'date': DateTime.now().toIso8601String(),
    });
    if (mounted) {
      setState(() => _isRunning = false);
      _showCompletionDialog(completedMinutes);
    }
  }

  void _showCompletionDialog(int minutes) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🎉', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 12),
            const Text(
              'Tebrikler!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 8),
            Text(
              '$minutes dakika $_selectedType tamamladın.',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Harika!'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meditasyon'),
      ),
      body: _isRunning ? _buildTimerView() : _buildSelectionView(),
    );
  }

  Widget _buildSelectionView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Süre Seç',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [3, 5, 7, 10, 15, 20].map((min) {
              final selected = _selectedMinutes == min;
              return ChoiceChip(
                label: Text('$min dk'),
                selected: selected,
                onSelected: (v) {
                  if (v) setState(() => _selectedMinutes = min);
                },
                selectedColor: AppColors.primary,
                labelStyle: TextStyle(
                  color: selected ? Colors.white : null,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          Text(
            'Meditasyon Türü',
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          ...(_meditationTypes.map((type) {
            final color = type['color'] as Color;
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).cardTheme.color,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: color.withOpacity(0.2),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(type['icon'] as IconData, color: color, size: 24),
                ),
                title: Text(
                  type['title'] as String,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                subtitle: Text(
                  '${type['desc']}  •  ${type['duration']} dk',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                trailing: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color, color.withOpacity(0.7)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.play_arrow_rounded,
                      color: Colors.white, size: 22),
                ),
                onTap: () => _startMeditation(
                  type: type['title'] as String,
                  minutes: type['duration'] as int,
                ),
              ),
            );
          })),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _startMeditation(),
              icon: const Icon(Icons.play_circle_filled),
              label: Text('$_selectedMinutes dk Serbest Meditasyon'),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildTimerView() {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;
    final progress =
        _totalSeconds > 0 ? 1 - (_remainingSeconds / _totalSeconds) : 0.0;
    final isExhale = _breatheController.value >= 0.5;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primary.withOpacity(0.05),
            Theme.of(context).scaffoldBackgroundColor,
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            _selectedType,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 40),
          // Breathing circle
          AnimatedBuilder(
            animation: _breatheController,
            builder: (context, child) {
              final scale = 1.0 + (_breatheController.value * 0.3);
              final opacity = 0.15 + (_breatheController.value * 0.35);
              return Stack(
                alignment: Alignment.center,
                children: [
                  // Outer glow
                  Container(
                    width: 220 * scale,
                    height: 220 * scale,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withOpacity(opacity * 0.4),
                    ),
                  ),
                  // Progress ring
                  SizedBox(
                    width: 220,
                    height: 220,
                    child: CustomPaint(
                      painter: _ArcPainter(progress: progress),
                    ),
                  ),
                  // Inner circle
                  Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.primary.withOpacity(opacity),
                          AppColors.primary.withOpacity(opacity * 0.6),
                        ],
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isExhale ? 'Nefes Ver' : 'Nefes Al',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 48),
          // Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildControlButton(
                icon: Icons.stop_rounded,
                color: Colors.red.shade400,
                onTap: _stopMeditation,
                label: 'Bitir',
              ),
              const SizedBox(width: 24),
              _buildControlButton(
                icon:
                    _isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                color: AppColors.primary,
                onTap: _togglePause,
                label: _isPaused ? 'Devam' : 'Duraklat',
                large: true,
              ),
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    required String label,
    bool large = false,
  }) {
    final size = large ? 72.0 : 56.0;
    return Column(
      children: [
        ScaleTransition(
          scale: large ? _pulseAnim : const AlwaysStoppedAnimation(1.0),
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 2),
              ),
              child: Icon(icon, color: color, size: large ? 34 : 26),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _ArcPainter extends CustomPainter {
  final double progress;

  _ArcPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 4;

    // Background arc
    final bgPaint = Paint()
      ..color = AppColors.primary.withOpacity(0.1)
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    final paint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_ArcPainter old) => old.progress != progress;
}
