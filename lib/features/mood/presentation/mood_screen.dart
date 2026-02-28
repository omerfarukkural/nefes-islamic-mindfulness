import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class MoodScreen extends StatefulWidget {
  const MoodScreen({super.key});

  @override
  State<MoodScreen> createState() => _MoodScreenState();
}

class _MoodScreenState extends State<MoodScreen> {
  int? _selectedMood;
  final TextEditingController _noteController = TextEditingController();

  final List<Map<String, dynamic>> _moods = [
    {'emoji': '😊', 'label': 'Harika', 'value': 5, 'color': Colors.green},
    {'emoji': '🙂', 'label': 'İyi', 'value': 4, 'color': Colors.lightGreen},
    {'emoji': '😐', 'label': 'Normal', 'value': 3, 'color': Colors.amber},
    {'emoji': '😔', 'label': 'Kötü', 'value': 2, 'color': Colors.orange},
    {'emoji': '😢', 'label': 'Çok Kötü', 'value': 1, 'color': Colors.red},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ruh Hali Takibi')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Bugün Nasıl Hissediyorsun?',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: _moods.map((mood) {
                final isSelected = _selectedMood == mood['value'];
                return GestureDetector(
                  onTap: () => setState(() => _selectedMood = mood['value'] as int),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? (mood['color'] as Color).withOpacity(0.2)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(16),
                      border: isSelected
                          ? Border.all(color: mood['color'] as Color, width: 2)
                          : null,
                    ),
                    child: Column(
                      children: [
                        Text(mood['emoji'] as String,
                            style: TextStyle(fontSize: isSelected ? 40 : 32)),
                        const SizedBox(height: 4),
                        Text(mood['label'] as String,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            )),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            const Text('Not Ekle (İsteğe bağlı)',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextField(
              controller: _noteController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Bugün neler yaşadın? Ne hissediyorsun?',
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _selectedMood != null ? _saveMood : null,
                icon: const Icon(Icons.save),
                label: const Text('Kaydet'),
              ),
            ),
            const SizedBox(height: 32),
            const Text('Son 7 Gün',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildMoodHistory(),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodHistory() {
    // TODO: Load from offline storage
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Text('Henüz kayıt yok.\nİlk ruh hali kaydını oluştur!',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey)),
      ),
    );
  }

  void _saveMood() {
    // TODO: Save to offline storage via OfflineStorageService
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ruh halin kaydedildi! ✅'),
        backgroundColor: AppColors.primary,
      ),
    );
    setState(() {
      _selectedMood = null;
      _noteController.clear();
    });
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }
}
