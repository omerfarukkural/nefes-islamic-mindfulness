import 'package:flutter/material.dart';

enum MizacType { dem, safra, balgam, sevda }

extension MizacTypeExt on MizacType {
  String get label {
    switch (this) {
      case MizacType.dem:
        return 'Dem (Kanlı)';
      case MizacType.safra:
        return 'Safra (Sinirli)';
      case MizacType.balgam:
        return 'Balgam (Ağırkanlı)';
      case MizacType.sevda:
        return 'Sevda (Melankolik)';
    }
  }

  String get element {
    switch (this) {
      case MizacType.dem:
        return 'Hava';
      case MizacType.safra:
        return 'Ateş';
      case MizacType.balgam:
        return 'Su';
      case MizacType.sevda:
        return 'Toprak';
    }
  }

  String get season {
    switch (this) {
      case MizacType.dem:
        return 'İlkbahar';
      case MizacType.safra:
        return 'Yaz';
      case MizacType.balgam:
        return 'Kış';
      case MizacType.sevda:
        return 'Sonbahar';
    }
  }

  String get emoji {
    switch (this) {
      case MizacType.dem:
        return '🌸';
      case MizacType.safra:
        return '🔥';
      case MizacType.balgam:
        return '💧';
      case MizacType.sevda:
        return '🍂';
    }
  }

  Color get color {
    switch (this) {
      case MizacType.dem:
        return const Color(0xFFE91E63);
      case MizacType.safra:
        return const Color(0xFFFF6F00);
      case MizacType.balgam:
        return const Color(0xFF0288D1);
      case MizacType.sevda:
        return const Color(0xFF5D4037);
    }
  }

  String get description {
    switch (this) {
      case MizacType.dem:
        return 'Sosyal, iyimser, enerjik ve neşeli. Kan baskın unsurun. Kalp ve akciğerlerinle özellikle ilgilen. İlkbaharın canlılığını taşırsın.';
      case MizacType.safra:
        return 'Kararlı, hızlı düşünen, lider ruhlu. Ateş baskın unsurun. Sindirim sisteminle ilgilen, aşırı ısınmadan kaçın. Yazın gücünü taşırsın.';
      case MizacType.balgam:
        return 'Sakin, sabırlı, uyumlu ve şefkatli. Su baskın unsurun. Bağışıklık sisteminle ilgilen, tembellikten kaçın. Kışın derinliğini taşırsın.';
      case MizacType.sevda:
        return 'Hassas, yaratıcı, analitik ve derin. Toprak baskın unsurun. Sinir sisteminle ilgilen, karamsarlıktan uzak dur. Sonbaharın zenginliğini taşırsın.';
    }
  }

  String get esma {
    switch (this) {
      case MizacType.dem:
        return 'Ya Latif (33)';
      case MizacType.safra:
        return 'Ya Sabur (298)';
      case MizacType.balgam:
        return 'Ya Hayy (18)';
      case MizacType.sevda:
        return 'Ya Şafi (506)';
    }
  }

  String get zikir {
    switch (this) {
      case MizacType.dem:
        return 'Elhamdülillah (100)';
      case MizacType.safra:
        return 'Sübhanallah (300)';
      case MizacType.balgam:
        return 'La ilahe illallah (100)';
      case MizacType.sevda:
        return 'Allahü Ekber (100)';
    }
  }

  List<String> get dietRecommendations {
    switch (this) {
      case MizacType.dem:
        return [
          'Tatlı ve ekşi tatları dengele',
          'Kuru üzüm, incir, bal faydalı',
          'Aşırı tuz ve şekerden kaçın',
          'Soğuk meyveler iyi gelir',
          'Hafif öğünler tercih et',
        ];
      case MizacType.safra:
        return [
          'Serin ve nemlendirici gıdalar tüket',
          'Salatalık, yoğurt, meyve suları iyi gelir',
          'Baharat ve kızartmadan kaçın',
          'Soğuk su ve bitki çayları içebilirsin',
          'Küçük ve sık öğünler daha iyi',
        ];
      case MizacType.balgam:
        return [
          'Sıcak ve kuru gıdalar tercih et',
          'Zencefil, hardal, tarçın faydalı',
          'Aşırı süt ve soğuk içeceklerden kaçın',
          'Hafif egzersiz öncesi ılık su iç',
          'Akşam yemeğini erken ye',
        ];
      case MizacType.sevda:
        return [
          'Sıcak, nemli ve hafif gıdalar tüket',
          'Zeytinyağı, bal, nar iyi gelir',
          'Kuru ve soğuk gıdaları azalt',
          'Lavanta çayı ve gül suyu faydalı',
          'Düzenli öğün saatlerine dikkat et',
        ];
    }
  }

  List<String> get sleepTips {
    switch (this) {
      case MizacType.dem:
        return [
          '7-8 saat ideal; geç saatlere dikkat',
          'Uyumadan önce kısa meditasyon yap',
          'Oda serin olmalı, sirkülasyon önemli',
        ];
      case MizacType.safra:
        return [
          '8-9 saat ihtiyacın var, erken yat',
          'Yataktan önce ılık duş al',
          'Karanlık ve serin ortamda uyu',
        ];
      case MizacType.balgam:
        return [
          'Çok uyuma! 6-7 saat yeterli',
          'Sabah erken kalk ve harekete geç',
          'Gündüz uykusundan kaçın',
        ];
      case MizacType.sevda:
        return [
          '8 saat düzenli uyku şart',
          'Yatmadan önce endişe günlüğü tut',
          'Lavanta kokusu veya ılık süt rahatlatır',
        ];
    }
  }

  List<String> get activityRecommendations {
    switch (this) {
      case MizacType.dem:
        return ['Yüzme, bisiklet, grup sporları', 'Dans ve ritimli hareketler'];
      case MizacType.safra:
        return [
          'Yoğa, tai chi, yürüyüş',
          'Güreş ve rekabetçi sporlardan kaçın'
        ];
      case MizacType.balgam:
        return [
          'Koşu, zumba, ağırlık antrenmanı',
          'Her gün en az 30 dk aktif ol'
        ];
      case MizacType.sevda:
        return [
          'Pilates, yürüyüş, doğa yürüyüşleri',
          'Sosyal aktiviteler ruh halini iyileştirir'
        ];
    }
  }

  String get name => toString().split('.').last;

  static MizacType fromName(String name) {
    return MizacType.values.firstWhere(
      (e) => e.name == name,
      orElse: () => MizacType.dem,
    );
  }
}
