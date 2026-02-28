import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class DuaScreen extends StatelessWidget {
  const DuaScreen({super.key});

  static final List<Map<String, String>> _dualar = [
    {
      'title': 'Sabah Duası',
      'arabic': 'أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ',
      'turkish': 'Biz sabaha ulaştık, mülk de Allah\'a ait olarak sabaha ulaştı.',
      'source': 'Müslim',
    },
    {
      'title': 'Akşam Duası',
      'arabic': 'أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ',
      'turkish': 'Biz akşama ulaştık, mülk de Allah\'a ait olarak akşama ulaştı.',
      'source': 'Müslim',
    },
    {
      'title': 'Sıkıntı Duası',
      'arabic': 'لَا إِلَهَ إِلَّا أَنْتَ سُبْحَانَكَ إِنِّي كُنْتُ مِنَ الظَّالِمِينَ',
      'turkish': 'Senden başka ilah yoktur. Seni tenzih ederim. Gerçekten ben zalimlerden oldum.',
      'source': 'Enbiya, 87',
    },
    {
      'title': 'Huzur Duası',
      'arabic': 'رَبِّ اشْرَحْ لِي صَدْرِي وَيَسِّرْ لِي أَمْرِي',
      'turkish': 'Rabbim! Göğsümü aç, işimi kolaylaştır.',
      'source': 'Taha, 25-26',
    },
    {
      'title': 'Kaygı & Stres Duası',
      'arabic': 'اللَّهُمَّ إِنِّي أَعُوذُ بِكَ مِنَ الْهَمِّ وَالْحَزَنِ',
      'turkish': 'Allah\'ım! Sıkıntıdan ve üzüntüden sana sığınırım.',
      'source': 'Buhari',
    },
    {
      'title': 'Uyku Öncesi',
      'arabic': 'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا',
      'turkish': 'Allah\'ım! Senin adınla ölür ve dirilirim.',
      'source': 'Buhari',
    },
    {
      'title': 'Şükür Duası',
      'arabic': 'الْحَمْدُ لِلَّهِ الَّذِي أَحْيَانَا بَعْدَ مَا أَمَاتَنَا',
      'turkish': 'Bizi öldürdükten sonra dirilten Allah\'a hamd olsun.',
      'source': 'Buhari',
    },
    {
      'title': 'Sabır Duası',
      'arabic': 'رَبَّنَا أَفْرِغْ عَلَيْنَا صَبْرًا وَتَوَفَّنَا مُسْلِمِينَ',
      'turkish': 'Rabbimiz! Üzerimize sabır yağdır ve bizi Müslüman olarak öldür.',
      'source': 'A\'raf, 126',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dua & Zikir')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _dualar.length,
        itemBuilder: (context, index) {
          final dua = _dualar[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ExpansionTile(
              leading: Icon(Icons.menu_book, color: AppColors.primary),
              title: Text(dua['title']!,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(dua['source']!,
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        dua['arabic']!,
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
                        dua['turkish']!,
                        style: const TextStyle(fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(Icons.favorite_border,
                                color: AppColors.accent),
                            onPressed: () {
                              // TODO: Save to favorites
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.share, color: AppColors.primary),
                            onPressed: () {
                              // TODO: Share dua
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
        },
      ),
    );
  }
}
