# Antrenman Uygulaması - Flutter

Bu proje, kullanıcıların antrenmanlarını takip edebileceği ve çeşitli egzersizleri yapabileceği bir Flutter uygulamasıdır. Uygulama, kullanıcıların antrenman geçmişlerini kaydetmelerine ve motivasyonlarını artırmalarına yardımcı olur.

## Uygulama Özellikleri

### 1. **Kullanıcı Girişi ve Kaydı**
Uygulama, kullanıcıların Firebase Authentication ile güvenli bir şekilde giriş yapmalarını ve yeni hesaplar oluşturmalarını sağlar. Kullanıcılar kayıt olduktan sonra, antrenman geçmişi ve profilleri kaydedilir.

### 2. **Antrenmanlar**
Uygulama, farklı egzersizlerden oluşan antrenman programlarını kullanıcıya sunar. Her antrenman için hedefler belirlenebilir ve kullanıcılar bu hedeflere ulaşmak için egzersizleri tamamlayabilirler.

### 3. **Motivasyon Mesajları**
Kullanıcıların antrenmanlarını daha motive bir şekilde yapabilmesi için, her girişte motivasyon mesajları gösterilir. Bu mesajlar, Firebase Firestore veritabanında depolanır ve her kullanıcının profil sayfasında güncellenebilir.

### 4. **Profil Sayfası**
Kullanıcılar, kendi profillerini görüntüleyebilir ve güncelleyebilir. Profilde, kişisel bilgileri, motivasyon mesajları ve antrenman geçmişi yer alır. Firebase Firestore ile senkronize edilen bu bilgiler her zaman güncel tutulur.

### 5. **Firebase Firestore Entegrasyonu**
Uygulama, Firebase Firestore kullanarak kullanıcı bilgilerini, antrenman verilerini ve motivasyon mesajlarını depolar. Firestore veritabanı ile tüm veriler anlık olarak senkronize edilir ve kullanıcı deneyimi sürekli olarak güncellenir.

### 6. **Veri Senkronizasyonu**
Uygulama, Firebase Firestore ile tam entegrasyona sahiptir. Kullanıcıların profilleri, antrenman verileri ve motivasyon mesajları her cihazda senkronize edilir. Bu sayede kullanıcı, uygulamayı farklı cihazlarda kullanabilir ve verileri kaybolmaz.

### 7. **Dinamik Antrenman Takibi**
Kullanıcılar, uygulama üzerinden kendi antrenmanlarını takip edebilirler. Her egzersiz için tamamlanan set ve tekrar sayıları kaydedilir ve kullanıcılar ilerlemelerini görebilirler. Ayrıca, ilerleyen zamanlarda daha zorlu antrenman planları önerilebilir.

## Kullanıcı Deneyimi

- **Kullanıcı Arayüzü**: Modern ve kullanıcı dostu bir arayüz tasarımı ile antrenmanlar kolayca takip edilebilir. Uygulama, Flutter ile geliştirildiği için yüksek performans sağlar ve hızlı çalışır.
- **Motivasyon**: Uygulama, kullanıcıları motive etmek için antrenmanlardan önce ve sonra kişiselleştirilmiş mesajlar gösterir.
- **Esneklik**: Uygulama, farklı seviyelerde kullanıcılar için uygun antrenmanlar sunar. Kullanıcılar, antrenmanlarını kişisel hedeflerine göre özelleştirebilirler.

## Geliştirici Notları

Bu uygulama, Flutter ve Firebase'in gücünden yararlanarak mobil uygulama geliştirme becerilerini artırmaya yönelik bir projedir. Firebase Auth ve Firestore entegrasyonu, gerçek zamanlı veri senkronizasyonu için güçlü bir altyapı sunar. Uygulama, kullanıcıların sağlıklı yaşam hedeflerine ulaşmalarına yardımcı olmak için tasarlanmıştır.

