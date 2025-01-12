# Salah - Namaz Vakitleri Uygulaması

Salah, Müslümanlar için günlük namaz vakitlerini takip etmeyi kolaylaştıran bir mobil uygulamadır. Uygulama, kullanıcının bulunduğu konuma göre namaz vakitlerini gösterir ve bir sonraki vakte ne kadar süre kaldığını bildirir.

## İndirme

En son sürümü [GitHub Releases](https://github.com/emnznlg/salah-android-app/releases) sayfasından indirebilirsiniz.

### Sürüm Geçmişi

- v1.0.0 (13.01.2024)
  - İlk kararlı sürüm
  - Temel namaz vakti gösterimi
  - Konum seçimi ve arama
  - Offline mod desteği
  - Karanlık/Aydınlık tema
  - API entegrasyonu ve optimizasyonlar

## Özellikler

- 📍 Konum bazlı namaz vakitleri
- ⏰ Tüm namaz vakitlerinin listesi
- ⌛ Sonraki vakte kalan süre gösterimi
- 🌓 Karanlık/Aydınlık tema desteği
- 🔄 Konum güncelleme imkanı
- 🔍 Şehir ve ilçe arama özelliği
- 📱 Özelleştirilmiş uygulama ikonu
- 🌐 Offline mod desteği
- ⚡ Hızlı açılış ve düşük kaynak kullanımı

## Teknik Detaylar

### Genel Yapı
- Flutter framework ile geliştirilmiştir
- Provider pattern ile state management
- Material 3 tasarım dili
- Responsive tasarım
- SharedPreferences ile yerel veri saklama

### API Entegrasyonu
Uygulama [ezanvakti.emushaf.net](https://ezanvakti.emushaf.net) API'sini kullanmaktadır. API istekleri şu şekilde yapılandırılmıştır:

- Base URL: `https://ezanvakti.emushaf.net`
- Timeout süresi: 10 saniye
- İstek limiti: Saniyede 1 istek
- Karakter kodlaması: UTF-8

#### API Endpointleri:
1. Ülke Listesi: `/ulkeler`
2. Şehir Listesi: `/sehirler/{ulkeKodu}`
3. İlçe Listesi: `/ilceler/{sehirKodu}`
4. Namaz Vakitleri: `/vakitler/{ilceKodu}`

### Offline Mod
- Namaz vakitleri yerel olarak saklanır
- İnternet bağlantısı olmadığında yerel veriler kullanılır
- Veri senkronizasyonu otomatik yapılır

### Güvenlik Özellikleri
- HTTPS kullanımı
- API isteklerinde rate limiting
- Hata durumlarının güvenli yönetimi
- Bağlantı kontrolü

### Performans Optimizasyonları
- Lazy loading
- Önbellekleme
- Minimum internet kullanımı
- Düşük RAM kullanımı

## Gereksinimler

- Flutter SDK (^3.6.0)
- Android Studio veya VS Code
- Java Development Kit 17
- Android SDK

## Kurulum

1. Projeyi klonlayın:
```bash
git clone https://github.com/emnznlg/salah-android-app.git
```

2. Bağımlılıkları yükleyin:
```bash
flutter pub get
```

3. Uygulamayı çalıştırın:
```bash
flutter run
```

## Kullanılan Paketler

- `provider: ^6.1.1` - State management
- `shared_preferences: ^2.2.2` - Yerel veri saklama
- `http: ^1.1.2` - API istekleri
- `intl: ^0.19.0` - Tarih/saat formatlama
- `connectivity_plus: ^5.0.2` - İnternet bağlantısı kontrolü

## Katkıda Bulunma

1. Bu depoyu fork edin
2. Yeni bir branch oluşturun (`git checkout -b feature/amazing-feature`)
3. Değişikliklerinizi commit edin (`git commit -m 'Add some amazing feature'`)
4. Branch'inizi push edin (`git push origin feature/amazing-feature`)
5. Bir Pull Request oluşturun

## Teşekkürler

- API için Furkan Tektaş'a (https://furkantektas.com/)
- Material Design ikonları için Google'a
- Namaz vakti ikonları için Freepik'e (https://www.freepik.com)
- Flutter ve Dart ekibine

## Lisans

Bu proje MIT lisansı altında lisanslanmıştır. Detaylar için [LICENSE](LICENSE) dosyasına bakın.
