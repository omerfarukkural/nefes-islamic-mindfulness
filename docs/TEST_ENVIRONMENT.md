# 🧪 Test Ortamı Kurulum Rehberi

## 1. Gerekli Yazılımlar

| Yazılım | Versiyon | İndirme |
|---------|----------|--------|
| Flutter SDK | 3.24+ | https://flutter.dev/docs/get-started/install |
| Android Studio | 2024.1+ | https://developer.android.com/studio |
| VS Code | Latest | https://code.visualstudio.com |
| Git | 2.40+ | https://git-scm.com |
| Java JDK | 17 | Android Studio ile gelir |

## 2. Kurulum Adımları

### Adım 1: Repo'yu Klonla
```bash
git clone https://github.com/omerfarukkural/nefes-islamic-mindfulness.git
cd nefes-islamic-mindfulness
```

### Adım 2: Flutter Bağımlılıkları
```bash
flutter pub get
```

### Adım 3: Android Emulator Kurulumu
```bash
# Android Studio → Tools → Device Manager
# Yeni cihaz oluştur:
# - Pixel 7 (veya benzeri)
# - API Level: 34 (Android 14)
# - System Image: x86_64
# - RAM: 2048 MB
```

### Adım 4: Fiziksel Cihaz Testi
```bash
# 1. Telefonda Geliştirici Seçenekleri aç
# 2. USB Hata Ayıklama etkinleştir
# 3. USB ile bağla
flutter devices  # Cihazı görmelisin
flutter run      # Cihazda çalıştır
```

### Adım 5: Hot Reload ile Geliştirme
```bash
flutter run
# Kod değişikliği yap → Otomatik güncellenir
# r → Hot reload
# R → Hot restart
# q → Çıkış
```

## 3. Klasör Yapısı (Geliştirme)

```
nefes-islamic-mindfulness/
├── lib/                    → Dart kaynak kodları
│   ├── main.dart          → Giriş noktası
│   ├── app/               → App widget
│   ├── core/              → Çekirdek servisler
│   ├── features/          → Özellik modülleri
│   └── shared/            → Ortak bileşenler
├── test/                   → Test dosyaları
│   ├── unit/              → Unit testler
│   ├── widget/            → Widget testler
│   └── integration/       → Entegrasyon testleri
├── assets/                 → Statik dosyalar
│   ├── images/            → Görseller
│   ├── audio/             → Meditasyon sesleri
│   ├── lottie/            → Animasyonlar
│   ├── data/              → JSON veri dosyaları
│   └── fonts/             → Yazı tipleri
├── android/                → Android native kodu
├── ios/                    → iOS native kodu (sonra)
├── docs/                   → Dokümantasyon
├── pubspec.yaml            → Bağımlılıklar
└── analysis_options.yaml   → Lint kuralları
```

## 4. Ortam Değişkenleri

```bash
# .env dosyası oluştur (git'e EKLENMEYECEk)
GEMINI_API_KEY=your_api_key_here
FIREBASE_PROJECT_ID=nefes-app-xxxxx
ADMOB_APP_ID=ca-app-pub-xxxxx~xxxxx
ADMOB_BANNER_ID=ca-app-pub-xxxxx/xxxxx
```

## 5. Build Komutları

```bash
# Debug build
flutter run

# Release APK
flutter build apk --release

# App Bundle (Play Store)
flutter build appbundle --release

# API key ile build
flutter run --dart-define=GEMINI_API_KEY=your_key

# Test çalıştır
flutter test

# Coverage raporu
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

## 6. Sık Karşılaşılan Sorunlar

| Sorun | Çözüm |
|-------|-------|
| `flutter pub get` hata | `flutter clean && flutter pub get` |
| Emülatör açılmıyor | Android Studio → SDK Manager → API 34 indir |
| Hot reload çalışmıyor | `flutter run` yeniden başlat |
| Hive box açılmıyor | `Hive.deleteBoxFromDisk('box_name')` |
| Gemini API 429 hatası | Rate limiting: Dakikada max 15 istek |
