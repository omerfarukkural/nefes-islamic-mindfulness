import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/offline_storage_service.dart';

class MoodScreen extends StatefulWidget {
  const MoodScreen({super.key});

  @override
  State<MoodScreen> createState() => _MoodScreenState();
}

class _MoodScreenState extends State<MoodScreen> {
  int? _selectedMood;
  final TextEditingController _noteController = TextEditingController();
  List<Map<String, dynamic>> _history = [];
  bool _saved = false;

  final List<Map<String, dynamic>> _moods = [
    {'emoji': '😊', 'label': 'Harika', 'value': 5, 'color': Color(0xFF2E7D32)},
    {'emoji': '🙂', 'label': 'İyi', 'value': 4, 'color': Color(0xFF558B2F)},
    {'emoji': '😐', 'label': 'Normal', 'value': 3, 'color': Color(0xFFF57F17)},
    {'emoji': '😔', 'label': 'Kötü', 'value': 2, 'color': Color(0xFFE65100)},
    {
      'emoji': '😢',
      'label': 'Çok Kötü',
      'value': 1,
      'color': Color(0xFFC62828)
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadHistory();
    _checkTodaySaved();
  }

  void _loadHistory() {
    setState(() {
      _history = OfflineStorageService.getMoodEntriesLastDays(7);
    });
  }

  void _checkTodaySaved() {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final todayEntry =
        _history.any((e) => (e['date'] as String).startsWith(today));
    if (todayEntry) setState(() => _saved = true);
  }

  Map<String, dynamic>? get _todayEntry {
    final today = DateTime.now().toIso8601String().substring(0, 10);
    try {
      return _history
          .firstWhere((e) => (e['date'] as String).startsWith(today));
    } catch (_) {
      return null;
    }
  }

  Future<void> _saveMood() async {
    if (_selectedMood == null) return;
    final moodData = _moods.firstWhere((m) => m['value'] == _selectedMood);
    await OfflineStorageService.saveMoodEntry({
      'value': _selectedMood,
      'emoji': moodData['emoji'],
      'label': moodData['label'],
      'note': _noteController.text.trim(),
      'date': DateTime.now().toIso8601String(),
    });
    _loadHistory();
    if (mounted) {
      setState(() => _saved = true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Text(moodData['emoji'] as String,
                  style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 10),
              const Text('Ruh halin kaydedildi!'),
            ],
          ),
        ),
      );
      setState(() {
        _selectedMood = null;
        _noteController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ruh Hali Takibi')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_saved && _todayEntry != null) _buildTodayBanner(),
            if (!_saved) ...[
              Text(
                'Bugün Nasıl Hissediyorsun?',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 20),
              _buildMoodPicker(),
              const SizedBox(height: 24),
              _buildNoteField(),
              const SizedBox(height: 20),
              _buildSaveButton(),
            ],
            const SizedBox(height: 32),
            _buildHistorySection(),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayBanner() {
    final entry = _todayEntry!;
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: AppColors.headerGradient,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Text(entry['emoji'] as String, style: const TextStyle(fontSize: 40)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Bugünkü kaydın var',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                Text(
                  '${entry['label']} hissediyorsun',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                if ((entry['note'] as String).isNotEmpty)
                  Text(
                    '"${entry['note']}"',
                    style: const TextStyle(
                      color: Colors.white60,
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodPicker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: _moods.map((mood) {
        final isSelected = _selectedMood == mood['value'];
        final color = mood['color'] as Color;
        return GestureDetector(
          onTap: () => setState(() => _selectedMood = mood['value'] as int),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isSelected ? color.withOpacity(0.15) : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              border: isSelected
                  ? Border.all(color: color, width: 2)
                  : Border.all(color: Colors.transparent, width: 2),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: color.withOpacity(0.2),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      )
                    ]
                  : [],
            ),
            child: Column(
              children: [
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(fontSize: isSelected ? 38 : 30),
                  child: Text(mood['emoji'] as String),
                ),
                const SizedBox(height: 4),
                Text(
                  mood['label'] as String,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                    color: isSelected ? color : null,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNoteField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Not Ekle (İsteğe Bağlı)',
          style: Theme.of(context)
              .textTheme
              .titleSmall
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _noteController,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'Bugün neler yaşadın? Ne hissediyorsun?',
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: _selectedMood != null ? _saveMood : null,
        icon: const Icon(Icons.check_rounded),
        label: const Text('Kaydet'),
      ),
    );
  }

  Widget _buildHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Son 7 Gün',
          style: Theme.of(context)
              .textTheme
              .titleMedium
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 16),
        if (_history.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  const Text('📊', style: TextStyle(fontSize: 48)),
                  const SizedBox(height: 12),
                  Text(
                    'Henüz kayıt yok.\nİlk ruh hali kaydını oluştur!',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                ],
              ),
            ),
          )
        else ...[
          _buildMoodChart(),
          const SizedBox(height: 16),
          ..._history.map((entry) => _buildHistoryItem(entry)),
        ],
      ],
    );
  }

  Widget _buildMoodChart() {
    final days = List.generate(7, (i) {
      final d = DateTime.now().subtract(Duration(days: 6 - i));
      final key = d.toIso8601String().substring(0, 10);
      final entry = _history.firstWhere(
        (e) => (e['date'] as String).startsWith(key),
        orElse: () => {},
      );
      return {'date': d, 'entry': entry.isEmpty ? null : entry};
    });

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: days.map((day) {
          final entry = day['entry'] as Map<String, dynamic>?;
          final date = day['date'] as DateTime;
          final value = entry != null ? (entry['value'] as int?) ?? 0 : 0;
          final emoji = entry?['emoji'] as String? ?? '⚪';
          final color = value > 0
              ? (_moods.firstWhere((m) => m['value'] == value)['color']
                  as Color)
              : Colors.grey.shade300;
          final weekLabel = ['Pzt', 'Sal', 'Çar', 'Per', 'Cum', 'Cmt', 'Paz'];

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 4),
              AnimatedContainer(
                duration: const Duration(milliseconds: 600),
                width: 24,
                height: value > 0 ? (value * 12.0) : 6,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                weekLabel[date.weekday - 1],
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildHistoryItem(Map<String, dynamic> entry) {
    final date = DateTime.tryParse(entry['date'] as String);
    final dateStr = date != null
        ? '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}'
        : '';
    final color = _moods.firstWhere(
      (m) => m['value'] == (entry['value'] as int?),
      orElse: () => {'color': Colors.grey},
    )['color'] as Color;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Text(entry['emoji'] as String? ?? '😐',
              style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry['label'] as String? ?? '',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
                if ((entry['note'] as String? ?? '').isNotEmpty)
                  Text(
                    entry['note'] as String,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          Text(
            dateStr,
            style:
                Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 10),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }
}
