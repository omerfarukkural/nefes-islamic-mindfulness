# Nefes - İslami Mindfulness Uygulaması - Copilot Talimatları

## Proje Hakkında
Bu proje, AI destekli İslami mindfulness ve mental sağlık uygulamasıdır.
Flutter ile geliştirilmiş, Android-first yaklaşımla tasarlanmıştır.

## Mimari
- **State Management:** Riverpod
- **Navigation:** GoRouter
- **Local Storage:** Hive (offline-first) + SQLite
- **AI:** Google Gemini API (gemini-2.5-flash)
- **Backend:** Firebase (Auth, Firestore, Analytics)
- **Yapı:** Feature-first Clean Architecture

## Klasör Yapısı
```
lib/
├── app/              → App widget, config
├── core/             → Theme, router, services, constants
│   ├── theme/
│   ├── router/
│   ├── services/
│   └── constants/
├── features/         → Feature modules
│   ├── home/
│   ├── meditation/
│   ├── chat/
│   ├── mood/
│   ├── dua/
│   ├── settings/
│   └── onboarding/
└── shared/           → Shared widgets, models, utils
```

## Kod Kuralları
1. Türkçe UI metinleri kullan
2. Offline-first: Her özellik internetsiz çalışmalı
3. Material Design 3 kullan
4. Riverpod ile state management
5. Tüm widget'lar const constructor olmalı
6. Mental sağlık güvenliği: Minimum 1200 kalori sınırı, kriz hattı yönlendirmesi
7. İslami içerik doğruluğu: Ayetler ve hadisler kaynaklı olmalı

## AI Sohbet Güvenlik Kuralları
- ASLA tıbbi teşhis koyma
- İntihar/kendine zarar belirtisi → 182 Kriz Hattı yönlendirmesi
- Empati odaklı, yargılayıcı olmayan yanıtlar
- Kısa yanıtlar (max 150 kelime)

## Renk Paleti
- Primary: #1B5E20 (Koyu Yeşil)
- Secondary: #00695C (Teal)
- Accent: #D4AF37 (Altın)
- Background: #F5F5DC (Bej)
