import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/services/ebced_service.dart';

class EbcedScreen extends StatefulWidget {
  const EbcedScreen({super.key});

  @override
  State<EbcedScreen> createState() => _EbcedScreenState();
}

class _EbcedScreenState extends State<EbcedScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _arabicCtrl = TextEditingController();
  final _turkishCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();

  int? _arabicResult;
  int? _turkishResult;
  int? _dateResult;
  List<Map<String, dynamic>> _arabicDetailed = [];
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _updateDateText();
  }

  void _updateDateText() {
    _dateCtrl.text =
        '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}';
  }

  @override
  void dispose() {
    _tabController.dispose();
    _arabicCtrl.dispose();
    _turkishCtrl.dispose();
    _dateCtrl.dispose();
    super.dispose();
  }

  void _calculateArabic() {
    final text = _arabicCtrl.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _arabicResult = EbcedService.calculateEbced(text);
      _arabicDetailed = EbcedService.calculateEbcedDetailed(text);
    });
  }

  void _calculateTurkish() {
    final text = _turkishCtrl.text.trim();
    if (text.isEmpty) return;
    setState(() {
      final raw = EbcedService.calculateTurkishNumerology(text);
      _turkishResult = EbcedService.reduceToDigit(raw);
    });
  }

  void _calculateDate() {
    setState(() {
      _dateResult = EbcedService.calculateDateEbced(_selectedDate);
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      helpText: 'Tarih Seç',
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _updateDateText();
        _dateResult = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ebced Hesabı'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Arapça Harf'),
            Tab(text: 'Türkçe İsim'),
            Tab(text: 'Tarih'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildArabicTab(),
          _buildTurkishTab(),
          _buildDateTab(),
        ],
      ),
    );
  }

  Widget _buildArabicTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(
            '🔢 Ebced / Abjad Hesabı',
            'Her Arapça harfin kadim bir sayı değeri vardır. Bu hesap İslam geleneğinde isim, dua ve sure analizinde kullanılmıştır.',
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _arabicCtrl,
            textDirection: TextDirection.rtl,
            decoration: const InputDecoration(
              hintText: 'Arapça metin girin...',
              prefixIcon: Icon(Icons.translate_rounded),
            ),
            onChanged: (_) => setState(() {
              _arabicResult = null;
              _arabicDetailed = [];
            }),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _calculateArabic,
              child: const Text('Hesapla'),
            ),
          ),
          if (_arabicResult != null) ...[
            const SizedBox(height: 20),
            _buildResultCard(
              _arabicResult!,
              EbcedService.getEbcedMeaning(_arabicResult!),
              AppColors.accent,
            ),
            if (_arabicDetailed.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'Harf Detayları',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _arabicDetailed.map((item) {
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                      border:
                          Border.all(color: AppColors.accent.withOpacity(0.3)),
                    ),
                    child: Column(
                      children: [
                        Text(
                          item['letter'] as String,
                          style: AppTheme.arabicTextStyle(
                            fontSize: 22,
                            color: AppColors.accent,
                          ),
                        ),
                        Text(
                          '${item['value']}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildTurkishTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(
            '🔤 Türkçe İsim Numerolojisi',
            'Pitergoryan sisteme göre adapte edilmiş Türkçe harf-sayı eşleştirmesidir. İsminin özündeki enerjiyi keşfet.',
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _turkishCtrl,
            decoration: const InputDecoration(
              hintText: 'Türkçe isim veya kelime girin...',
              prefixIcon: Icon(Icons.person_rounded),
            ),
            textCapitalization: TextCapitalization.words,
            onChanged: (_) => setState(() => _turkishResult = null),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _calculateTurkish,
              child: const Text('Hesapla'),
            ),
          ),
          if (_turkishResult != null) ...[
            const SizedBox(height: 20),
            _buildResultCard(
              _turkishResult!,
              EbcedService.getNumberMeaning(_turkishResult!),
              AppColors.primary,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDateTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard(
            '📅 Tarih Ebcedi',
            'Seçtiğin tarihin sayısal değerini hesaplar ve o tarihin enerjisini İslami numeroloji perspektifinden yorumlar.',
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: _pickDate,
            child: AbsorbPointer(
              child: TextField(
                controller: _dateCtrl,
                decoration: const InputDecoration(
                  hintText: 'Tarih seçin',
                  prefixIcon: Icon(Icons.calendar_today_rounded),
                  suffixIcon: Icon(Icons.edit_rounded),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _calculateDate,
              child: const Text('Hesapla'),
            ),
          ),
          if (_dateResult != null) ...[
            const SizedBox(height: 20),
            _buildResultCard(
              _dateResult!,
              EbcedService.getEbcedMeaning(_dateResult!),
              const Color(0xFF6A1B9A),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String body) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.accent.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.accent.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style:
                Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard(int value, String meaning, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.8), color],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Sonuç',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    Text(
                      '$value',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.copy_rounded, color: Colors.white60),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: '$value'));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Kopyalandı')),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              meaning,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
