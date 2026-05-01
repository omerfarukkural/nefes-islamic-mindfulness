# 🚀 Google Play Store Yayınlama Rehberi - Nefes App

## Ön Koşullar

### 1. Google Play Gelistirici Hesabı
- [ ] https://play.google.com/console adresine git
- [ ] "Hesap oluştur" → 25$ tek seferlik ücret öde
- [ ] Kimlik doğrulaması tamamla (pasaport/kimlik gerekebilir)

### 2. Keystore Oluşturma (ZORUNLU - Bir kez yap, sakla!)
```bash
# Projenin android/ klasöründe yeni klasör oluştur
mkdir -p android/keystore

# Keystore oluştur
keytool -genkey -v \
  -keystore android/keystore/nefes-release-key.jks \
  -alias nefes-key \
  -keyalg RSA \
  -keysize 2048 \
  -validity 10000

# .gitignore'a ekle:
echo "android/keystore/" >> .gitignore
echo "android/key.properties" >> .gitignore
```

> ⚠️ **ÇOK ÖNEMLİ**: Keystore dosyasını kaybet birsen uygulamanı bir daha güncelleyemezsin!
> - Bulut depolamaya (Google Drive, OneDrive) yedekle
> - Farklı bir fiziksel konuma da kaydet

### 3. android/key.properties dosyası oluştur
```
storePassword=BURAYA_SIFREN
keyPassword=BURAYA_KEY_SIFRESI
keyAlias=nefes-key
storeFile=../keystore/nefes-release-key.jks
```

### 4. android/app/build.gradle'da keystoreProperties yükle
Dosyanın en üstteki kodu:
```groovy
def keystorePropertiesFile = rootProject.file("key.properties")
def keystoreProperties = new Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}
```
Bu kodu `android/app/build.gradle` başına ekle.

---

## Build Alma

### AAB (App Bundle) - Play Store için
```bash
# Proje kökünde
flutter build appbundle --release

# Çıktı yolu:
# build/app/outputs/bundle/release/app-release.aab
```

### Test APK üretimi
```bash
flutter build apk --release --split-per-abi
# arm64-v8a, armeabi-v7a, x86_64 için ayrı APK'ler üretilir
```

---

## Play Console Adımları

### Uygulama Oluşturma
1. Play Console → "Uygulama oluştur"
2. Ad: **Nefes - İslami Mindfulness**
3. Varsayılan dil: Türkçe
4. Uygulama veya oyun: **Uygulama**
5. Ücretli veya ücretsiz: **Ücretsiz** (IAP ile para kazanılır)

### Store Listing (Mağaza Sayfası)
- [ ] Kısa açıklama (80 karakter): `AI destekli İslami zikir, meditasyon ve ruh hali takibi`
- [ ] Uzun açıklama (4000 karakter): Detaylı özellik listesi
- [ ] Ekran görüntüleri: Min 2 adet (1080x1920 veya 1080x2340)
- [ ] Öne çıkan grafik: 1024x500 px
- [ ] Uygulama simgesi: 512x512 PNG
- [ ] Kategori: Sağlık ve Zindelik
- [ ] İletisim emaili: omerfarukkural@...

### İçerik Derecelendirmesi
- [ ] IARC anketini doldur → Herkes (3+) çıkmalı
- [ ] İslâmi içerik var, dinsel referans belirt

### Uygulaması Yükleme
```
Play Console → Release → Production → 
New release → Upload AAB → Review → Rollout
```

### İlk Incöleme Testi (ZORUNLU)
Play Store yeni uygulamalara artık **20 test kullanıcısı zorunluluğu** getirebilir.
- Kapalı test (Internal Testing) ile başla
- 14 gün boyunca 20+ kullanıcı ile test yap
- Sonra Production’a geç

---

## In-App Purchase Kurulumu

### Play Console → Monetize → Products

#### Abonelikler:
1. `nefes_premium_monthly`
   - Ad: Nefes Premium Aylık
   - Fiyat: ₺79,99 / ay
   - Deneme: 7 gün ücretsiz

2. `nefes_premium_yearly`
   - Ad: Nefes Premium Yıllık
   - Fiyat: ₺399,99 / yıl
   - Deneme: 14 gün ücretsiz

3. `nefes_lifetime` (Tek seferlik)
   - Ad: Nefes Ömür Boyu
   - Fiyat: ₺999,99

---

## AdMob Kurulumu

1. https://admob.google.com → Uygulama ekle
2. Uygulama adı: Nefes - İslami Mindfulness
3. Platform: Android
4. Reklam birimleri oluştur:
   - Banner: Ana ekran alt
   - Interstitial: Her 3 meditasyon sonrası
   - Rewarded: Premium içerik kilidi açma
5. Gerçek ID’leri `lib/core/services/admob_service.dart`'a yaz
6. `android/app/src/main/AndroidManifest.xml`'e ekle:
```xml
<meta-data
    android:name="com.google.android.gms.ads.APPLICATION_ID"
    android:value="ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX"/>
```

---

## GitHub Secrets (CI/CD için)

GitHub → Settings → Secrets → Actions’a ekle:

| Secret Adı | Değeri |
|-----------|--------|
| `KEYSTORE_BASE64` | `base64 android/keystore/nefes-release-key.jks` komutu çıktısı |
| `KEY_STORE_PASSWORD` | Keystore şifren |
| `KEY_PASSWORD` | Key şifren |
| `FIREBASE_SERVICE_ACCOUNT` | Firebase Console'dan JSON |
| `GEMINI_API_KEY` | Google AI Studio'dan API key |

---

## mutluet.org Firebase Hosting Bağlantısı

### Adim 1: Firebase Console
1. https://console.firebase.google.com → Projeyi seç
2. Hosting → "Add custom domain"
3. Domain: `mutluet.org` yaz
4. Sana verilecek DNS kayıtlarını not al

### Adım 2: Domain Yöneticisinde (Nerede barındırıyorsun: Turkticaret/Isimtescil/etc.)
```
Tip: A     Host: @    Deger: 151.101.1.195
Tip: A     Host: @    Deger: 151.101.65.195
Tip: TXT   Host: @    Deger: hosting-site=PROJE_ID
```
(Firebase sana özel değerler verecek)

### Adım 3: Deploy
```bash
# Yerel gelistirme ortamında:
flutter build web --release
firebase deploy --only hosting:mutluet

# Ya da GitHub Actions otomatik deploy eder
```

### Yayın sonrası kontrol:
- https://mutluet.org → Nefes web uygulaması açılmalı
- HTTPS sertifikası otomatik eklenir (Let's Encrypt)
