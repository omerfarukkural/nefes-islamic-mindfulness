class EbcedService {
  // Classic Abjad (Kabir) values
  static const Map<String, int> _abjad = {
    'ا': 1, 'أ': 1, 'إ': 1, 'آ': 1, 'ء': 1,
    'ب': 2,
    'ج': 3,
    'د': 4,
    'ه': 5, 'ة': 5,
    'و': 6, 'ؤ': 6,
    'ز': 7,
    'ح': 8,
    'ط': 9,
    'ي': 10, 'ى': 10, 'ئ': 10,
    'ك': 20,
    'ل': 30,
    'م': 40,
    'ن': 50,
    'س': 60,
    'ع': 70,
    'ف': 80,
    'ص': 90,
    'ق': 100,
    'ر': 200,
    'ش': 300,
    'ت': 400,
    'ث': 500,
    'خ': 600,
    'ذ': 700,
    'ض': 800,
    'ظ': 900,
    'غ': 1000,
  };

  // Turkish letter numerology (Pythagorean mapping)
  static const Map<String, int> _turkish = {
    'A': 1, 'J': 1, 'S': 1, 'Ş': 1,
    'B': 2, 'K': 2, 'T': 2,
    'C': 3, 'L': 3, 'U': 3, 'Ü': 3,
    'D': 4, 'M': 4, 'V': 4,
    'E': 5, 'N': 5,
    'F': 6, 'O': 6, 'Ö': 6,
    'G': 7, 'P': 7, 'Y': 7,
    'H': 8, 'R': 8, 'Z': 8,
    'I': 9, 'İ': 9, 'Ç': 9, 'Ğ': 9,
  };

  static int calculateEbced(String arabicText) {
    int total = 0;
    for (final char in arabicText.runes) {
      final letter = String.fromCharCode(char);
      total += _abjad[letter] ?? 0;
    }
    return total;
  }

  static List<Map<String, dynamic>> calculateEbcedDetailed(String text) {
    final result = <Map<String, dynamic>>[];
    for (final char in text.runes) {
      final letter = String.fromCharCode(char);
      final value = _abjad[letter];
      if (value != null) {
        result.add({'letter': letter, 'value': value});
      }
    }
    return result;
  }

  static int calculateTurkishNumerology(String name) {
    int total = 0;
    for (final char in name.toUpperCase().runes) {
      final letter = String.fromCharCode(char);
      total += _turkish[letter] ?? 0;
    }
    return total;
  }

  static int reduceToDigit(int n) {
    // Master numbers: 11, 22, 33 are not reduced
    while (n > 9 && n != 11 && n != 22 && n != 33) {
      n = n.toString().split('').map(int.parse).reduce((a, b) => a + b);
    }
    return n;
  }

  static String getNumberMeaning(int n) {
    const meanings = {
      1: 'Liderlik, özgünlük ve yeni başlangıçlar. Güçlü irade ve bağımsızlık enerjisi.',
      2: 'Denge, işbirliği ve uyum. Diplomatik ruh ve sezgisel güç.',
      3: 'Yaratıcılık, ifade ve neşe. Sanatsal yetenekler ve iletişim gücü.',
      4: 'Disiplin, çalışkanlık ve sağlamlık. Pratik zeka ve güvenilirlik.',
      5: 'Özgürlük, değişim ve macera. Esneklik ve çok yönlülük.',
      6: 'Sorumluluk, aile ve şifa. Şefkat ve dengeleyici güç.',
      7: 'Hikmet, analiz ve spiritüalite. Derin düşünce ve içsel aydınlanma.',
      8: 'Güç, başarı ve materyal zerafet. Kararlılık ve yönetim yetisi.',
      9: 'Evrensel sevgi, tamamlanma ve insanlığa hizmet. Derin merhamet.',
      11: 'Üstat sayı: Sezgi, aydınlanma ve ilham. Spiritüel farkındalık.',
      22: 'Üstat sayı: Büyük usta inşacı. Vizyoner pratiklik ve evrensel hizmet.',
      33: 'Üstat sayı: Büyük öğretmen. Nefsani olgunluk ve şifa gücü.',
    };
    return meanings[n] ?? 'Benzersiz bir enerji kombinasyonu.';
  }

  static String getEbcedMeaning(int total) {
    final reduced = reduceToDigit(total);
    // Islamic mystical meanings of ebced totals
    const roots = {
      1: 'Ehad — Allah\'ın birliğine işaret. Tevhid yolunda güçlü bir ruh.',
      2: 'Tesir — İki zıddın birleşimi, denge arayışı, birlik içinde çokluk.',
      3: 'Üçlü tecelli — İlim, kudret ve irade. Ruhani büyüme döngüsü.',
      4: 'Dört unsur — Ateş, hava, su, toprak. Madde ve ruh dengesi.',
      5: 'Beş vakit — Namaz ile Allah\'a yakınlık. Beş duyu arınması.',
      6: 'Altı cihte — Her yönden ihata eden ilahi gözetim.',
      7: 'Yedi kat — Yedi nefs mertebesi, yedi kat gökyüzü yolculuğu.',
      8: 'Sekiz cennet — Ebedi nimet kapıları. Sabır ve şükrün meyvesi.',
      9: 'Dokuz felek — Kainatın döngüsü ve kemale erme.',
    };
    return roots[reduced] ?? getNumberMeaning(reduced);
  }

  static int calculateDateEbced(DateTime date) {
    final day = date.day;
    final month = date.month;
    final year = date.year;
    return reduceToDigit(
      reduceToDigit(day) + reduceToDigit(month) + reduceToDigit(year % 100),
    );
  }
}
