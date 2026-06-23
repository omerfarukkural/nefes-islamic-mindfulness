import 'package:hijri/hijri_calendar.dart';

class KozmikCalculator {
  static int _digitSum(int n) {
    int sum = n.toString().split('').map(int.parse).reduce((a, b) => a + b);
    while (sum > 9 && sum != 11 && sum != 22) {
      sum = sum.toString().split('').map(int.parse).reduce((a, b) => a + b);
    }
    return sum;
  }

  static int dailyEnergyNumber(DateTime date) {
    final raw = date.day + date.month + date.year;
    return _digitSum(raw);
  }

  static int personalYearNumber(DateTime birthDate, int currentYear) {
    final raw = birthDate.day + birthDate.month + currentYear;
    return _digitSum(raw);
  }

  static int personalMonthNumber(DateTime birthDate, DateTime now) {
    final py = personalYearNumber(birthDate, now.year);
    return _digitSum(py + now.month);
  }

  static String elementOfNumber(int n) {
    const elements = {
      1: 'Ateş 🔥',
      2: 'Su 💧',
      3: 'Hava 🌬️',
      4: 'Toprak 🌿',
      5: 'Ateş 🔥',
      6: 'Su 💧',
      7: 'Hava 🌬️',
      8: 'Toprak 🌿',
      9: 'Ateş 🔥',
      11: 'Işık ✨',
      22: 'Evren 🌌',
    };
    return elements[n] ?? 'Ateş 🔥';
  }

  static String dailyGuidance(int energyNum) {
    const guidance = {
      1: 'Bugün yeni başlangıçlar için ideal bir gün. Niyetini koy, adım at. Sabah namazından sonra "Ya Fettah" ismini 71 kez oku.',
      2: 'Bugün dinle ve hisset. İlişkilerinde hassas ol, sabır göster. "Ya Halim" ismini 88 kez oku.',
      3: 'Yaratıcılığın zirveye çıktığı bir gün. İfade et, paylaş, sevin. "Ya Bedi" ismini 86 kez oku.',
      4: 'Disiplin ve çalışma günü. Planları hayata geçir, temel at. "Ya Matin" ismini 500 kez oku.',
      5: 'Değişim ve özgürlük enerjisi. Alışkanlıklarını sorgula. "Ya Mucib" ismini 55 kez oku.',
      6: 'Şifa ve sevgi günü. Aile ve sevdiklerine zaman ayır. "Ya Rahman" ismini 298 kez oku.',
      7: 'İçe dönüş ve tefekkür günü. Sessizlikte hikmet ara. "Ya Alim" ismini 150 kez oku.',
      8: 'Güç ve kararlılık günü. Engellerle yüzleş, geç. "Ya Kadir" ismini 305 kez oku.',
      9: 'Tamamlanma ve bırakma günü. Eskiye veda et, yeniye hazırlan. "Ya Ferd" ismini 289 kez oku.',
      11: 'Sezgi ve ilham günü. Ruhsal farkındalığın yüksek. "Ya Nur" ismini 256 kez oku.',
      22: 'Usta inşacı günü. Büyük hedefler için harekete geç.',
    };
    return guidance[energyNum] ?? guidance[1]!;
  }

  static Map<String, String> islamicDayInfo(DateTime date) {
    final hijri = HijriCalendar.now();
    final weekday = date.weekday; // 1=Mon, 7=Sun
    const planets = {
      1: 'Ay',
      2: 'Mars',
      3: 'Merkür',
      4: 'Jüpiter',
      5: 'Venüs',
      6: 'Satürn',
      7: 'Güneş',
    };
    const colors = {
      1: 'Gümüş / Beyaz',
      2: 'Kırmızı',
      3: 'Sarı',
      4: 'Mor / Mavi',
      5: 'Yeşil',
      6: 'Siyah / Koyu Mavi',
      7: 'Altın / Sarı',
    };
    const dhikrs = {
      1: 'Salavat-ı Şerife',
      2: 'İstiğfar',
      3: 'Kelime-i Tevhid',
      4: 'Tesbih (Sübhanallah)',
      5: 'Şükür Duası',
      6: 'Tövbe Duası',
      7: 'Tehlil',
    };
    const dayNames = {
      1: 'Pazartesi (İsneyn)',
      2: 'Salı (Selasa)',
      3: 'Çarşamba (Erbia)',
      4: 'Perşembe (Hamis)',
      5: 'Cuma (Cuma)',
      6: 'Cumartesi (Sebt)',
      7: 'Pazar (Ahad)',
    };
    return {
      'hicri': '${hijri.hDay} ${_hijriMonthName(hijri.hMonth)} ${hijri.hYear}',
      'gun': dayNames[weekday] ?? '',
      'gezegen': planets[weekday] ?? '',
      'renk': colors[weekday] ?? '',
      'zikir': dhikrs[weekday] ?? '',
    };
  }

  static String _hijriMonthName(int m) {
    const names = [
      'Muharrem',
      'Safer',
      'Rebiülevvel',
      'Rebiülahir',
      'Cemaziyelevvel',
      'Cemaziyelahir',
      'Recep',
      'Şaban',
      'Ramazan',
      'Şevval',
      'Zilkade',
      'Zilhicce',
    ];
    return names[(m - 1).clamp(0, 11)];
  }

  static String personalYearGuidance(int yearNum) {
    const guide = {
      1: 'Kişisel yıl 1: Yeni döngünün başlangıcı. Bu yıl tohumları ek, yeni projeler başlat.',
      2: 'Kişisel yıl 2: İşbirlikleri ve ilişkiler. Sabır ve diplomasi zamanı.',
      3: 'Kişisel yıl 3: Yaratıcılık ve büyüme. İfade et ve sevin.',
      4: 'Kişisel yıl 4: Temeller yılı. Çalış, planla, disiplinli ol.',
      5: 'Kişisel yıl 5: Değişim ve özgürlük. Yeni kapılar açılıyor.',
      6: 'Kişisel yıl 6: Sorumluluk ve aile. Şifa ve dengeye odaklan.',
      7: 'Kişisel yıl 7: İçe dönüş ve spiritüel büyüme. Hikmet zamanı.',
      8: 'Kişisel yıl 8: Güç ve başarı yılı. Maddi ve manevi hasat.',
      9: 'Kişisel yıl 9: Tamamlanma yılı. Bırak, temizlen, hazırlan.',
    };
    return guide[yearNum] ?? guide[1]!;
  }
}
