import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/offline_storage_service.dart';

class DuaScreen extends StatefulWidget {
  const DuaScreen({super.key});

  @override
  State<DuaScreen> createState() => _DuaScreenState();
}

class _DuaScreenState extends State<DuaScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  static const List<Map<String, String>> _dualar = [
    {
      'title': 'Sabah Duası',
      'arabic': 'أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ',
      'turkish':
          'Biz sabaha ulaştık, mülk de Allah\'a ait olarak sabaha ulaştı.',
      'transliteration': 'Asbahna ve asbahal-mülkü lillah.',
      'source': 'Müslim',
      'category': 'Günlük',
    },
    {
      'title': 'Akşam Duası',
      'arabic': 'أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ',
      'turkish':
          'Biz akşama ulaştık, mülk de Allah\'a ait olarak akşama ulaştı.',
      'transliteration': 'Emseyna ve emseyal-mülkü lillah.',
      'source': 'Müslim',
      'category': 'Günlük',
    },
    {
      'title': 'Sıkıntı Duası',
      'arabic':
          'لَا إِلَهَ إِلَّا أَنْتَ سُبْحَانَكَ إِنِّي كُنْتُ مِنَ الظَّالِمِينَ',
      'turkish':
          'Senden başka ilah yoktur. Seni tenzih ederim. Gerçekten ben zalimlerden oldum.',
      'transliteration':
          'La ilahe illa ente sübhaneke inni küntü minezzalimin.',
      'source': 'Enbiya, 87',
      'category': 'Dua',
    },
    {
      'title': 'Huzur Duası',
      'arabic': 'رَبِّ اشْرَحْ لِي صَدْرِي وَيَسِّرْ لِي أَمْرِي',
      'turkish': 'Rabbim! Göğsümü aç, işimi kolaylaştır.',
      'transliteration': 'Rabbi\'şrah li sadri ve yessir li emri.',
      'source': 'Taha, 25-26',
      'category': 'Dua',
    },
    {
      'title': 'Kaygı & Stres Duası',
      'arabic': 'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْهَمِّ وَالْحَزَنِ',
      'turkish': 'Allah\'ım! Sıkıntıdan ve üzüntüden sana sığınırım.',
      'transliteration': 'Allahumme inni euzü bike minel hemmi vel hazen.',
      'source': 'Buhari',
      'category': 'Dua',
    },
    {
      'title': 'Uyku Öncesi',
      'arabic': 'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا',
      'turkish': 'Allah\'ım! Senin adınla ölür ve dirilirim.',
      'transliteration': 'Bismikellahümme emutü ve ahya.',
      'source': 'Buhari',
      'category': 'Günlük',
    },
    {
      'title': 'Şükür Duası',
      'arabic': 'الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا',
      'turkish': 'Bizi öldürdükten sonra dirilten Allah\'a hamd olsun.',
      'transliteration': 'Elhamdüllillahillezi ahyana bade ma ematena.',
      'source': 'Buhari',
      'category': 'Günlük',
    },
    {
      'title': 'Sabır Duası',
      'arabic': 'رَبَّنَا أَفْرِغْ عَلَيْنَا صَبْرًا وَتَوَفَّنَا مُسْلِمِينَ',
      'turkish':
          'Rabbimiz! Üzerimize sabır yağdır ve bizi Müslüman olarak öldür.',
      'transliteration': 'Rabbena efrığ aleyna sabran ve teveffena müslimin.',
      'source': 'A\'raf, 126',
      'category': 'Dua',
    },
  ];

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
        title: const Text('Dua & Zikir'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          indicatorColor: AppColors.accent,
          indicatorWeight: 3,
          tabs: const [
            Tab(text: 'Dualar', icon: Icon(Icons.menu_book_rounded, size: 18)),
            Tab(
                text: 'Zikir',
                icon: Icon(Icons.radio_button_checked, size: 18)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _DualarTab(dualar: _dualar),
          const _ZikirTab(),
        ],
      ),
    );
  }
}

// ── Dualar Tab ──────────────────────────────────────────────────────────────

class _DualarTab extends StatefulWidget {
  final List<Map<String, String>> dualar;
  const _DualarTab({required this.dualar});

  @override
  State<_DualarTab> createState() => _DualarTabState();
}

class _DualarTabState extends State<_DualarTab> {
  Set<String> _favorites = {};
  String _filter = 'Tümü';

  @override
  void initState() {
    super.initState();
    _favorites = OfflineStorageService.getFavoriteDuas().toSet();
  }

  Future<void> _toggleFavorite(String title) async {
    await OfflineStorageService.toggleDuaFavorite(title);
    setState(() {
      if (_favorites.contains(title)) {
        _favorites.remove(title);
      } else {
        _favorites.add(title);
      }
    });
  }

  List<Map<String, String>> get _filtered {
    if (_filter == 'Favoriler') {
      return widget.dualar
          .where((d) => _favorites.contains(d['title']))
          .toList();
    }
    return widget.dualar;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
          child: Row(
            children: ['Tümü', 'Favoriler'].map((f) {
              final selected = _filter == f;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(f),
                  selected: selected,
                  onSelected: (_) => setState(() => _filter = f),
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(
                    color: selected ? Colors.white : null,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        Expanded(
          child: _filtered.isEmpty
              ? const Center(
                  child: Text(
                    '❤️\nHenüz favori eklemedin.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                  itemCount: _filtered.length,
                  itemBuilder: (context, index) =>
                      _buildDuaCard(_filtered[index]),
                ),
        ),
      ],
    );
  }

  Widget _buildDuaCard(Map<String, String> dua) {
    final isFav = _favorites.contains(dua['title']);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.menu_book_rounded,
              color: AppColors.primary, size: 20),
        ),
        title: Text(dua['title']!,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
        subtitle: Row(
          children: [
            Icon(Icons.bookmark_outline, size: 12, color: Colors.grey.shade500),
            const SizedBox(width: 4),
            Text(
              dua['source']!,
              style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
            ),
          ],
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        collapsedShape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primary.withOpacity(0.05),
                        AppColors.accent.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border:
                        Border.all(color: AppColors.accent.withOpacity(0.2)),
                  ),
                  child: Text(
                    dua['arabic']!,
                    style: AppTheme.arabicTextStyle(
                      fontSize: 22,
                      color: AppColors.primary,
                    ),
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  dua['turkish']!,
                  style: const TextStyle(fontSize: 14, height: 1.5),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  dua['transliteration']!,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _ActionBtn(
                      icon: isFav
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: isFav ? Colors.red : AppColors.accent,
                      label: isFav ? 'Favoride' : 'Favori',
                      onTap: () => _toggleFavorite(dua['title']!),
                    ),
                    const SizedBox(width: 12),
                    _ActionBtn(
                      icon: Icons.copy_rounded,
                      color: AppColors.primary,
                      label: 'Kopyala',
                      onTap: () {
                        Clipboard.setData(ClipboardData(
                          text:
                              '${dua['arabic']}\n\n${dua['turkish']}\n\nKaynak: ${dua['source']}',
                        ));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Dua kopyalandı!')),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Zikir Tab ───────────────────────────────────────────────────────────────

class _ZikirTab extends StatefulWidget {
  const _ZikirTab();

  @override
  State<_ZikirTab> createState() => _ZikirTabState();
}

class _ZikirTabState extends State<_ZikirTab> with TickerProviderStateMixin {
  int _count = 0;
  String _selectedZikir = 'Sübhanallah';
  int _target = 33;

  late AnimationController _bounceController;
  late Animation<double> _bounceAnim;

  final List<Map<String, dynamic>> _zikirler = [
    {'name': 'Sübhanallah', 'arabic': 'سبحان الله', 'target': 33},
    {'name': 'Elhamdülillah', 'arabic': 'الحمد لله', 'target': 33},
    {'name': 'Allahü Ekber', 'arabic': 'الله أكبر', 'target': 33},
    {'name': 'La ilahe illallah', 'arabic': 'لا إله إلا الله', 'target': 100},
    {'name': 'Estağfirullah', 'arabic': 'أستغفر الله', 'target': 70},
    {'name': 'Salavat', 'arabic': 'اللهم صل على محمد', 'target': 10},
  ];

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _bounceAnim = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  Future<void> _tap() async {
    HapticFeedback.lightImpact();
    await _bounceController.forward();
    await _bounceController.reverse();
    setState(() => _count++);
    if (_count == _target) {
      HapticFeedback.heavyImpact();
      _showTargetReached();
    }
  }

  void _reset() {
    HapticFeedback.mediumImpact();
    setState(() => _count = 0);
  }

  void _showTargetReached() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Text('🎉', style: TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            Text('$_target kez $_selectedZikir tamamlandı!'),
          ],
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _selectZikir(Map<String, dynamic> z) {
    setState(() {
      _selectedZikir = z['name'] as String;
      _target = z['target'] as int;
      _count = 0;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final progress = _target > 0 ? (_count % (_target + 1)) / _target : 0.0;
    final rounds = _count ~/ _target;
    final currentZ = _zikirler.firstWhere((z) => z['name'] == _selectedZikir);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          // Zikir selector
          GestureDetector(
            onTap: () => _showZikirSelector(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                gradient: AppColors.headerGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _selectedZikir,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          currentZ['arabic'] as String,
                          style: AppTheme.arabicTextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.swap_vert_rounded, color: Colors.white70),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          // Progress ring + count
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 220,
                height: 220,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 10,
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                  strokeCap: StrokeCap.round,
                ),
              ),
              Column(
                children: [
                  Text(
                    '$_count',
                    style: const TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    'Hedef: $_target',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  if (rounds > 0)
                    Text(
                      '$rounds tur tamamlandı ✓',
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 40),
          // Tap button
          ScaleTransition(
            scale: _bounceAnim,
            child: GestureDetector(
              onTap: _tap,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: AppColors.headerGradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.4),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: const Center(
                  child: Text('📿', style: TextStyle(fontSize: 42)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          TextButton.icon(
            onPressed: _reset,
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Sıfırla'),
            style: TextButton.styleFrom(
              foregroundColor: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  void _showZikirSelector() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Zikir Seç',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            ..._zikirler.map((z) => ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.radio_button_checked,
                        color: AppColors.primary, size: 20),
                  ),
                  title: Text(z['name'] as String,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(
                    '${z['arabic']}  •  Hedef: ${z['target']}',
                    style: TextStyle(color: Colors.grey.shade500),
                  ),
                  onTap: () => _selectZikir(z),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                )),
          ],
        ),
      ),
    );
  }
}
