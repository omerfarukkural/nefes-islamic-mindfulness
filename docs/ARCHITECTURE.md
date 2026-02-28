# 🏗️ Mimari Dokümantasyon

## Genel Bakış

Nefes uygulaması **Feature-First Clean Architecture** kullanır.

```
lib/
├── app/                    → Ana uygulama widget'ı
│   └── app.dart
├── core/                   → Çekirdek servisler
│   ├── theme/             → Tema, renkler, tipografi
│   ├── router/            → GoRouter navigasyon
│   ├── services/          → AI, bildirim, depolama servisleri
│   ├── constants/         → Sabitler, API keys
│   └── utils/             → Yardımcı fonksiyonlar
├── features/              → Özellik modülleri
│   ├── home/
│   │   ├── data/          → Repository, data sources
│   │   ├── domain/        → Models, entities
│   │   └── presentation/  → Screens, widgets
│   ├── meditation/
│   ├── chat/
│   ├── mood/
│   ├── dua/
│   ├── settings/
│   └── onboarding/
└── shared/                → Ortak bileşenler
    ├── widgets/
    ├── models/
    └── extensions/
```

## Teknoloji Yığını

| Katman | Teknoloji | Neden |
|--------|-----------|-------|
| UI Framework | Flutter 3.24+ | Cross-platform, hızlı geliştirme |
| State Management | Riverpod | Type-safe, testable, scalable |
| Navigation | GoRouter | Declarative routing, deep linking |
| Local DB | Hive + SQLite | Offline-first, hızlı, lightweight |
| AI Engine | Gemini 2.5 Flash | Ücretsiz tier, Türkçe destek |
| Backend | Firebase | Auth, Firestore, Analytics |
| Audio | just_audio | Meditasyon sesleri |
| Ads | AdMob | Monetizasyon |
| IAP | in_app_purchase | Premium abonelik |

## Veri Akışı

```
Kullanıcı → UI Widget → Riverpod Provider → Repository → 
  ├── Local (Hive/SQLite) → Offline data
  ├── Remote (Firebase) → Cloud sync
  └── AI (Gemini API) → Chat responses
```

## Güvenlik

- API anahtarları `.env` dosyasında (git'e eklenmez)
- Firebase Security Rules ile veri erişim kontrolü
- AI chat'te kriz yönetimi (intihar algılama → 182)
- Minimum 1200 kalori sınırı (beslenme önerileri)
