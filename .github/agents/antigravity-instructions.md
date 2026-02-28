# 🚀 Antigravity / AI Coding Agent - Tam Talimat

## Proje Bilgileri
- **Proje:** Nefes - AI Destekli İslami Mindfulness & Mental Sağlık Uygulaması
- **Repo:** https://github.com/omerfarukkural/nefes-islamic-mindfulness
- **Branch:** main
- **Dil:** Dart/Flutter
- **Mimari:** Feature-First Clean Architecture + Riverpod

---

## ÖNCELİK SIRASI (Bunu takip et)

### Görev 1: Android Build Yapılandırması
```
android/ klasörünü oluştur:
- build.gradle (project-level): classpath, repositories
- app/build.gradle:
  - minSdkVersion: 21
  - targetSdkVersion: 35
  - compileSdkVersion: 35
  - versionCode: 1
  - versionName: "1.0.0"
  - multiDexEnabled: true
  - proguard-rules.pro (release shrink)
- app/src/main/AndroidManifest.xml:
  - INTERNET izni
  - RECEIVE_BOOT_COMPLETED (bildirimler için)
  - application label: Nefes
  - icon placeholder
- gradle.properties: android.useAndroidX=true, kotlin.code.style=official
- settings.gradle: plugins DSL
- local.properties: placeholder
```

### Görev 2: Hive TypeAdapter'ları
```
lib/core/models/ altında:
- mood_entry.dart → @HiveType(typeId: 0)
  - id (String), value (int 1-5), note (String?), createdAt (DateTime)
- meditation_session.dart → @HiveType(typeId: 1)
  - id, type (String), durationSeconds (int), completedAt (DateTime)
- chat_message.dart → @HiveType(typeId: 2)
  - id, content (String), isUser (bool), timestamp (DateTime)

lib/core/services/offline_storage_service.dart:
- initHive(): Adapter register + box open
- CRUD: saveMood, getMoods, deleteMood
- CRUD: saveSession, getSessions
- CRUD: saveChatMessage, getChatHistory
- getStats(): toplam dakika, streak, oturum sayısı
```

### Görev 3: Tüm Ekranları Çalışır Hale Getir
```
lib/features/home/presentation/home_screen.dart:
- Selam mesajı (Günaydın/İyi akşamlar + isim)
- Günlük ayet kartı
- Ruh hali giriş butonu
- Hızlı erişim: Meditasyon, Dua, Chat
- İstatistik kartları (gerçek Hive verisi)

lib/features/mood/presentation/mood_screen.dart:
- 5 emoji seçimi (çok kötü → çok iyi)
- Not ekleme alanı
- Son 7 gün chart (fl_chart)
- Kaydet → Hive

lib/features/meditation/presentation/meditation_screen.dart:
- Meditasyon türleri listesi (nefes, zikir, tefekkür, şükür)
- Zamanlayıcı (CountdownTimer)
- Başlat/Duraklat/Bitir kontrolleri
- Tamamlandığında → Hive'a kaydet
- Ambient ses (opsiyonel, just_audio)

lib/features/chat/presentation/chat_screen.dart:
- Mesaj baloncukları (kullanıcı: sağ/mavi, AI: sol/yeşil)
- Öneri chip'leri: "Bugün stresli hissediyorum", "Dua öner", "Kur'an ayeti"
- Typing indicator
- Gemini API entegrasyonu
- Kriz algılama: intihar/zarar kelimeleri → 182 uyarısı

lib/features/dua/presentation/dua_screen.dart:
- Kategoriler: Sabah, Akşam, Yemek, Yolculuk, Sınav
- Arapça + Türkçe metin
- Favori ekleme
- Paylaşma butonu

lib/features/settings/presentation/settings_screen.dart:
- Tema değiştir (dark/light)
- Bildirim ayarları
- Dil seçimi
- Hesap (giriş/çıkış)
- Geri bildirim gönder
- Hakkında

lib/features/onboarding/presentation/onboarding_screen.dart:
- 3-4 sayfa PageView
- Lottie animasyonları
- "Başla" butonu → Home'a yönlendir
- SharedPreferences ile "gösterildi" flag
```

### Görev 4: Router & Navigation
```
lib/core/router/app_router.dart:
- GoRouter ile tüm route'ları tanımla
- BottomNavigationBar: Home, Meditate, Chat, Dua, Settings
- Deep link desteği
```

### Görev 5: Theme & Styling
```
lib/core/theme/app_theme.dart:
- Light theme: yeşil tonları, krem arka plan
- Dark theme: koyu yeşil, siyah arka plan
- Typography: Amiri (Arapça), Roboto (genel)
- Material 3 color scheme
- Custom widget temaları (card, button, input)
```

### Görev 6: Test Suite
```
test/unit/:
- offline_storage_service_test.dart
- ai_chat_service_test.dart

test/widget/:
- home_screen_test.dart
- mood_screen_test.dart
- meditation_screen_test.dart

Mockito kullan, min %70 coverage hedefle.
```

---

## KODLAMA STANDARTLARI

1. **State Management:** Riverpod (flutter_riverpod + riverpod_annotation)
2. **Const constructors:** Her yerde kullan
3. **Dil:** UI → Türkçe, Kod → İngilizce
4. **Dartdoc:** Her public method/class için
5. **Error handling:** try-catch zorunlu, debugPrint kullan
6. **API Keys:** Asla koda gömme, --dart-define kullan
7. **print() YASAK:** debugPrint() kullan
8. **setState YASAK:** Riverpod provider kullan

## TEKNİK GEREKSİNİMLER
- Flutter: 3.24+
- Dart: 3.2+
- Android Min SDK: 21
- Target SDK: 35
- Compile SDK: 35
