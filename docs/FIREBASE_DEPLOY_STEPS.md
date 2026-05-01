# 🔥 Firebase Hosting Deploy Rehberi

## Ön Koşullar

```bash
# Node.js kurulu olmalı
npm install -g firebase-tools

# Giriş yap
firebase login
```

## Adım Adım Deploy

### 1. Firebase Projesi Oluştur
1. https://console.firebase.google.com adresine git
2. "Yeni proje" → Ad: `nefes-app`
3. Google Analytics: Açık
4. Hosting → Başlat

### 2. `.firebaserc` Dosyasını Güncelle
```bash
# Projenin ID'sini al
firebase projects:list

# .firebaserc dosyasında PROJE_ID'yi gerçek ID ile değiştir
```

### 3. Web Build Al
```bash
cd /nefes-islamic-mindfulness
flutter pub get
flutter build web --release --web-renderer canvaskit
```

### 4. Firebase'e Deploy Et
```bash
firebase deploy --only hosting
```

### 5. mutluet.org Domain Bağlantısı

```bash
# Firebase Console'da:
# Hosting → "Custom domain ekle" → mutluet.org yaz
```

Firebase sana 2 DNS kaydı verecek:
```
A kaydı 1: 151.101.1.195
A kaydı 2: 151.101.65.195
TXT kaydı: hosting-site=PROJE_ID_BURAYA
```

Bu kayitları domain sağlayıcında (Nerede satın aldıysan - isimtescil.net, natro.com, vs.) DNS yönetim panelindeekle.

**Yayılma süresi**: 24-48 saat (genellikle 1-2 saat içinde tamamlanır)

### 6. HTTPS Otomatik
 Firebase otomatik olarak Let's Encrypt sertifikası ekler. İşlem tamamlandığında:
- https://mutluet.org → Nefes uygulaması
- HTTP → HTTPS otomatik yönlendirme

---

## Sorun Giderme

### "Permission denied" hatası
```bash
firebase logout
firebase login
```

### Build hatası (canvaskit)
```bash
# html renderer ile dene
flutter build web --release --web-renderer html
```

### Domain doğrulanmıyor
- DNS kaydedildikten sonra 24 saat bekle
- `nslookup mutluet.org` ile kontrol et

---

## Firebase Free Tier Limitleri

| Kaynak | Ücretsiz Limit |
|--------|----------------|
| Hosting depolama | 10 GB |
| Hosting bant genişliği | 360 MB/gün |
| Firestore okuma | 50.000/gün |
| Firestore yazma | 20.000/gün |
| Authentication | Sınırsız |
| Cloud Functions | 125.000 çağrı/ay |

**Not**: 1000 aktif kullanıcıya kadar ücretsiz tier yeterlidir.
