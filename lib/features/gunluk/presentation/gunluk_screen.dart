import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/offline_storage_service.dart';
import '../domain/dream_symbols.dart';

class GunlukScreen extends StatefulWidget {
  const GunlukScreen({super.key});

  @override
  State<GunlukScreen> createState() => _GunlukScreenState();
}

class _GunlukScreenState extends State<GunlukScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _symbolSearch = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rüya Günlüğü'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Günlüğüm'),
            Tab(text: 'Sembol Sözlüğü'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await context.push('/gunluk/yeni');
          setState(() {});
        },
        child: const Icon(Icons.add_rounded),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildJournalTab(),
          _buildSymbolTab(),
        ],
      ),
    );
  }

  Widget _buildJournalTab() {
    final entries = OfflineStorageService.getDreamEntries();

    if (entries.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🌙', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 16),
            Text(
              'Henüz rüya kaydı yok',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Sabah uyandığında rüyalarını hemen kaydet.',
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () async {
                await context.push('/gunluk/yeni');
                setState(() {});
              },
              icon: const Icon(Icons.add_rounded),
              label: const Text('İlk Kaydı Oluştur'),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final entry = entries[index];
        return _buildDreamCard(context, entry, index);
      },
    );
  }

  Widget _buildDreamCard(
      BuildContext context, Map<String, dynamic> entry, int index) {
    final date = entry['date'] as String? ?? '';
    final title = entry['title'] as String? ?? 'Rüya';
    final content = entry['content'] as String? ?? '';
    final mood = entry['mood'] as String? ?? '';
    final symbols = (entry['symbols'] as List?)?.cast<String>() ?? [];

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF37474F).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text('🌙', style: TextStyle(fontSize: 18)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 15),
                      ),
                      Text(
                        date,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                if (mood.isNotEmpty)
                  Text(mood, style: const TextStyle(fontSize: 20)),
                PopupMenuButton<String>(
                  onSelected: (value) async {
                    if (value == 'delete') {
                      await OfflineStorageService.deleteDreamEntry(
                        OfflineStorageService.getDreamEntries().length -
                            1 -
                            index,
                      );
                      setState(() {});
                    }
                  },
                  itemBuilder: (_) => [
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline,
                              color: Colors.red, size: 18),
                          SizedBox(width: 8),
                          Text('Sil', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (content.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                content,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(height: 1.4, fontSize: 14),
              ),
            ],
            if (symbols.isNotEmpty) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                children: symbols.take(4).map((s) {
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF37474F).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(s, style: const TextStyle(fontSize: 12)),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSymbolTab() {
    final symbols = _symbolSearch.isEmpty
        ? dreamSymbols
        : searchDreamSymbols(_symbolSearch);

    final categories = dreamCategories;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: TextField(
            onChanged: (v) => setState(() => _symbolSearch = v),
            decoration: InputDecoration(
              hintText: 'Sembol ara...',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: _symbolSearch.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => setState(() => _symbolSearch = ''),
                    )
                  : null,
              isDense: true,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: symbols.length,
            itemBuilder: (context, index) {
              final symbol = symbols[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Theme(
                  data: Theme.of(context)
                      .copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    leading: Text(symbol.emoji,
                        style: const TextStyle(fontSize: 24)),
                    title: Text(
                      symbol.symbol,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 14),
                    ),
                    subtitle: Text(
                      symbol.category,
                      style: TextStyle(
                        fontSize: 11,
                        color: AppColors.accent,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildSymbolSection(
                              context,
                              '☪️ İslami Yorum',
                              symbol.islamicMeaning,
                              AppColors.accent,
                            ),
                            const SizedBox(height: 10),
                            _buildSymbolSection(
                              context,
                              '🔍 Genel Anlam',
                              symbol.generalMeaning,
                              AppColors.primary,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSymbolSection(
      BuildContext context, String title, String content, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.w700, fontSize: 12, color: color),
          ),
          const SizedBox(height: 4),
          Text(content, style: const TextStyle(fontSize: 13, height: 1.4)),
        ],
      ),
    );
  }
}
