import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/offline_storage_service.dart';

class DuaScreen extends StatefulWidget {
  const DuaScreen({super.key});

  @override
  State<DuaScreen> createState() => _DuaScreenState();
}

class _DuaScreenState extends State<DuaScreen> {
  List<Map<String, dynamic>> _dualar = [];
  Set<int> _favorites = {};
  bool _showFavoritesOnly = false;

  @override
  void initState() {
    super.initState();
    _loadDualar();
    _loadFavorites();
  }

  Future<void> _loadDualar() async {
    try {
      final data = await rootBundle.loadString('assets/data/dualar.json');
      final list = jsonDecode(data) as List;
      if (mounted) {
        setState(() {
          _dualar = list.map((e) => Map<String, dynamic>.from(e as Map)).toList();
        });
      }
    } catch (_) {
      // Yükleme başarısız olursa boş liste kalır
    }
  }

  void _loadFavorites() {
    try {
      final favs = OfflineStorageService.getDuaFavorites();
      setState(() {
        _favorites = Set<int>.from(favs);
      });
    } catch (_) {}
  }

  Future<void> _toggleFavorite(int duaId) async {
    await OfflineStorageService.toggleDuaFavorite(duaId);
    _loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    final displayList = _showFavoritesOnly
        ? _dualar.where((d) => _favorites.contains(d['id'] as int? ?? -1)).toList()
        : _dualar;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dua & Zikir'),
        actions: [
          IconButton(
            icon: Icon(
              _showFavoritesOnly ? Icons.favorite : Icons.favorite_border,
              color: _showFavoritesOnly ? AppColors.accent : null,
            ),
            tooltip: _showFavoritesOnly ? 'Tüm Dualar' : 'Favoriler',
            onPressed: () => setState(() => _showFavoritesOnly = !_showFavoritesOnly),
          ),
        ],
      ),
      body: _dualar.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : displayList.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.favorite_border,
                            size: 64, color: Colors.grey.shade400),
                        const SizedBox(height: 16),
                        const Text(
                          'Henüz favori dua yok.\nKalp ikonuna basarak favori ekle!',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: displayList.length,
                  itemBuilder: (context, index) {
                    final dua = displayList[index];
                    final duaId = dua['id'] as int? ?? index;
                    final isFav = _favorites.contains(duaId);

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ExpansionTile(
                        leading: Icon(Icons.menu_book, color: AppColors.primary),
                        title: Text(dua['title'] as String? ?? '',
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(
                          dua['source'] as String? ?? '',
                          style: TextStyle(
                              color: AppColors.textSecondary, fontSize: 12),
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                if (dua['arabic'] != null)
                                  Text(
                                    dua['arabic'] as String,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontFamily: 'Amiri',
                                      height: 2,
                                    ),
                                    textAlign: TextAlign.center,
                                    textDirection: TextDirection.rtl,
                                  ),
                                const Divider(height: 24),
                                Text(
                                  dua['turkish'] as String? ?? '',
                                  style: const TextStyle(fontSize: 14),
                                  textAlign: TextAlign.center,
                                ),
                                if (dua['transliteration'] != null) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    dua['transliteration'] as String,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                      fontStyle: FontStyle.italic,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                                const SizedBox(height: 12),
                                IconButton(
                                  icon: Icon(
                                    isFav
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: isFav ? Colors.red : AppColors.accent,
                                  ),
                                  tooltip:
                                      isFav ? 'Favorilerden Çıkar' : 'Favorilere Ekle',
                                  onPressed: () => _toggleFavorite(duaId),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
