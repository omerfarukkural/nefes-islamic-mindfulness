import 'package:flutter/services.dart';

class TesbihatEntry {
  final String arabic;
  final String turkish;
  final String transliteration;
  final int targetCount;
  final int color;

  const TesbihatEntry({
    required this.arabic,
    required this.turkish,
    required this.transliteration,
    required this.targetCount,
    required this.color,
  });
}

const List<TesbihatEntry> defaultZikirler = [
  TesbihatEntry(
    arabic: 'سُبْحَانَ اللّٰهِ',
    turkish: 'Allah\'ı tüm eksikliklerden tenzih ederim',
    transliteration: 'Sübhânallah',
    targetCount: 33,
    color: 0xFF1B5E20,
  ),
  TesbihatEntry(
    arabic: 'اَلْحَمْدُ لِلّٰهِ',
    turkish: 'Hamd Allah\'a mahsustur',
    transliteration: 'Elhamdülillah',
    targetCount: 33,
    color: 0xFF1A237E,
  ),
  TesbihatEntry(
    arabic: 'اَللّٰهُ أَكْبَرُ',
    turkish: 'Allah her şeyden büyüktür',
    transliteration: 'Allahu Ekber',
    targetCount: 33,
    color: 0xFF4A148C,
  ),
  TesbihatEntry(
    arabic: 'لَا إِلٰهَ إِلَّا اللّٰهُ',
    turkish: 'Allah\'tan başka ilah yoktur',
    transliteration: 'Lâ ilâhe illallâh',
    targetCount: 100,
    color: 0xFF880E4F,
  ),
  TesbihatEntry(
    arabic: 'اَللّٰهُمَّ صَلِّ عَلٰى مُحَمَّدٍ',
    turkish: 'Allah\'ım Muhammed\'e salat eyle',
    transliteration: 'Allâhümme salli alâ Muhammed',
    targetCount: 100,
    color: 0xFF01579B,
  ),
  TesbihatEntry(
    arabic: 'أَسْتَغْفِرُ اللّٰهَ',
    turkish: 'Allah\'tan mağfiret dilerim',
    transliteration: 'Estağfirullah',
    targetCount: 33,
    color: 0xFF006064,
  ),
  TesbihatEntry(
    arabic: 'يَا حَيُّ يَا قَيُّومُ',
    turkish: 'Ey Diri olan, ey Kaim olan',
    transliteration: 'Yâ Hayyu yâ Kayyûm',
    targetCount: 40,
    color: 0xFF3E2723,
  ),
  TesbihatEntry(
    arabic: 'حَسْبُنَا اللّٰهُ وَنِعْمَ الْوَكِيلُ',
    turkish: 'Allah bize yeter, O ne güzel vekildir',
    transliteration: 'Hasbunallahu ve ni\'mel vekîl',
    targetCount: 40,
    color: 0xFF37474F,
  ),
];

class TesbihatService {
  static void haptic() {
    HapticFeedback.lightImpact();
  }

  static void hapticMedium() {
    HapticFeedback.mediumImpact();
  }

  static void hapticSuccess() {
    HapticFeedback.heavyImpact();
  }
}
