# AKILLI KÜTÜPHANE YÖNETİM SİSTEMİ (SMART LIBRARY MANAGEMENT SYSTEM)

## 1. PROJE ÖZETİ VE AMACI
Bu proje, Veritabanı Yönetim Sistemleri dersi kapsamında geliştirilmiş, web tabanlı bir kütüphane otomasyon yazılımıdır. Projenin temel amacı; kütüphane envanterinin yönetimi, ödünç alma-iade süreçlerinin takibi ve gecikme cezalarının dinamik olarak hesaplanmasını sağlayan bütünleşik bir sistem oluşturmaktır.

Sistem, veri tutarlılığını (Data Integrity) sağlamak adına İlişkisel Veritabanı Yönetim Sistemi (RDBMS) prensiplerine sadık kalınarak tasarlanmıştır.

## 2. KULLANILAN TEKNOLOJİLER VE MİMARİ

Proje, Katmanlı Mimari (Layered Architecture) prensibi ile geliştirilmiştir.

* **Programlama Dili:** Python 3.10+
* **Web Çatısı (Framework):** Flask
* **Veritabanı:** MySQL
* **ORM (Object Relational Mapping):** SQLAlchemy
* **Arayüz (Frontend):** HTML5, CSS3, Bootstrap 5, JavaScript (ES6)
* **Sürüm Kontrol:** Git

## 3. VERİTABANI TASARIMI VE GELİŞMİŞ ÖZELLİKLER

Veritabanı şeması, veri tekrarını önlemek ve sorgu performansını artırmak amacıyla 3. Normal Form (3NF) seviyesinde normalize edilmiştir. Proje kapsamında aşağıdaki ileri seviye veritabanı nesneleri kullanılmıştır:

### 3.1. Saklı Yordamlar (Stored Procedures)
* **`GecikmisKitaplariListele`**: Yönetici paneli için tasarlanmıştır. İade tarihi geçmiş ancak henüz teslim edilmemiş kitapları ve ilgili kullanıcı bilgilerini, gecikme süresi (dakika bazlı) ile birlikte raporlar. Karmaşık JOIN işlemleri veritabanı tarafında derlenerek performans artışı sağlanmıştır.

### 3.2. Tetikleyiciler (Triggers)
* **`ceza_log_ekle`**: `Ceza` tablosuna yapılan her veri girişi (INSERT) işlemi sonrasında tetiklenir. Oluşan cezanın detaylarını ve zaman damgasını `denetim_log` (Audit Log) tablosuna otomatik olarak kaydeder. Bu yapı, finansal işlemlerin güvenliğini ve izlenebilirliğini sağlar.

### 3.3. Transaction Yönetimi (ACID)
Ödünç alma ve iade işlemleri, veri bütünlüğünün bozulmaması adına atomik işlemler (Transaction) olarak kurgulanmıştır. Olası bir hata durumunda `rollback` mekanizması devreye girer.

## 4. SİSTEM FONKSİYONLARI

### Yönetici (Admin) Modülü
* **Envanter Yönetimi:** Yeni kitap ekleme, mevcut kitapları güncelleme ve silme.
* **Kullanıcı Takibi:** Sisteme kayıtlı kullanıcıların ve rollerin görüntülenmesi.
* **Raporlama:** Gecikmedeki kitapların anlık olarak listelenmesi (Stored Procedure entegrasyonu).
* **İşlem Kısıtlaması:** Yöneticiler, kullanıcı arayüzündeki operasyonel işlemleri (iade vb.) görüntüleyemez, sadece yönetimsel araçlara erişebilir.

### Kullanıcı (User) Modülü
* **Katalog Tarama:** Kitap adı, yazar veya kategoriye göre filtreleme.
* **Ödünç Alma:** Stok durumuna göre kitap kiralama işlemi.
* **Profil Yönetimi:** Mevcut ödünç alınan kitapların ve iade tarihlerinin takibi.
* **İade ve Ceza:** Kitap iadesi sırasında sistem, teslim tarihini kontrol eder. Gecikme varsa dakika bazlı ceza hesaplayarak kullanıcıya yansıtır.

## 5. KURULUM ADIMLARI

Projeyi yerel ortamda çalıştırmak için aşağıdaki adımları izleyiniz:

**1. Projeyi Klonlayın:**
''terminal
git clone https://github.com/mehmetsevketakbulut/my_smart_library_system2.git
proje klasorune gidin
**2. GEREKLİ KÜTÜPHANELERİ YÜKLEYİN
pip install -r requirements.txt

**3. Veritabanı Kurulumu:
MySQL sunucunuzda library adında bir veritabanı oluşturun.
Proje dizininde bulunan veritabani_yedek.sql dosyasını MySQL Workbench veya terminal aracılığıyla içe aktarın .

**4. Projeyi başlatın
python run.py

**5. PROJEYİ YAPAN
-MEHMET ŞEVKET AKBULUT
