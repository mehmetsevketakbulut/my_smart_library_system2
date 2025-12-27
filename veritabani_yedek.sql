-- MySQL dump 10.13  Distrib 8.0.43, for Win64 (x86_64)
--
-- Host: localhost    Database: kutuphane_db
-- ------------------------------------------------------
-- Server version	9.4.0

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `ceza`
--

DROP TABLE IF EXISTS `ceza`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ceza` (
  `id` int NOT NULL AUTO_INCREMENT,
  `odunc_id` int NOT NULL,
  `tutar` decimal(10,2) NOT NULL,
  `olusturma_tarihi` datetime DEFAULT CURRENT_TIMESTAMP,
  `odendi` tinyint(1) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `odunc_id` (`odunc_id`),
  CONSTRAINT `ceza_ibfk_1` FOREIGN KEY (`odunc_id`) REFERENCES `odunc` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ceza`
--

LOCK TABLES `ceza` WRITE;
/*!40000 ALTER TABLE `ceza` DISABLE KEYS */;
INSERT INTO `ceza` VALUES (14,51,10.00,'2025-12-25 12:55:40',1),(15,54,10.00,'2025-12-27 09:56:54',1),(16,55,5.00,'2025-12-27 10:13:36',1),(17,56,45.00,'2025-12-27 10:21:47',1),(18,57,45.00,'2025-12-27 10:21:52',1);
/*!40000 ALTER TABLE `ceza` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `ceza_log_ekle` AFTER INSERT ON `ceza` FOR EACH ROW BEGIN
    INSERT INTO denetim_log (mesaj, tarih)
    VALUES (CONCAT('Yeni ceza oluşturuldu. Odunc ID: ', NEW.odunc_id, ' Tutar: ', NEW.tutar, ' TL'), NOW());
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `denetim_log`
--

DROP TABLE IF EXISTS `denetim_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `denetim_log` (
  `id` int NOT NULL AUTO_INCREMENT,
  `mesaj` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `tarih` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `denetim_log`
--

LOCK TABLES `denetim_log` WRITE;
/*!40000 ALTER TABLE `denetim_log` DISABLE KEYS */;
INSERT INTO `denetim_log` VALUES (1,'Yeni ceza oluşturuldu. Odunc ID: 54 Tutar: 10.00 TL','2025-12-27 12:56:54'),(2,'Yeni ceza oluşturuldu. Odunc ID: 55 Tutar: 5.00 TL','2025-12-27 13:13:35'),(3,'Yeni ceza oluşturuldu. Odunc ID: 56 Tutar: 45.00 TL','2025-12-27 13:21:47'),(4,'Yeni ceza oluşturuldu. Odunc ID: 57 Tutar: 45.00 TL','2025-12-27 13:21:52');
/*!40000 ALTER TABLE `denetim_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `kategori`
--

DROP TABLE IF EXISTS `kategori`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kategori` (
  `id` int NOT NULL AUTO_INCREMENT,
  `isim` varchar(80) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `kategori`
--

LOCK TABLES `kategori` WRITE;
/*!40000 ALTER TABLE `kategori` DISABLE KEYS */;
INSERT INTO `kategori` VALUES (1,'Klasik'),(2,'Bilim Kurgu'),(3,'Macera'),(4,'Roman'),(5,'Felsefe'),(6,'Teknoloji');
/*!40000 ALTER TABLE `kategori` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `kitap`
--

DROP TABLE IF EXISTS `kitap`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kitap` (
  `id` int NOT NULL AUTO_INCREMENT,
  `ad` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `yazar_id` int DEFAULT NULL,
  `kategori_id` int DEFAULT NULL,
  `yayin_yili` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `yazar_id` (`yazar_id`),
  KEY `kategori_id` (`kategori_id`),
  CONSTRAINT `kitap_ibfk_1` FOREIGN KEY (`yazar_id`) REFERENCES `yazar` (`id`),
  CONSTRAINT `kitap_ibfk_2` FOREIGN KEY (`kategori_id`) REFERENCES `kategori` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=54 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `kitap`
--

LOCK TABLES `kitap` WRITE;
/*!40000 ALTER TABLE `kitap` DISABLE KEYS */;
INSERT INTO `kitap` VALUES (2,'Hayvan Çiftliği',1,1,1945),(3,'Denizler Altında Yüz Yıl',2,3,1870),(4,'Dünya\'nın Merkezine Seyahat',2,3,1864),(5,'Suç ve Ceza',3,1,1866),(6,'Budala',3,1,1869),(7,'Aşk ve Gurur',4,4,1813),(8,'Gurur ve Önyargı',4,4,1813),(9,'Tom Sawyer',5,3,1876),(10,'Huckleberry Finn',5,3,1884),(11,'Yaşlı Adam ve Deniz',6,3,1952),(12,'Güneş de Doğar',6,4,1926),(13,'Sefiller',7,1,1862),(14,'Notre Dame\'ın Kamburu',7,4,1831),(15,'Don Quixote',8,3,1605),(16,'Kafka on the Shore',9,4,2002),(18,'Masumiyet Müzesi',10,4,2008),(19,'Benim Adım Kırmızı',10,4,1998),(20,'Yüzyıllık Yalnızlık',11,4,1967),(21,'Cesur Yeni Dünya',12,2,1932),(22,'Dönüşüm',13,4,1915),(23,'Frankenstein',14,1,1818),(24,'Ben, Robot',15,2,1950),(25,'Vakıf',15,2,1951),(26,'Dava',13,4,1925),(27,'Körlük',11,4,1995),(28,'Beyaz Geceler',5,4,1867),(29,'Deniz Feneri',6,4,1921),(30,'Kırmızı ve Siyah',7,4,1830),(31,'Mysterious Island',2,3,1874),(32,'The Time Machine',15,2,1895),(33,'Brave New World Revisited',12,2,1958),(34,'Öteki Denizler',2,3,1886),(35,'İnsan Ne İle Yaşar',3,5,1885),(36,'A Farewell to Arms',6,4,1929),(37,'The Old Man and the Sea - Spanish',6,3,1952),(38,'The Fall',13,4,1956),(39,'Modern Teknolojinin Kökleri',15,6,2010),(40,'Felsefe 101',12,5,2000),(41,'Kayıp Zamanın İzinde',7,4,1913),(42,'Kayıp Dünya',2,3,1912),(43,'Uzayda Bir Yıl',15,2,1960),(44,'Yeni Maceralar',5,3,1900),(45,'Sonsuzluğun Şarkısı',9,4,2014),(46,'Kara Kitap',10,4,1990),(47,'Bir İdamın Günlüğü',3,4,1867),(48,'Bilim ve İnsan',15,6,1999),(49,'Teknoloji ve Gelecek',12,6,2015),(51,'Puslu Kıtalar Atlası',1001,4,1955),(52,'Ezilenler',1002,4,1861),(53,'1984',1,4,1949);
/*!40000 ALTER TABLE `kitap` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `kitap_silinince_yedekle` BEFORE DELETE ON `kitap` FOR EACH ROW BEGIN
    INSERT INTO silinen_kitaplar (id, ad, yazar_id, silinme_tarihi)
    VALUES (OLD.id, OLD.ad, OLD.yazar_id, NOW());
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `kullanici`
--

DROP TABLE IF EXISTS `kullanici`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `kullanici` (
  `id` int NOT NULL AUTO_INCREMENT,
  `isim` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(150) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sifre` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `role` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `kullanici`
--

LOCK TABLES `kullanici` WRITE;
/*!40000 ALTER TABLE `kullanici` DISABLE KEYS */;
INSERT INTO `kullanici` VALUES (1,'Ahmet Yılmaz','ahmet@ornek.com','123456','user'),(2,'Arda Kaya','arda@ornek.com','123456','user'),(3,'Arda Kaya','tahir@gmail.com','190519','user'),(4,'Tahir Gök','tahir123@gmail.com','123456','user'),(5,'Ali kapar','ali@gmail.com','1234567','user'),(6,'Mehmet Sevket Akbulut','akbulutmehmetsevket@gmail.com','19051905','admin'),(7,'Berat Berker Kaya','beratberker@gmail.com','Berat12345','user'),(8,'Fehmi İpek','fehmi@gmail.com','123456','user'),(11,'Nurten Kaval','nurten@gmail.com','123456','user'),(12,'Emirhan Topel','akbulutmehmetsevket3@gmail.com','123456','user'),(13,'İsmail Göz','mehmetsevketakbulut215@gmail.com','123456','user'),(14,'Ege Erdoğan','akbulutsevko@gmail.com','123456789','user');
/*!40000 ALTER TABLE `kullanici` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `odunc`
--

DROP TABLE IF EXISTS `odunc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `odunc` (
  `id` int NOT NULL AUTO_INCREMENT,
  `kitap_id` int NOT NULL,
  `kullanici_id` int NOT NULL,
  `odunc_tarihi` datetime DEFAULT NULL,
  `beklenen_iade` datetime DEFAULT NULL,
  `teslim_tarihi` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `kitap_id` (`kitap_id`),
  KEY `kullanici_id` (`kullanici_id`),
  CONSTRAINT `odunc_ibfk_1` FOREIGN KEY (`kitap_id`) REFERENCES `kitap` (`id`),
  CONSTRAINT `odunc_ibfk_2` FOREIGN KEY (`kullanici_id`) REFERENCES `kullanici` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=58 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `odunc`
--

LOCK TABLES `odunc` WRITE;
/*!40000 ALTER TABLE `odunc` DISABLE KEYS */;
INSERT INTO `odunc` VALUES (48,2,7,'2025-12-25 00:00:00','2025-12-25 00:00:00','2025-12-25 00:00:00'),(49,3,7,'2025-12-25 00:00:00','2025-12-25 00:00:00','2025-12-25 00:00:00'),(50,2,7,'2025-12-25 15:52:52','2025-12-25 15:53:52','2025-12-25 15:52:55'),(51,3,7,'2025-12-25 15:52:59','2025-12-25 15:53:59','2025-12-25 15:55:40'),(52,2,14,'2025-12-25 16:01:09','2025-12-25 16:02:09','2025-12-25 16:01:15'),(53,2,7,'2025-12-27 12:54:26','2025-12-27 12:55:26','2025-12-27 12:54:33'),(54,3,7,'2025-12-27 12:54:27','2025-12-27 12:55:27','2025-12-27 12:56:54'),(55,2,7,'2025-12-27 13:12:02','2025-12-27 13:13:02','2025-12-27 13:13:36'),(56,3,7,'2025-12-27 13:12:03','2025-12-27 13:13:03','2025-12-27 13:21:47'),(57,4,7,'2025-12-27 13:12:05','2025-12-27 13:13:05','2025-12-27 13:21:52');
/*!40000 ALTER TABLE `odunc` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `silinen_kitaplar`
--

DROP TABLE IF EXISTS `silinen_kitaplar`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `silinen_kitaplar` (
  `id` int DEFAULT NULL,
  `ad` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `yazar_id` int DEFAULT NULL,
  `silinme_tarihi` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `silinen_kitaplar`
--

LOCK TABLES `silinen_kitaplar` WRITE;
/*!40000 ALTER TABLE `silinen_kitaplar` DISABLE KEYS */;
INSERT INTO `silinen_kitaplar` VALUES (1,'1984',1,'2025-12-16 16:43:24');
/*!40000 ALTER TABLE `silinen_kitaplar` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `yazar`
--

DROP TABLE IF EXISTS `yazar`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `yazar` (
  `id` int NOT NULL AUTO_INCREMENT,
  `ad` varchar(120) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1003 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `yazar`
--

LOCK TABLES `yazar` WRITE;
/*!40000 ALTER TABLE `yazar` DISABLE KEYS */;
INSERT INTO `yazar` VALUES (1,'George Orwell'),(2,'Jules Verne'),(3,'Fyodor Dostoevski'),(4,'Jane Austen'),(5,'Mark Twain'),(6,'Ernest Hemingway'),(7,'Victor Hugo'),(8,'Miguel de Cervantes'),(9,'Haruki Murakami'),(10,'Orhan Pamuk'),(11,'Gabriel Garcia Marquez'),(12,'Aldous Huxley'),(13,'Franz Kafka'),(14,'Mary Shelley'),(15,'Isaac Asimov'),(1000,'Ömer Seyfettin'),(1001,'İhsan Oktay Anar'),(1002,'Fyodor Dostoyevski');
/*!40000 ALTER TABLE `yazar` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'kutuphane_db'
--

--
-- Dumping routines for database 'kutuphane_db'
--
/*!50003 DROP PROCEDURE IF EXISTS `Carpim` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `Carpim`(IN sayi1 int,
 IN sayi2 int
 )
BEGIN

SELECT sayi1 * sayi2 as carpim;

end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `GecikmisKitaplariListele` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `GecikmisKitaplariListele`()
BEGIN
    SELECT 
        k.isim AS KullaniciAdi,
        b.ad AS KitapAdi,
        o.odunc_tarihi,
        o.beklenen_iade,
        -- Gecikmeyi dakika cinsinden hesapla
        TIMESTAMPDIFF(MINUTE, o.beklenen_iade, NOW()) AS GecikmeDakikasi
    FROM odunc o
    JOIN kullanici k ON o.kullanici_id = k.id  -- BURAYI DÜZELTTİK
    JOIN kitap b ON o.kitap_id = b.id
    WHERE o.teslim_tarihi IS NULL 
      AND o.beklenen_iade < NOW();
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `kitapgetir` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `kitapgetir`(
	IN tur VARCHAR(20) 
    )
BEGIN
    Select ka.id,k1.ad,tur from kitap k1 INNER JOIN kategori ka on ka.id = k1.kategori_id  and ka.isim = tur;
    end ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-12-27 13:26:02
