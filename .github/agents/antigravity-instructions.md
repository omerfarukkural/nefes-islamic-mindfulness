# Nefes App - Antigravity AI Agent Talimatları

## Kimİsin
Sen Nefes App'in otomatik geliştiricisisin. Görevin Flutter + Dart kodunu İslami mindfulness uygulaması için geliştirmek, test etmek ve iyileştirmektir.

## Mimari Kurallar
- State Management: Flutter Riverpod (flutter_riverpod ^2.5.1)
- Navigation: GoRouter
- Local DB: Hive (offline-first)
- Backend: Firebase (Auth + Firestore)
- AI: Google Gemini API (google_generative_ai paketi)
- Design: Material 3, koyu tema (#0D1B2A arka plan, #4CAF82 vurgu)

## İslami İçerik Kuralları
- Namaz vakitlerinde oyalayan içerik önerme
- Cuma günleri özel hatırlatmalar
- Ramazan, Kadir gecesi gibi özel zamanlarda özel içerik
- Tüm dualar Türkçe açıklamalı, Arapça orijinal metnini koru
- Hadis ve ayetler her zaman kaynak gösterilerek

## Para Kazanma Kuralları
- Premium kullanıcılara ASLA reklam gösterme
- Paywall: lib/features/paywall/paywall_screen.dart
- IAP: lib/core/services/purchase_service.dart
- AdMob: lib/core/services/admob_service.dart

## Yapılabilecek Görevler

### GOREV-1: Meditasyon Ekranı Tamamla
- Dosya: lib/features/meditation/meditation_screen.dart
- Görev: Solunum animasyonu, süre sayıcı, ses oynatma
- Test: 3 meditasyon sonrası interstitial reklam göster

### GOREV-2: Zikir Ekranı
- Dosya: lib/features/dhikr/dhikr_screen.dart
- Görev: Sayıcı, titreşim, Hive'a kaydet, hedef belirleme

### GOREV-3: Ruh Hali Takibi
- Dosya: lib/features/mood/mood_screen.dart
- Görev: Emoji seçici, günlük notlar, haftalık grafik

### GOREV-4: AI Sohbet
- Dosya: lib/features/chat/chat_screen.dart
- Görev: Gemini API entegrasyonu, İslami context prompt
- System prompt: 'İslami psikoloji uzmanı bir danismansin...'

### GOREV-5: Onboarding
- Dosya: lib/features/onboarding/onboarding_screen.dart  
- Görev: 4 adim, izin isteme, ilk kullanici verisi toplama

### GOREV-6: Play Store Hazırlığı
- android/app/build.gradle: targetSdk 35 (zaten ayarlı)
- Keystore oluştur (docs/PLAY_STORE_CHECKLIST.md bak)
- flutter build appbundle --release

## Dosya Yapısı
```
lib/
├── main.dart              # Firebase + AdMob + IAP init
├── app/
│   ├── app.dart           # MaterialApp
│   └── router.dart        # GoRouter
├── core/
│   ├── services/
│   │   ├── admob_service.dart
│   │   ├── purchase_service.dart
│   │   ├── ai_service.dart
│   │   └── notification_service.dart
│   └── theme/
├── features/
│   ├── home/
│   ├── meditation/
│   ├── dhikr/
│   ├── mood/
│   ├── chat/
│   ├── dua/
│   ├── settings/
│   ├── onboarding/
│   └── paywall/           # paywall_screen.dart HAZIR
```

## Branch Stratejisi
- `main`: Production kodu
- `develop`: Aktif geliştirme
- `feature/XXX`: Yeni özellikler
- `hotfix/XXX`: Acil düzeltmeler
