class IlhamEntry {
  final String arabic;
  final String turkish;
  final String source;
  final String category;
  final int color;

  const IlhamEntry({
    required this.arabic,
    required this.turkish,
    required this.source,
    required this.category,
    required this.color,
  });
}

const List<IlhamEntry> quranAyetleri = [
  IlhamEntry(
    arabic: 'أَلَا بِذِكْرِ اللّٰهِ تَطْمَئِنُّ الْقُلُوبُ',
    turkish: 'Dikkat edin! Kalpler ancak Allah\'ı zikretmekle huzur bulur.',
    source: 'Rad Suresi 28. Ayet',
    category: 'Huzur',
    color: 0xFF1B5E20,
  ),
  IlhamEntry(
    arabic: 'وَمَن يَتَّقِ اللّٰهَ يَجْعَل لَّهُ مَخْرَجًا',
    turkish: 'Kim Allah\'tan korkarsa, Allah ona bir çıkış yolu yaratır.',
    source: 'Talak Suresi 2. Ayet',
    category: 'Tevekkül',
    color: 0xFF4A148C,
  ),
  IlhamEntry(
    arabic: 'إِنَّ مَعَ الْعُسْرِ يُسْرًا',
    turkish: 'Şüphesiz güçlükle birlikte kolaylık vardır.',
    source: 'İnşirah Suresi 6. Ayet',
    category: 'Umut',
    color: 0xFF01579B,
  ),
  IlhamEntry(
    arabic: 'وَإِذَا سَأَلَكَ عِبَادِي عَنِّي فَإِنِّي قَرِيبٌ',
    turkish: 'Kullarım sana benden sorarlarsa, şüphesiz ben yakınım.',
    source: 'Bakara Suresi 186. Ayet',
    category: 'Yakınlık',
    color: 0xFF006064,
  ),
  IlhamEntry(
    arabic: 'وَلَا تَيْأَسُوا مِن رَّوْحِ اللّٰهِ',
    turkish: 'Allah\'ın rahmetinden ümit kesmeyiniz.',
    source: 'Yusuf Suresi 87. Ayet',
    category: 'Ümit',
    color: 0xFF880E4F,
  ),
  IlhamEntry(
    arabic: 'وَهُوَ مَعَكُمْ أَيْنَ مَا كُنتُمْ',
    turkish: 'Nerede olursanız olun, O sizinledir.',
    source: 'Hadid Suresi 4. Ayet',
    category: 'Beraberlik',
    color: 0xFF37474F,
  ),
  IlhamEntry(
    arabic: 'فَاذْكُرُونِي أَذْكُرْكُمْ',
    turkish: 'Siz beni anın, ben de sizi anayım.',
    source: 'Bakara Suresi 152. Ayet',
    category: 'Zikir',
    color: 0xFF3E2723,
  ),
  IlhamEntry(
    arabic: 'وَاللّٰهُ يُحِبُّ الصَّابِرِينَ',
    turkish: 'Allah sabredenleri sever.',
    source: 'Al-i İmran Suresi 146. Ayet',
    category: 'Sabır',
    color: 0xFF1A237E,
  ),
  IlhamEntry(
    arabic: 'إِنَّ اللّٰهَ مَعَ الصَّابِرِينَ',
    turkish: 'Şüphesiz Allah, sabredenlerle beraberdir.',
    source: 'Bakara Suresi 153. Ayet',
    category: 'Sabır',
    color: 0xFF004D40,
  ),
  IlhamEntry(
    arabic: 'وَقُل رَّبِّ زِدْنِي عِلْمًا',
    turkish: 'Ve de ki: "Rabbim, ilmimi artır."',
    source: 'Taha Suresi 114. Ayet',
    category: 'İlim',
    color: 0xFF827717,
  ),
];

const List<IlhamEntry> hadisler = [
  IlhamEntry(
    arabic: 'إِنَّمَا الأَعْمَالُ بِالنِّيَّاتِ',
    turkish: 'Ameller yalnızca niyetlere göredir.',
    source: 'Buhârî, Bed\'ü\'l-Vahy, 1',
    category: 'Niyet',
    color: 0xFF1B5E20,
  ),
  IlhamEntry(
    arabic: 'الْمُسْلِمُ مَنْ سَلِمَ الْمُسْلِمُونَ مِنْ لِسَانِهِ وَيَدِهِ',
    turkish:
        'Müslüman, dilinden ve elinden diğer Müslümanların güvende olduğu kişidir.',
    source: 'Buhârî, İman, 4',
    category: 'Ahlak',
    color: 0xFF4A148C,
  ),
  IlhamEntry(
    arabic: 'خَيْرُكُمْ مَنْ تَعَلَّمَ الْقُرْآنَ وَعَلَّمَهُ',
    turkish: 'İçinizden en hayırlınız, Kur\'an\'ı öğrenen ve öğretendir.',
    source: 'Buhârî, Fezâilü\'l-Kur\'ân, 21',
    category: 'Kur\'an',
    color: 0xFF01579B,
  ),
  IlhamEntry(
    arabic: 'الدُّنْيَا سِجْنُ الْمُؤْمِنِ وَجَنَّةُ الْكَافِرِ',
    turkish: 'Dünya müminin zindanı, kâfirin cennetidir.',
    source: 'Müslim, Zühd, 1',
    category: 'Dünya',
    color: 0xFF006064,
  ),
  IlhamEntry(
    arabic:
        'مَنْ كَانَ آخِرُ كَلَامِهِ لَا إِلَهَ إِلَّا اللّٰهُ دَخَلَ الْجَنَّةَ',
    turkish: 'Son sözü "Lâ ilâhe illallah" olan kimse cennete girer.',
    source: 'Ebû Dâvûd, Cenâiz, 15',
    category: 'Tevhid',
    color: 0xFF880E4F,
  ),
  IlhamEntry(
    arabic: 'الصَّبْرُ ضِيَاءٌ',
    turkish: 'Sabır bir nurdur.',
    source: 'Müslim, Tahâret, 1',
    category: 'Sabır',
    color: 0xFF37474F,
  ),
  IlhamEntry(
    arabic: 'تَبَسُّمُكَ فِي وَجْهِ أَخِيكَ لَكَ صَدَقَةٌ',
    turkish: 'Kardeşinin yüzüne gülümsemen senin için bir sadakadır.',
    source: 'Tirmizî, Birr, 36',
    category: 'Güzellik',
    color: 0xFF3E2723,
  ),
  IlhamEntry(
    arabic: 'اتَّقِ اللّٰهَ حَيْثُمَا كُنْتَ',
    turkish: 'Nerede olursan ol Allah\'tan kork.',
    source: 'Tirmizî, Birr, 55',
    category: 'Takva',
    color: 0xFF1A237E,
  ),
];

List<IlhamEntry> get ilhamHavuzu => [...quranAyetleri, ...hadisler];

IlhamEntry getDailyIlham(DateTime date) {
  final idx =
      (date.year * 366 + date.month * 31 + date.day) % ilhamHavuzu.length;
  return ilhamHavuzu[idx];
}
