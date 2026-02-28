# 📱 Nefes App - A'dan Z'ye Geliştirme Rehberi

## AŞAMA 1: Planlama & Araştırma ✅ (Tamamlandı)

- [x] Pazar araştırması
- [x] Rakip analizi (Muslim Pro, Sabah, Calm)
- [x] Teknoloji stack belirleme
- [x] Mimari tasarım (Feature-First Clean Architecture)
- [x] GitHub repo kurulumu

---

## AŞAMA 2: Tasarım (UI/UX)

### 2.1 Kullanılacak Araçlar
| Araç | Amaç | Maliyet |
|------|-------|--------|
| Figma (Free) | UI tasarım, prototip | Ücretsiz |
| Figma Islamic Design System | İslami UI bileşenleri | Ücretsiz (Community) |
| Material Design 3 | Flutter tema sistemi | Ücretsiz |
| Lottie Files | Animasyonlar | Ücretsiz tier |
| Undraw.co | İllüstrasyonlar | Ücretsiz |
| Google Fonts (Amiri) | Arapça/İslami font | Ücretsiz |

### 2.2 Yapılacaklar
- [ ] Figma'da wireframe oluştur (10 ekran)
- [ ] Renk paleti belirle: Koyu yeşil (#1B5E20), Altın (#FFD700), Krem (#FFF8E1)
- [ ] İkon seti hazırla (İslami motifler)
- [ ] Dark/Light tema tasarla
- [ ] Prototipi test kullanıcılarıyla paylaş
- [ ] Animasyon flow'larını belirle (geçişler, loading)

### 2.3 Figma Kaynakları
- [Muslim Apps Template](https://www.figma.com/community/file/1025671297221280945/muslim-apps)
- [Free Islamic Design System](https://www.figma.com/community/file/1401528128521396126/free-islamic-design-system)
- [UMMATI Islamic UI](https://www.figma.com/community/file/1428274827682862000/ummati)

---

## AŞAMA 3: Backend & DB

### 3.1 Firebase Kurulumu
```bash
# Firebase CLI kur
npm install -g firebase-tools
firebase login

# Flutter projesine Firebase ekle
flutter pub add firebase_core firebase_auth cloud_firestore firebase_analytics
dart pub global activate flutterfire_cli
flutterfire configure
```

### 3.2 Firestore Veri Yapısı
```
users/{userId}/
  ├── profile: { name, email, createdAt, premium }
  ├── moods/{moodId}: { value, note, createdAt }
  ├── meditations/{sessionId}: { type, duration, completedAt }
  ├── chats/{chatId}: { messages[], createdAt }
  └── settings/{settingId}: { notifEnabled, theme, language }

content/
  ├── duas/{duaId}: { arabicText, turkishTranslation, category }
  ├── meditations/{guideId}: { title, audioUrl, duration, type }
  └── daily_verses/{verseId}: { ayah, surah, translation }
```

### 3.3 Hive (Offline-First) Kurulumu
```dart
// lib/core/services/offline_storage_service.dart
// Box'lar:
// - 'moods' → MoodEntry TypeAdapter
// - 'meditations' → MeditationSession TypeAdapter
// - 'chat_cache' → ChatMessage TypeAdapter
// - 'settings' → UserSettings
```

### 3.4 Senkronizasyon Stratejisi
1. Veri önce Hive'a yazılır (anında UI güncelleme)
2. İnternet varsa → Firestore'a sync
3. İnternet yoksa → Queue'ya ekle
4. İnternet geldiğinde → Queue boşaltılır
5. Conflict resolution: Son yazma kazanır

### 3.5 Gemini AI API
```bash
# API Key al: https://aistudio.google.com/app/apikey
# .env dosyasına ekle
GEMINI_API_KEY=AIzaSy...

# Build sırasında:
flutter run --dart-define=GEMINI_API_KEY=$GEMINI_API_KEY
```

---

## AŞAMA 4: Frontend Geliştirme

### 4.1 Geliştirme Sırası (Sprint Planı)

| Sprint | Süre | Modüller |
|--------|------|----------|
| Sprint 1 | 2 hafta | Home, Onboarding, Theme |
| Sprint 2 | 2 hafta | Mood Tracker, Hive entegrasyonu |
| Sprint 3 | 2 hafta | Meditation Player, Audio |
| Sprint 4 | 2 hafta | AI Chat (Gemini), Chat UI |
| Sprint 5 | 1 hafta | Dua modülü, İslami takvim |
| Sprint 6 | 1 hafta | Settings, Firebase Auth |
| Sprint 7 | 1 hafta | Premium/Ads, In-App Purchase |
| Sprint 8 | 1 hafta | Test, bug fix, polish |

### 4.2 Her Sprint Sonunda
- [ ] flutter analyze → 0 hata
- [ ] flutter test → %70+ coverage
- [ ] Manuel test (emülatör + fiziksel cihaz)
- [ ] Git tag: v0.1.0, v0.2.0...

### 4.3 Geliştirme Komutları
```bash
# Kod üretimi (Riverpod + Hive)
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode (otomatik kod üretimi)
flutter pub run build_runner watch

# Debug build
flutter run -d emulator-5554

# Release build test
flutter run --release
```

---

## AŞAMA 5: Otomasyon

### 5.1 GitHub Actions CI/CD
Dosya: `.github/workflows/flutter-ci.yml` (zaten repo'da)

Özellikler:
- Her push'ta otomatik test
- Ana branch'e merge'de APK build
- Tag oluşturulduğunda GitHub Release

### 5.2 n8n Otomasyon Senaryoları (Self-hosted, Ücretsiz)

| Senaryo | Tetikleyici | Aksiyon |
|---------|------------|--------|
| Crash Bildirimi | Firebase Crashlytics webhook | Slack'e mesaj gönder |
| Haftalık Rapor | Cron (Pazartesi 09:00) | Firestore'dan KPI → Slack |
| Yeni İnceleme | Play Store webhook | Slack'e bildirim |
| Yedekleme | Cron (Her gece 03:00) | Firestore export → GCS |

### 5.3 n8n Kurulumu
```bash
# Docker ile n8n kur (ücretsiz, self-hosted)
docker run -d --name n8n \
  -p 5678:5678 \
  -v n8n_data:/home/node/.n8n \
  n8nio/n8n

# Erişim: http://localhost:5678
```

### 5.4 Firebase Crashlytics Entegrasyonu
```dart
// main.dart'a ekle
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };
  
  runApp(const ProviderScope(child: NefesApp()));
}
```

---

## AŞAMA 6: Yayınlama (Store)

### 6.1 Google Play Store Hazırlık Kontrol Listesi

| Gereksinim | Detay | Durum |
|-----------|-------|-------|
| Google Play Developer Hesabı | $25 tek seferlik ücret | ⬜ |
| Uygulama Simgesi | 512×512 PNG, yuvarlak köşe | ⬜ |
| Feature Graphic | 1024×500 PNG | ⬜ |
| Ekran Görüntüleri | Min 2, önerilen 8 (telefon + tablet) | ⬜ |
| Gizlilik Politikası | URL olarak (GitHub Pages veya web) | ⬜ |
| İçerik Derecelendirmesi | Play Console'da anket doldur | ⬜ |
| App Bundle (.aab) | `flutter build appbundle --release` | ⬜ |
| Target SDK | API 35 (Android 15) - Ağustos 2025'ten itibaren | ⬜ |
| 16KB Sayfa Desteği | NDK kullanılıyorsa kontrol et | ⬜ |
| Finans Beyanı | Play Console'da form doldur | ⬜ |
| Veri Güvenliği Formu | Hangi veri toplandığı beyanı | ⬜ |

### 6.2 ASO (App Store Optimization)
```
Başlık: Nefes - İslami Meditasyon & Ruh Sağlığı
Kısa Açıklama: AI destekli İslami farkındalık, meditasyon, dua ve ruh hali takibi
Anahtar Kelimeler: İslami meditasyon, dua, zikir, mindfulness, ruh sağlığı, mental sağlık, namaz vakti
Kategori: Sağlık ve Fitness
İçerik Derecesi: Herkes
```

### 6.3 Release Checklist
```bash
# 1. Version bump
# pubspec.yaml → version: 1.0.0+1

# 2. Release build
flutter build appbundle --release

# 3. Test APK
flutter build apk --release --split-per-abi
adb install build/app/outputs/flutter-apk/app-arm64-v8a-release.apk

# 4. Upload to Play Console
# play.google.com/console → Release → Production
```

---

## AŞAMA 7: Takip & Analiz

### 7.1 Analytics Araçları

| Araç | Amaç | Maliyet |
|------|-------|--------|
| Firebase Analytics | Kullanıcı davranışı | Ücretsiz |
| Firebase Crashlytics | Çökme raporları | Ücretsiz |
| Firebase Performance | Uygulama performansı | Ücretsiz |
| Google Play Console | İndirme, puan, gelir | Ücretsiz |
| Firebase Remote Config | A/B test, feature flag | Ücretsiz |

### 7.2 Takip Edilecek KPI'lar

| KPI | Hedef (3 Ay) | Ölçüm |
|-----|-------------|-------|
| DAU (Günlük Aktif) | 500 | Firebase Analytics |
| Retention (7 gün) | %30 | Firebase Analytics |
| Crash-free rate | %99.5 | Crashlytics |
| Ortalama oturum süresi | 5 dk | Firebase Analytics |
| Dönüşüm (Premium) | %3 | In-App Purchase |
| Store Puanı | 4.5+ | Play Console |

### 7.3 Custom Events (Firebase)
```dart
FirebaseAnalytics.instance.logEvent(
  name: 'meditation_completed',
  parameters: {
    'type': 'breathing',
    'duration_seconds': 300,
    'completed': true,
  },
);

FirebaseAnalytics.instance.logEvent(
  name: 'mood_logged',
  parameters: {
    'mood_value': 4,
    'has_note': true,
  },
);

FirebaseAnalytics.instance.logEvent(
  name: 'ai_chat_sent',
  parameters: {
    'message_count': 5,
    'is_premium': false,
  },
);
```

---

## AŞAMA 8: Yedekleme & Arşiv

### 8.1 Veri Yedekleme Stratejisi

| Veri | Yedekleme | Sıklık | Araç |
|------|----------|--------|------|
| Kaynak Kod | GitHub (remote) | Her commit | Git |
| Firestore Verisi | Cloud Storage (GCS) | Günlük | gcloud CLI / n8n |
| Kullanıcı Verileri | Firestore PITR | Otomatik (7 gün) | Firebase |
| APK/AAB Build'ler | GitHub Releases | Her release | GitHub Actions |
| Tasarım Dosyaları | Figma (cloud) | Otomatik | Figma |
| .env / Secrets | GitHub Secrets | Manuel | GitHub |

### 8.2 Firestore Yedekleme Komutu
```bash
# Manuel yedekleme
gcloud firestore export gs://nefes-app-backup/$(date +%Y%m%d)

# Geri yükleme
gcloud firestore import gs://nefes-app-backup/20260301
```

### 8.3 n8n ile Otomatik Yedekleme
```
Workflow: Firestore Daily Backup
Tetikleyici: Cron → Her gece 03:00 (Türkiye saati)
Adım 1: Execute Command → gcloud firestore export gs://nefes-backup/$(date)
Adım 2: HTTP Request → Slack webhook (başarılı/başarısız bildirim)
```

### 8.4 Kod Yedekleme Best Practices
```bash
# Yerel yedek
git bundle create nefes-backup-$(date +%Y%m%d).bundle --all

# Tag ile versiyon
git tag -a v1.0.0 -m "İlk stabil sürüm"
git push origin --tags
```

---

## Hızlı Referans: Tüm Araçlar

| Kategori | Araç | Maliyet | URL |
|----------|------|---------|-----|
| IDE | VS Code + Flutter ext | Ücretsiz | code.visualstudio.com |
| Tasarım | Figma | Ücretsiz | figma.com |
| Backend | Firebase (Spark Plan) | Ücretsiz | firebase.google.com |
| AI | Gemini API (Free Tier) | Ücretsiz | aistudio.google.com |
| CI/CD | GitHub Actions | Ücretsiz (2000 dk/ay) | github.com |
| Otomasyon | n8n (self-hosted) | Ücretsiz | n8n.io |
| Analytics | Firebase Analytics | Ücretsiz | firebase.google.com |
| Crash | Firebase Crashlytics | Ücretsiz | firebase.google.com |
| Store | Google Play Console | $25 (tek sefer) | play.google.com/console |
| Reklam | Google AdMob | Ücretsiz (gelir paylaşım) | admob.google.com |
| İcon | Android Asset Studio | Ücretsiz | romannurik.github.io |
| Screenshot | Fastlane Screengrab | Ücretsiz | fastlane.tools |
