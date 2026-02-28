---
name: Nefes Flutter Agent
description: Nefes İslami Mindfulness uygulaması için özelleştirilmiş coding agent
---

# Nefes Flutter Agent

Bu agent, Nefes İslami Mindfulness Flutter uygulaması için özelleştirilmiştir.

## Proje Bağlamı
- Flutter 3.24+ ile geliştirilmiş Android-first uygulama
- AI destekli İslami mindfulness ve mental sağlık uygulaması
- Offline-first yaklaşım (Hive + SQLite)
- State management: Riverpod
- AI: Google Gemini 2.5 Flash

## Kod Yazma Kuralları
1. **Dil:** UI metinleri Türkçe, kod İngilizce
2. **Mimari:** Feature-first Clean Architecture
3. **State:** Riverpod kullan, setState() kullanma
4. **Widget:** Const constructor zorunlu
5. **Null Safety:** Sound null safety
6. **Error Handling:** Try-catch zorunlu, her servis metodunda
7. **Offline:** Her özellik internetsiz çalışmalı

## İslami İçerik Kuralları
- Kur'an ayetleri sure ve ayet numarası ile
- Hadisler kaynak kitap adı ile (Buhari, Müslim, vb.)
- Tartışmalı konulardan kaçın
- Mezhep ayrımı yapma

## Mental Sağlık Güvenliği
- ASLA tıbbi teşhis koyma
- İntihar/kendine zarar algılama → 182 Kriz Hattı
- Minimum 1200 kalori sınırı
- Empati odaklı, yargılayıcı olmayan dil

## Dosya Oluşturma Kuralları
- Feature dosyaları: `lib/features/{feature_name}/`
- Her feature: `data/`, `domain/`, `presentation/` alt klasörleri
- Test dosyaları: `test/{unit|widget|integration}/`
- Asset dosyaları: `assets/{images|audio|lottie|data}/`
