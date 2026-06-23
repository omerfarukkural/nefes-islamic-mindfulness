class DreamSymbol {
  final String symbol;
  final String emoji;
  final String islamicMeaning;
  final String generalMeaning;
  final String category;

  const DreamSymbol({
    required this.symbol,
    required this.emoji,
    required this.islamicMeaning,
    required this.generalMeaning,
    required this.category,
  });
}

const List<DreamSymbol> dreamSymbols = [
  // Su / Water
  DreamSymbol(
      symbol: 'Su',
      emoji: '💧',
      islamicMeaning:
          'İlim, rahmet ve hayırdır. Temiz su görmek bereket getirir.',
      generalMeaning: 'Ruhun derinliklerini ve duyguları simgeler.',
      category: 'Doğa'),
  DreamSymbol(
      symbol: 'Deniz',
      emoji: '🌊',
      islamicMeaning:
          'Büyük bir dünyaya, ya da bol rızka işaret eder. Dalgalı deniz sıkıntıları gösterir.',
      generalMeaning: 'Bilinçdışının büyüklüğünü temsil eder.',
      category: 'Doğa'),
  DreamSymbol(
      symbol: 'Nehir',
      emoji: '🏞️',
      islamicMeaning:
          'Hayatın akışı, helal rızık. İçinden su içmek bolluğa işarettir.',
      generalMeaning: 'Zamanın geçişini ve değişimi simgeler.',
      category: 'Doğa'),
  DreamSymbol(
      symbol: 'Yağmur',
      emoji: '🌧️',
      islamicMeaning:
          'Rahmet ve bereket. İbn Sirin\'e göre yağmur, ilahi ihsan işaretidir.',
      generalMeaning: 'Temizlenme ve yenilenme isteğini gösterir.',
      category: 'Doğa'),
  DreamSymbol(
      symbol: 'Ateş',
      emoji: '🔥',
      islamicMeaning:
          'Gazap ya da fitneye işaret eder; ancak ateşi söndürülebiliyorsa hayır gelir.',
      generalMeaning: 'Güçlü duygular, tutku veya dönüşümü temsil eder.',
      category: 'Doğa'),
  DreamSymbol(
      symbol: 'Güneş',
      emoji: '☀️',
      islamicMeaning:
          'Adil yönetici, ilim ve nur. Güneşin doğduğunu görmek hayıra delildir.',
      generalMeaning: 'Güç, bilinç ve başarıyı simgeler.',
      category: 'Doğa'),
  DreamSymbol(
      symbol: 'Ay',
      emoji: '🌙',
      islamicMeaning:
          'Hükümdar ya da sultan. Dolunay görmek güç ve itibar kazanmaya işaret eder.',
      generalMeaning: 'Dişil enerji, sezgi ve gizem.',
      category: 'Doğa'),
  DreamSymbol(
      symbol: 'Yıldız',
      emoji: '⭐',
      islamicMeaning:
          'İlim erbabı, alimler veya liderler. Parlayan yıldız, ilim yolunda ilerleyişi gösterir.',
      generalMeaning: 'Rehberlik, umut ve ilham.',
      category: 'Doğa'),
  DreamSymbol(
      symbol: 'Dağ',
      emoji: '⛰️',
      islamicMeaning: 'Güçlü ve saygıdeğer kişi; aşılması güç engeldir.',
      generalMeaning: 'Zorluklar ve hedefleri simgeler.',
      category: 'Doğa'),
  DreamSymbol(
      symbol: 'Ağaç',
      emoji: '🌳',
      islamicMeaning:
          'Nesep, aile ve kök. Meyve veren ağaç bereket ve çocuk müjdesidir.',
      generalMeaning: 'Büyüme, güç ve dayanıklılığı temsil eder.',
      category: 'Doğa'),
  // Hayvanlar / Animals
  DreamSymbol(
      symbol: 'Aslan',
      emoji: '🦁',
      islamicMeaning:
          'Güçlü ve zalim düşmana işaret eder; aslanı evcilleştirmek ise zaferi simgeler.',
      generalMeaning: 'Güç, cesaret ve liderliği temsil eder.',
      category: 'Hayvan'),
  DreamSymbol(
      symbol: 'Yılan',
      emoji: '🐍',
      islamicMeaning:
          'Düşman veya kötü niyetli kişi. Yılanı öldürmek düşmana üstün gelmektir.',
      generalMeaning: 'Dönüşüm, gizli tehlike veya şifa.',
      category: 'Hayvan'),
  DreamSymbol(
      symbol: 'Kuş',
      emoji: '🕊️',
      islamicMeaning:
          'Ruhun hürriyeti; beyaz güvercin, barış ve tebşirat (müjde) getirir.',
      generalMeaning: 'Özgürlük, umut ve ruhsal yükselişi simgeler.',
      category: 'Hayvan'),
  DreamSymbol(
      symbol: 'Kartal',
      emoji: '🦅',
      islamicMeaning:
          'Güçlü yönetici ya da zafer. Kartalın yükselmesi yüksek makamlara işarettir.',
      generalMeaning: 'Vizyon, güç ve manevi perspektif.',
      category: 'Hayvan'),
  DreamSymbol(
      symbol: 'At',
      emoji: '🐎',
      islamicMeaning:
          'Şeref, rütbe ve kahramanlık. Beyaz at görmek, hayır ve izzete delildir.',
      generalMeaning: 'Güç, özgürlük ve hız.',
      category: 'Hayvan'),
  DreamSymbol(
      symbol: 'Köpek',
      emoji: '🐕',
      islamicMeaning:
          'Haris, obur düşman ya da hizmetçi. Isırıyorsa bir zarar geleceğine işarettir.',
      generalMeaning: 'Sadakat, koruma veya içgüdüsel yanı temsil eder.',
      category: 'Hayvan'),
  DreamSymbol(
      symbol: 'Kedi',
      emoji: '🐱',
      islamicMeaning:
          'Hırsız ya da hilekâr biri; evcil kedi ise huzurlu aile hayatına işaret eder.',
      generalMeaning: 'Bağımsızlık, sezgi ve gizem.',
      category: 'Hayvan'),
  DreamSymbol(
      symbol: 'Balık',
      emoji: '🐟',
      islamicMeaning:
          'Rızık ve nimet, özellikle sudan çıkarılmış balık büyük kazanç işareti.',
      generalMeaning: 'Bilinçdışından gelen içgörüler.',
      category: 'Hayvan'),
  DreamSymbol(
      symbol: 'Arı',
      emoji: '🐝',
      islamicMeaning:
          'Güvenilir, çalışkan insan; arı sokması ise kötü söz ya da zarar işareti.',
      generalMeaning: 'Topluluk, çalışkanlık ve verimlilik.',
      category: 'Hayvan'),
  DreamSymbol(
      symbol: 'Kelebek',
      emoji: '🦋',
      islamicMeaning: 'Ruh; dönüşüm ve yeniden doğuşu simgeler.',
      generalMeaning: 'Değişim, güzellik ve ruhsal dönüşüm.',
      category: 'Hayvan'),
  // Nesneler / Objects
  DreamSymbol(
      symbol: 'Ayna',
      emoji: '🪞',
      islamicMeaning:
          'Gerçeği görmek; kirli ayna fitne ve bulanıklığa işarettir.',
      generalMeaning: 'Öz yansıma, kimlik ve gerçek.',
      category: 'Nesne'),
  DreamSymbol(
      symbol: 'Anahtar',
      emoji: '🗝️',
      islamicMeaning:
          'Hazine ve rızık kapısı; anahtarı bulmak büyük hayra delildir.',
      generalMeaning: 'Fırsatlar, çözümler ve sırları açmak.',
      category: 'Nesne'),
  DreamSymbol(
      symbol: 'Kitap',
      emoji: '📖',
      islamicMeaning:
          'İlim, haber veya vahiy. Kur\'an görülüyorsa büyük müjdedir.',
      generalMeaning: 'Bilgi, öğrenme ve anlayış.',
      category: 'Nesne'),
  DreamSymbol(
      symbol: 'Altın',
      emoji: '🥇',
      islamicMeaning:
          'Yüzük veya altın takılar kadınlar için güzel; erkekler için üzücü olabilir.',
      generalMeaning: 'Değer, başarı ve manevi zenginlik.',
      category: 'Nesne'),
  DreamSymbol(
      symbol: 'Gümüş',
      emoji: '🥈',
      islamicMeaning:
          'Saf kalp, samimi niyet. Para olarak gümüş görmek hayır işaretidir.',
      generalMeaning: 'Saflık, berraklık ve sezgisel güç.',
      category: 'Nesne'),
  DreamSymbol(
      symbol: 'Kılıç',
      emoji: '⚔️',
      islamicMeaning:
          'Güç ve zafer. Kılıç kuşanmak makam ve onura, kılıç kırılması kayba işaret eder.',
      generalMeaning: 'Kararlılık, güç ve adalet.',
      category: 'Nesne'),
  DreamSymbol(
      symbol: 'Ev',
      emoji: '🏠',
      islamicMeaning:
          'Kişinin kendisi, ailesi ve durumudur. Ev yapmak ömür uzunluğuna işaret eder.',
      generalMeaning: 'Kimlik, güvenlik ve benlik.',
      category: 'Nesne'),
  DreamSymbol(
      symbol: 'Kapı',
      emoji: '🚪',
      islamicMeaning:
          'Fırsat ve geçiş. Açık kapı ilerlemek demek, kapalı kapı engeli simgeler.',
      generalMeaning: 'Yeni başlangıçlar ve geçişler.',
      category: 'Nesne'),
  DreamSymbol(
      symbol: 'Merdiven',
      emoji: '🪜',
      islamicMeaning:
          'Makam ve derece. Merdiven çıkmak yükselişe, inmek ise alçalmaya işarettir.',
      generalMeaning: 'Gelişim, kariyer ve manevi yükseliş.',
      category: 'Nesne'),
  DreamSymbol(
      symbol: 'Köprü',
      emoji: '🌉',
      islamicMeaning: 'Bir durumdan diğerine geçiş, zor bir sınavı aşmak.',
      generalMeaning: 'Bağlantı, geçiş ve ulaşma.',
      category: 'Nesne'),
  // Dini / Religious
  DreamSymbol(
      symbol: 'Kabe',
      emoji: '🕋',
      islamicMeaning:
          'En büyük müjde. Kabe\'yi görmek, haccı tamamlamak veya büyük bir nimete kavuşmaya delildir.',
      generalMeaning: 'Merkez, huzur ve manevi hedefe ulaşma.',
      category: 'Manevi'),
  DreamSymbol(
      symbol: 'Mescit / Cami',
      emoji: '🕌',
      islamicMeaning:
          'İman ve güvenlik. Mescitte namaz kılmak hayır ve sevap kazanmaya işarettir.',
      generalMeaning: 'Topluluk, huzur ve manevi sığınak.',
      category: 'Manevi'),
  DreamSymbol(
      symbol: 'Ezan Sesi',
      emoji: '🔊',
      islamicMeaning:
          'Şeref ve zafer müjdesidir. Rüyada ezan okumak hac veya şehitliğe işaret eder.',
      generalMeaning: 'Uyanış ve ilahi çağrı.',
      category: 'Manevi'),
  DreamSymbol(
      symbol: 'Namaz Kılmak',
      emoji: '🙏',
      islamicMeaning:
          'En güzel rüya. Hayır, kurtuluş ve Allah\'a yakınlık müjdesidir.',
      generalMeaning: 'Ruhsal bağlantı ve huzur.',
      category: 'Manevi'),
  DreamSymbol(
      symbol: 'Nur / Işık',
      emoji: '✨',
      islamicMeaning:
          'Hidayet, ilim ve Allah\'ın rahmeti. Nura doğru gitmek kurtuluşa işarettir.',
      generalMeaning: 'Uyanış, aydınlanma ve ilham.',
      category: 'Manevi'),
  DreamSymbol(
      symbol: 'Peygamber (SAV)',
      emoji: '🌹',
      islamicMeaning:
          'Hz. Peygamberi rüyada görmek gerçek bir rüyadır; çünkü Şeytan O\'nun suretine giremez.',
      generalMeaning: 'En kutlu rüya; rehberlik ve şifa müjdesi.',
      category: 'Manevi'),
  DreamSymbol(
      symbol: 'Cennet',
      emoji: '🌸',
      islamicMeaning:
          'Salih amel ve güzel sona işaret. Cennette yürümek güzel akıbet müjdesidir.',
      generalMeaning: 'Mükemmel bir hedef ve ruhsal tatmin.',
      category: 'Manevi'),
  DreamSymbol(
      symbol: 'Melek',
      emoji: '👼',
      islamicMeaning:
          'Melekleri görmek hayır, onlara selam vermek kurtuluşa işaret eder.',
      generalMeaning: 'İlahi rehberlik, koruma ve ilham.',
      category: 'Manevi'),
  // Renkler / Colors
  DreamSymbol(
      symbol: 'Beyaz Renk',
      emoji: '⬜',
      islamicMeaning:
          'Temizlik, saflık ve barış. Beyaz giysiler cennet ehline yakınlığa delildir.',
      generalMeaning: 'Saflık, temizlik ve yeni başlangıç.',
      category: 'Renk'),
  DreamSymbol(
      symbol: 'Yeşil Renk',
      emoji: '🟩',
      islamicMeaning:
          'Cennet ve iman. Yeşil giymek manevi güzellik ve cennete işaret eder.',
      generalMeaning: 'Büyüme, şifa ve bereket.',
      category: 'Renk'),
  DreamSymbol(
      symbol: 'Sarı Renk',
      emoji: '🟨',
      islamicMeaning:
          'Hastalık ya da keder. Ancak altın sarısı güzellik ve serveti simgeler.',
      generalMeaning: 'Enerji, yaratıcılık veya uyarı.',
      category: 'Renk'),
  DreamSymbol(
      symbol: 'Siyah Renk',
      emoji: '⬛',
      islamicMeaning:
          'Karanlık olaylar ya da güçlü bir kişilik. Bağlama göre değişir.',
      generalMeaning: 'Bilinmeyenler, gizem ve dönüşüm.',
      category: 'Renk'),
  DreamSymbol(
      symbol: 'Kırmızı Renk',
      emoji: '🟥',
      islamicMeaning:
          'Kuvvet, ancak dikkat gerektiren heyecan. Kan kırmızısı uyarı işareti olabilir.',
      generalMeaning: 'Tutku, enerji ve güçlü duygular.',
      category: 'Renk'),
  // Hareketler / Actions
  DreamSymbol(
      symbol: 'Uçmak',
      emoji: '🦅',
      islamicMeaning:
          'Yolculuk, hürriyet ve yükseliş. Uzaklara uçmak arzulara ulaşmaya işaret eder.',
      generalMeaning: 'Özgürlük, hırs ve sınırları aşmak.',
      category: 'Eylem'),
  DreamSymbol(
      symbol: 'Koşmak',
      emoji: '🏃',
      islamicMeaning:
          'Acele bir işe gitmek. Korkuyla koşmak tehlikeden kaçışa, sevinçle koşmak hayır işaretidir.',
      generalMeaning: 'Hedef, acele veya kaçış.',
      category: 'Eylem'),
  DreamSymbol(
      symbol: 'Düşmek',
      emoji: '⬇️',
      islamicMeaning:
          'Makam kaybı ya da hata. Ama sağ salim düşmek pişmanlık ve tövbeye işaret eder.',
      generalMeaning: 'Kontrol kaybı, kaygı veya alçalma korkusu.',
      category: 'Eylem'),
  DreamSymbol(
      symbol: 'Ağlamak',
      emoji: '😢',
      islamicMeaning:
          'Sevinç ve ferah. İbn Sirin\'e göre rüyada ağlamak hayır kapılarının açılmasına işaret eder.',
      generalMeaning: 'Duygusal baskıdan arınma ve rahatlama.',
      category: 'Eylem'),
  DreamSymbol(
      symbol: 'Gülmek',
      emoji: '😄',
      islamicMeaning:
          'Şahikadan bakan ya da sevinç içinde gülmek hayırdır; kahkaha ise kedere işaret eder.',
      generalMeaning: 'Neşe, rahatlama ve olumlu enerji.',
      category: 'Eylem'),
  DreamSymbol(
      symbol: 'Yemek Yemek',
      emoji: '🍽️',
      islamicMeaning: 'Rızık ve nimet. Helal yemek yemek bereket ve sağlıktır.',
      generalMeaning: 'Beslenme, tatmin ve enerji.',
      category: 'Eylem'),
  DreamSymbol(
      symbol: 'Su İçmek',
      emoji: '🥤',
      islamicMeaning:
          'İlim, sağlık ve uzun ömür. Temiz su içmek büyük hayır işaretidir.',
      generalMeaning: 'Ruhsal susuzluğun giderilmesi.',
      category: 'Eylem'),
];

List<DreamSymbol> searchDreamSymbols(String query) {
  final q = query.toLowerCase();
  return dreamSymbols
      .where((s) =>
          s.symbol.toLowerCase().contains(q) ||
          s.category.toLowerCase().contains(q) ||
          s.islamicMeaning.toLowerCase().contains(q))
      .toList();
}

List<String> get dreamCategories =>
    dreamSymbols.map((s) => s.category).toSet().toList();
