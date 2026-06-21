import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/offline_storage_service.dart';
import '../domain/dream_symbols.dart';

class GunlukYeniScreen extends StatefulWidget {
  const GunlukYeniScreen({super.key});

  @override
  State<GunlukYeniScreen> createState() => _GunlukYeniScreenState();
}

class _GunlukYeniScreenState extends State<GunlukYeniScreen> {
  final _titleCtrl = TextEditingController();
  final _contentCtrl = TextEditingController();
  String _selectedMood = '😌';
  final Set<String> _selectedSymbols = {};
  bool _saving = false;
  String _symbolSearch = '';

  final List<String> _moods = ['😌', '😊', '😰', '😢', '😡', '🤔', '😇', '😨'];

  @override
  void dispose() {
    _titleCtrl.dispose();
    _contentCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_contentCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Rüya içeriği boş olamaz')),
      );
      return;
    }
    setState(() => _saving = true);
    try {
      final now = DateTime.now();
      await OfflineStorageService.saveDreamEntry({
        'title': _titleCtrl.text.trim().isEmpty ? 'Rüya' : _titleCtrl.text.trim(),
        'content': _contentCtrl.text.trim(),
        'mood': _selectedMood,
        'symbols': _selectedSymbols.toList(),
        'date': '${now.day}/${now.month}/${now.year}',
        'created_at': now.toIso8601String(),
      });
      if (mounted) context.pop();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  List<DreamSymbol> get _filteredSymbols {
    if (_symbolSearch.isEmpty) return dreamSymbols;
    return searchDreamSymbols(_symbolSearch);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yeni Rüya'),
        actions: [
          TextButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(
                    width: 20, height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Kaydet', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionLabel('📝 Başlık'),
            const SizedBox(height: 8),
            TextField(
              controller: _titleCtrl,
              decoration: const InputDecoration(hintText: 'Rüyaya bir isim ver...'),
            ),
            const SizedBox(height: 20),
            _buildSectionLabel('🌙 Rüya İçeriği *'),
            const SizedBox(height: 8),
            TextField(
              controller: _contentCtrl,
              maxLines: 6,
              decoration: const InputDecoration(
                hintText: 'Rüyanda ne gördün? Mümkün olduğunca detaylı yaz...',
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 20),
            _buildSectionLabel('😌 Rüya Sonrası His'),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: _moods.map((mood) {
                final selected = _selectedMood == mood;
                return GestureDetector(
                  onTap: () => setState(() => _selectedMood = mood),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: selected
                          ? Theme.of(context).colorScheme.primary.withOpacity(0.15)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).dividerColor,
                      ),
                    ),
                    child: Text(mood, style: const TextStyle(fontSize: 24)),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            _buildSectionLabel('🔍 Sembolleri İşaretle'),
            const SizedBox(height: 8),
            TextField(
              onChanged: (v) => setState(() => _symbolSearch = v),
              decoration: const InputDecoration(
                hintText: 'Sembol ara... (Su, Kuş, Ev...)',
                prefixIcon: Icon(Icons.search_rounded),
                isDense: true,
              ),
            ),
            const SizedBox(height: 10),
            if (_selectedSymbols.isNotEmpty) ...[
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: _selectedSymbols.map((s) {
                  return GestureDetector(
                    onTap: () => setState(() => _selectedSymbols.remove(s)),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: Theme.of(context).colorScheme.primary.withOpacity(0.4)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(s, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                          const SizedBox(width: 4),
                          const Icon(Icons.close, size: 12),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 10),
            ],
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _filteredSymbols.take(30).map((symbol) {
                final selected = _selectedSymbols.contains(symbol.symbol);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      if (selected) {
                        _selectedSymbols.remove(symbol.symbol);
                      } else {
                        _selectedSymbols.add(symbol.symbol);
                      }
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: selected
                          ? const Color(0xFF37474F).withOpacity(0.15)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: selected
                            ? const Color(0xFF37474F)
                            : Theme.of(context).dividerColor,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(symbol.emoji, style: const TextStyle(fontSize: 14)),
                        const SizedBox(width: 4),
                        Text(
                          symbol.symbol,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saving ? null : _save,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text(
                  'Rüyayı Kaydet',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
    );
  }
}
