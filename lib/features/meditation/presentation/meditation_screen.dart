import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class MeditationScreen extends StatefulWidget {
  const MeditationScreen({super.key});

  @override
  State<MeditationScreen> createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen>
    with TickerProviderStateMixin {
  int _selectedMinutes = 5;
  bool _isRunning = false;
  int _remainingSeconds = 0;
  Timer? _timer;
  late AnimationController _breatheController;

  final List<Map<String, dynamic>> _meditationTypes = [
    {'title': 'Nefes Egzersizi', 'icon': Icons.air, 'duration': 5},
    {'title': 'Tefekkür', 'icon': Icons.visibility, 'duration': 10},
    {'title': 'Şükür Meditasyonu', 'icon': Icons.favorite, 'duration': 7},
    {'title': 'Sabır Pratiği', 'icon': Icons.spa, 'duration': 10},
    {'title': 'Uyku Rahatlama', 'icon': Icons.bedtime, 'duration': 15},
    {'title': 'Stres Azaltma', 'icon': Icons.healing, 'duration': 10},
  ];

  @override
  void initState() {
    super.initState();
    _breatheController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _breatheController.dispose();
    super.dispose();
  }

  void _startMeditation() {
    setState(() {
      _isRunning = true;
      _remainingSeconds = _selectedMinutes * 60;
    });
    _breatheController.repeat(reverse: true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
      } else {
        _stopMeditation();
      }
    });
  }

  void _stopMeditation() {
    _timer?.cancel();
    _breatheController.stop();
    setState(() => _isRunning = false);
    // TODO: Save session to offline storage
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Meditasyon')),
      body: _isRunning ? _buildTimerView() : _buildSelectionView(),
    );
  }

  Widget _buildSelectionView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Süre Seç',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [3, 5, 7, 10, 15, 20].map((min) {
              return ChoiceChip(
                label: Text('$min dk'),
                selected: _selectedMinutes == min,
                onSelected: (selected) {
                  if (selected) setState(() => _selectedMinutes = min);
                },
                selectedColor: AppColors.primary,
                labelStyle: TextStyle(
                  color: _selectedMinutes == min ? Colors.white : null,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          const Text('Meditasyon Türü',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ...(_meditationTypes.map((type) => Card(
                child: ListTile(
                  leading: Icon(type['icon'] as IconData,
                      color: AppColors.primary, size: 32),
                  title: Text(type['title'] as String),
                  subtitle: Text('${type['duration']} dakika'),
                  trailing: const Icon(Icons.play_circle_filled,
                      color: AppColors.primary, size: 36),
                  onTap: () {
                    setState(() => _selectedMinutes = type['duration'] as int);
                    _startMeditation();
                  },
                ),
              ))),
        ],
      ),
    );
  }

  Widget _buildTimerView() {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _breatheController,
            builder: (context, child) {
              return Container(
                width: 200 + (_breatheController.value * 50),
                height: 200 + (_breatheController.value * 50),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary
                      .withOpacity(0.2 + (_breatheController.value * 0.3)),
                ),
                child: Center(
                  child: Text(
                    _breatheController.value < 0.5
                        ? 'Nefes Al...'
                        : 'Nefes Ver...',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 40),
          Text(
            '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
            style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 40),
          ElevatedButton.icon(
            onPressed: _stopMeditation,
            icon: const Icon(Icons.stop),
            label: const Text('Bitir'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade400,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }
}
