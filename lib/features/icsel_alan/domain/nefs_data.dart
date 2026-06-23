class NefsMertebesi {
  final String name;
  final String arabicName;
  final int level;
  final String description;
  final String quranVerse;
  final String quranSource;
  final String practice;
  final String esma;
  final String color;
  final String emoji;
  final List<String> signs;

  const NefsMertebesi({
    required this.name,
    required this.arabicName,
    required this.level,
    required this.description,
    required this.quranVerse,
    required this.quranSource,
    required this.practice,
    required this.esma,
    required this.color,
    required this.emoji,
    required this.signs,
  });
}

const List<NefsMertebesi> nefsMertebeleri = [
  NefsMertebesi(
    name: 'Nefs-i Emmare',
    arabicName: 'النفس الأمارة',
    level: 1,
    description:
        'Kötülüğü emreden nefis. Şehvet, hırs ve gazabın hâkim olduğu, ilahi emirlere karşı gelen en ilkel nefis mertebesi.',
    quranVerse: 'İnne\'n-nefse le-emmâretün bi\'s-sûi',
    quranSource: 'Yusuf Suresi 53',
    practice:
        'İstiğfar: Her gün 100 kez "Estağfirullah" de. Nefis muhasebesi için akşam üç soruyu cevapla: Ne yaptım? Neden yaptım? Daha iyi ne yapabilirdim?',
    esma: 'Ya Tevvab (التواب)',
    color: '#B71C1C',
    emoji: '🔴',
    signs: [
      'Öfke patlamaları',
      'Şehvete yenik düşme',
      'Hırs ve tamah',
      'Egonun baskın olması'
    ],
  ),
  NefsMertebesi(
    name: 'Nefs-i Levvame',
    arabicName: 'النفس اللوامة',
    level: 2,
    description:
        'Kendini kınayan nefis. Hata yaptığında pişmanlık duyan, vicdanın uyanmaya başladığı mertebe.',
    quranVerse: 'Ve lâ uksimu bi\'n-nefsi\'l-levvâmeh',
    quranSource: 'Kıyame Suresi 2',
    practice:
        'Tövbe ve tefekkür: Her hatadan sonra içten tövbe et. Günlük 33 kez "Estağfirullahi ve etûbu ileyh" oku. Hataları not et ve tekrar etmemeye azmet.',
    esma: 'Ya Afüvv (العفو)',
    color: '#E65100',
    emoji: '🟠',
    signs: [
      'Hata sonrası pişmanlık',
      'Vicdan azabı',
      'Kendini eleştirme',
      'Değişme isteği'
    ],
  ),
  NefsMertebesi(
    name: 'Nefs-i Mülhime',
    arabicName: 'النفس الملهمة',
    level: 3,
    description:
        'İlham alan nefis. İyilik ve kötülüğün ilham edildiği, sezginin güçlendiği, manevi kapıların aralandığı mertebe.',
    quranVerse: 'Fe elhemehâ fucûrehâ ve takvâhâ',
    quranSource: 'Şems Suresi 8',
    practice:
        'Zikir ve tefekkür: Günlük 100 kez "Ya Nûr" oku. Sabah namazından sonra 10 dakika sessiz otur ve kalbindeki sesi dinle. Günlük bir güzellik bul ve şükret.',
    esma: 'Ya Nur (النور)',
    color: '#F9A825',
    emoji: '🟡',
    signs: [
      'Sezgisel anlayış',
      'İç ses güçleniyor',
      'İyilik eğilimi',
      'Manevi merak'
    ],
  ),
  NefsMertebesi(
    name: 'Nefs-i Mutmainne',
    arabicName: 'النفس المطمئنة',
    level: 4,
    description:
        'Huzura eren nefis. Kalbin Allah\'a yöneldiği, iç huzurun derinleştiği, dünyanın korkularından arınan mertebe.',
    quranVerse: 'Yâ eyyetuhe\'n-nefsu\'l-mutmainneh',
    quranSource: 'Fecr Suresi 27',
    practice:
        'Murâkabe: Günde iki kez 10 dakika Allah\'ın huzurunda olduğunu hissederek otur. "Hasbiyallah" zikrini 100 kez çek. Tevekkülü yaşa.',
    esma: 'Ya Selam (السلام)',
    color: '#2E7D32',
    emoji: '🟢',
    signs: ['Derin iç huzur', 'Korkusuzluk', 'Tevekkül', 'Kalbî tatmin'],
  ),
  NefsMertebesi(
    name: 'Nefs-i Radiyye',
    arabicName: 'النفس الراضية',
    level: 5,
    description:
        'Allah\'tan razı olan nefis. Her durumda Allah\'ın takdirine rıza gösteren, şikâyetin bittiği mertebe.',
    quranVerse: 'İrciî ilâ rabbiki râdiyeten mardiyyeh',
    quranSource: 'Fecr Suresi 28',
    practice:
        'Rıza ve şükür: Her zorlukta "Rıdtü billahi rabben" de. Gün içinde 33 kez "El-Hamdülillah". Her şeyde hikmeti ara ve bul.',
    esma: 'Ya Sabur (الصبور)',
    color: '#1565C0',
    emoji: '🔵',
    signs: [
      'Her şeye rıza',
      'Şikâyetin bitmesi',
      'Takdire teslim',
      'Derin şükür'
    ],
  ),
  NefsMertebesi(
    name: 'Nefs-i Mardiyye',
    arabicName: 'النفس المرضية',
    level: 6,
    description:
        'Allah\'ın razı olduğu nefis. Kulun Allah\'tan razı olduğu gibi Allah\'ın da kuldan razı olduğu yüksek mertebe.',
    quranVerse: 'Mardiyyeh — fe\'dkhulî fî ibâdî',
    quranSource: 'Fecr Suresi 28-29',
    practice:
        'Hizmet ve ihsan: Her gün bir insana gizlice iyilik yap. "Ya Vedûd" ismini 33 kez oku. Niyetini sadece Allah rızası için kur.',
    esma: 'Ya Vedud (الودود)',
    color: '#6A1B9A',
    emoji: '🟣',
    signs: [
      'Başkalarına şefkat',
      'Gizli iyilik',
      'Nefs hesabı yok',
      'İhsan hali'
    ],
  ),
  NefsMertebesi(
    name: 'Nefs-i Kâmile',
    arabicName: 'النفس الكاملة',
    level: 7,
    description:
        'Kemale eren nefis. Fena fillah mertebesinde benliğin yok olduğu, ilahi sıfatların tecelli ettiği en yüksek makam.',
    quranVerse: 'Ve\'dkhulî cennetî',
    quranSource: 'Fecr Suresi 30',
    practice:
        'Fenâ ve bekâ: "Lâ ilâhe illallah" zikrini 300 kez çek. Tüm varlığını Allah\'a adama niyetiyle her güne başla. Müride rehberlik et.',
    esma: 'Ya Allah (الله)',
    color: '#1A237E',
    emoji: '⚪',
    signs: [
      'Benliğin yok olması',
      'İlahi tecelli',
      'Rehberlik gücü',
      'Tam teslimiyet'
    ],
  ),
];
