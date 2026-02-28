# 🤖 Copilot Coding Agent Talimatları

## Genel Talimat Şablonu

Aşağıdaki talimatı GitHub Copilot Coding Agent'a veya herhangi bir AI coding agent'a (Antigravity dahil) verebilirsiniz:

---

### Talimat 1: Offline Storage Entegrasyonu

```
Bu Flutter projesinde Hive offline storage'ı tam entegre et:

1. lib/core/services/offline_storage_service.dart dosyasını güncelle:
   - Mood entry'leri için Hive TypeAdapter oluştur
   - Meditation session'ları için Hive TypeAdapter oluştur
   - CRUD operasyonları ekle

2. lib/features/mood/presentation/mood_screen.dart:
   - _saveMood() metodunu OfflineStorageService ile bağla
   - _buildMoodHistory() widget'ını gerçek verilerle doldur
   - Son 7 günün mood chart'ını göster

3. lib/features/meditation/presentation/meditation_screen.dart:
   - _stopMeditation() metodunda session'ı kaydet
   - İstatistikleri HomeScreen'e yansıt

4. lib/features/home/presentation/home_screen.dart:
   - _buildStatsCard() widget'ını gerçek verilerle güncelle
   - Streak, toplam dakika, oturum sayısı göster

Kurallar:
- Offline-first: İnternet olmadan çalışmalı
- Hive box'ları lazy loading ile aç
- Her CRUD işlemi için error handling ekle
- Türkçe UI metinleri kullan
```

### Talimat 2: Gemini AI Chat Entegrasyonu

```
AI Chat özelliğini tam çalışır hale getir:

1. lib/core/constants/api_keys.dart oluştur:
   - Gemini API key'i güvenli şekilde sakla
   - flutter_dotenv veya --dart-define kullan

2. lib/core/services/ai_chat_service.dart güncelle:
   - Chat history'yi Hive'a kaydet
   - Offline modda son mesajları göster
   - Rate limiting ekle (dakikada max 10 mesaj)
   - Error handling geliştir

3. lib/features/chat/presentation/chat_screen.dart güncelle:
   - Suggestion chip'leri dinamik yap
   - Mesaj baloncuklarına timestamp ekle
   - Copy/share fonksiyonu ekle
   - Typing indicator animasyonu ekle

4. lib/features/chat/data/chat_repository.dart oluştur:
   - Chat session yönetimi
   - Geçmiş sohbetleri listeleme

Güvenlik kuralları:
- Kriz algılama: "intihar", "kendime zarar" → 182 yönlendirmesi
- Tıbbi teşhis yapma
- Max 150 kelime yanıt
```

### Talimat 3: Firebase Entegrasyonu

```
Firebase servislerini entegre et:

1. Firebase projesini yapılandır:
   - firebase_options.dart oluştur (FlutterFire CLI)
   - google-services.json placeholder ekle

2. lib/core/services/auth_service.dart oluştur:
   - Anonim giriş
   - Google Sign-In
   - Oturum durumu yönetimi (Riverpod provider)

3. lib/core/services/sync_service.dart oluştur:
   - Hive → Firestore senkronizasyon
   - Conflict resolution (son değişiklik kazanır)
   - Offline queue (internet gelince senkronize et)

4. Firestore Security Rules:
   - Kullanıcı sadece kendi verisine erişebilsin
   - Rate limiting

Kurallar:
- Anonim giriş varsayılan olsun
- Google Sign-In opsiyonel
- Senkronizasyon arka planda çalışsın
```

### Talimat 4: Monetizasyon

```
Reklam ve premium abonelik sistemi kur:

1. lib/core/services/ad_service.dart oluştur:
   - AdMob banner (ana sayfa alt)
   - Interstitial (meditasyon sonrası)
   - Rewarded video (premium içerik kilidi açma)
   - Test ad unit ID'leri kullan

2. lib/core/services/purchase_service.dart oluştur:
   - Aylık premium: ₺29.99
   - Yıllık premium: ₺199.99
   - Satın alma doğrulama
   - Restore purchases

3. Premium özellikleri:
   - Reklamsız deneyim
   - Tüm meditasyon sesleri
   - Gelişmiş AI sohbet (sınırsız)
   - Detaylı raporlar

4. Freemium sınırları:
   - Günde 5 AI mesaj (ücretsiz)
   - 3 meditasyon türü (ücretsiz)
   - Temel ruh hali takibi
```

### Talimat 5: Test Suite

```
Kapsamlı test suite oluştur:

1. test/unit/ altında:
   - offline_storage_service_test.dart
   - ai_chat_service_test.dart
   - notification_service_test.dart

2. test/widget/ altında:
   - home_screen_test.dart
   - mood_screen_test.dart
   - meditation_screen_test.dart

3. test/integration/ altında:
   - app_navigation_test.dart
   - mood_flow_test.dart

Kurallar:
- Minimum %70 code coverage hedefle
- Mock kullan (mockito)
- Golden test ekle (UI snapshot)
```

---

## Antigravity Talimatı (Özel)

Antigravity platformuna verilecek talimat:

```
Proje: nefes-islamic-mindfulness (Flutter)
Repo: https://github.com/omerfarukkural/nefes-islamic-mindfulness

Görev: Bu Flutter projesini build edilebilir hale getir ve eksik özellikleri tamamla.

Öncelik sırası:
1. Android build yapılandırması (android/ klasörü oluştur)
2. Hive TypeAdapter'ları oluştur ve register et
3. Gemini API entegrasyonunu çalışır hale getir
4. Firebase temel yapılandırma
5. Unit testleri yaz

Teknik gereksinimler:
- Flutter 3.24+
- Dart 3.2+
- Android minSdkVersion: 21
- targetSdkVersion: 34
- compileSdkVersion: 34

Kodlama standartları:
- Riverpod ile state management
- Const constructors kullan
- Türkçe UI, İngilizce kod
- Her public metod için dartdoc yaz
- Error handling zorunlu

Yapma:
- API key'leri koda gömme
- print() kullanma (debugPrint kullan)
- setState'i provider'lar yerine kullanma
```
