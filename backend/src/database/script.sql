SET @MYSQLDUMP_TEMP_LOG_BIN = @@SESSION.SQL_LOG_BIN;
SET @@SESSION.SQL_LOG_BIN= 0;

--
-- GTID state at the beginning of the backup 
--

SET @@GLOBAL.GTID_PURGED=/*!80000 '+'*/ '';

--
-- Table structure for table `appointments`
--

DROP TABLE IF EXISTS `appointments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `appointments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `sitter_id` int NOT NULL,
  `client_id` int NOT NULL,
  `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'pending',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `appointment_date` date NOT NULL,
  `appointment_range` varchar(20) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`),
  KEY `fk_client_id_users` (`client_id`),
  KEY `fk_appointments_sitter_id_users` (`sitter_id`),
  CONSTRAINT `fk_appointments_sitter_id_users` FOREIGN KEY (`sitter_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_client_id_users` FOREIGN KEY (`client_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `appointments`
--

LOCK TABLES `appointments` WRITE;
/*!40000 ALTER TABLE `appointments` DISABLE KEYS */;
/*!40000 ALTER TABLE `appointments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `messages`
--

DROP TABLE IF EXISTS `messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `messages` (
  `id` int NOT NULL AUTO_INCREMENT,
  `content` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `sitter_id` int DEFAULT NULL,
  `client_id` int DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `sitter_id` (`sitter_id`),
  KEY `client_id` (`client_id`),
  CONSTRAINT `messages_ibfk_1` FOREIGN KEY (`sitter_id`) REFERENCES `users` (`id`),
  CONSTRAINT `messages_ibfk_2` FOREIGN KEY (`client_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=883 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `messages`
--

LOCK TABLES `messages` WRITE;
/*!40000 ALTER TABLE `messages` DISABLE KEYS */;
INSERT INTO `messages` VALUES (1,'hola, quiero agendar para el día jueves?',5,2,'2025-05-17 19:50:16'),(870,'Hola, mi gato necesita medicación cada 12 horas. ¿Tienes experiencia con inyecciones?',5,1,'2025-06-03 13:10:00'),(871,'Emergencia: ¿podrías cuidar a mi perro esta noche? Tuve que viajar repentinamente.',11,2,'2025-05-22 19:05:47'),(872,'Necesito a alguien que pasee a mis 2 perros los fines de semana. ¿Tienes disponibilidad?',12,3,'2025-06-05 09:45:30'),(873,'¡Hola! Mi perro tiene ansiedad.¿Ofreces servicios de cuidado con técnicas para calmarlo?',13,4,'2025-06-04 11:20:00'),(874,'URGENTE: ¿Podrías cuidar a mi perro esta tarde? Tuve una emergencia médica. Es un bulldog francés que necesita medicamento a las 4 PM y paseo corto. ¡Gracias!',14,7,'2025-06-04 11:20:00'),(875,'hola, quiero agendar para el día juevess?',5,2,'2025-05-17 19:58:02'),(876,'hola, quiero agendar para el día juevess?',5,2,'2025-05-17 19:58:04'),(877,'hola, quiero agendar para el día juevess?',5,2,'2025-05-17 19:58:05'),(878,'hola, quiero agendar para el día juevess?',5,2,'2025-05-17 19:58:06'),(879,'hola, quiero agendar para el día juevess 27?',5,2,'2025-05-17 19:59:12'),(880,'hola, quiero agendar para el día viernes 28?',5,2,'2025-05-18 14:31:09'),(881,'hola, quiero agendar para el día viernes 28?',5,2,'2025-05-18 16:56:58'),(882,'hola, quiero agendar para el día juevess 27?',5,2,'2025-05-18 17:41:34');
/*!40000 ALTER TABLE `messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `promotions`
--

DROP TABLE IF EXISTS `promotions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `promotions` (
  `id` int NOT NULL,
  `service_id` int DEFAULT NULL,
  `discount` tinyint DEFAULT NULL,
  `valid_until` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `service_id` (`service_id`),
  CONSTRAINT `promotions_ibfk_1` FOREIGN KEY (`service_id`) REFERENCES `services` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `promotions`
--

LOCK TABLES `promotions` WRITE;
/*!40000 ALTER TABLE `promotions` DISABLE KEYS */;
/*!40000 ALTER TABLE `promotions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `schedulings`
--

DROP TABLE IF EXISTS `schedulings`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `schedulings` (
  `id` int NOT NULL AUTO_INCREMENT,
  `sitter_id` int NOT NULL,
  `appointment_date` date NOT NULL,
  `appointment_range` varchar(20) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_schedulings_sitter` (`sitter_id`,`id`),
  CONSTRAINT `schedulings_ibfk_1` FOREIGN KEY (`sitter_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `schedulings`
--

LOCK TABLES `schedulings` WRITE;
/*!40000 ALTER TABLE `schedulings` DISABLE KEYS */;
INSERT INTO `schedulings` VALUES (2,11,'2025-05-25','08:00-12:00'),(3,12,'2025-05-25','08:00-12:00'),(4,13,'2025-05-25','08:00-12:00'),(6,1,'2025-05-25','08:00-12:00');
/*!40000 ALTER TABLE `schedulings` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `services`
--

DROP TABLE IF EXISTS `services`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `services` (
  `id` int NOT NULL,
  `title` varchar(200) DEFAULT NULL,
  `price` float DEFAULT NULL,
  `sitter_id` int DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `sitter_id` (`sitter_id`),
  CONSTRAINT `services_ibfk_1` FOREIGN KEY (`sitter_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `services`
--

LOCK TABLES `services` WRITE;
/*!40000 ALTER TABLE `services` DISABLE KEYS */;
INSERT INTO `services` VALUES (2,'Paseo',25,1,'2025-05-15 11:00:00'),(3,'Entrenamiento Básico',45,5,'2025-05-15 13:00:00'),(4,'Acompañamiento al Veterinario',30,6,'2025-05-15 13:30:00'),(7,'Hospedaje por Noche',50,8,'2025-05-15 14:30:00'),(9,'Baño y Cepillado',30,10,'2025-05-15 12:30:00');
/*!40000 ALTER TABLE `services` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `encrypted_password` varchar(255) DEFAULT NULL,
  `role` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'Raul Angel Tapara Yangali','raul.tapara2@gmail.com','$2b$12$e.r/GwElsUOZ6xtNzNarBe996xSJKrePrdEPv4KCd79yi2ttMlpXW','user','2025-05-17 05:05:16'),(2,'Sheyla Mallco','sheyla.mallco@gmail.com','$2b$12$9lkji5JKy7pvvdUGgpLQuubYYCgiEq.oq1NQdP3swd.yk9Zc2n4x6','user','2025-05-17 05:06:12'),(3,'Carlos Zavala','carlos.zavala@gmail.com','$2b$12$2T0ATSL33mTFV2N8QSeNKeS26hhat4HGiFqM0hSYbaqgviIOJch0m','user','2025-05-17 05:07:00'),(4,'Daniel Toro','daniel.toro@gmail.com','$2b$12$Hf90ut5/Z4.jKzYX2kXu9uC6RwybTM.p5FF7F5TzlgcHujkK5yXny','user','2025-05-17 05:07:29'),(5,'Leidy Sullon','leidy.sullon@gmail.com','$2b$12$Y53aZighME5c2t1ATc/VXexJy2kKpQxWnOI.2xpYgElUP6EpSjUR.','sitter','2025-05-17 05:10:28'),(7,'Raul Angel Tapara Yangali','raul.tapara@gmail.com','$2b$12$pf7sRAhXTax9GCm6103x3eb22ZIOCC88VenfaAE2aIC1Y/JAQ./3.','user','2025-05-17 17:37:36'),(8,'Andre Flores','andre.flores@gmail.com','$2b$12$Z4gOVPiU1sjIBcJ8zpDyr.eNp1oxWcb3gSNWmrFywOnAzDatWr1Dm','user','2025-05-17 18:16:26'),(9,'Maria Gomez','maria.gomez@hotmail.com','$2b$12$MKQV5VZmhWzQxOQZ5tQ5BO6qko8R3p.nfacuc.wkwkfTEoSUQ21N6','user','2025-05-17 18:17:55'),(10,'Juan Perez','juan.perez@yahoo.com','$2b$12$LeG7w0ZxxvCrO7bbC5MdCOrFLzP72rwLikBjpohz8l7qzefJtocNa','user','2025-05-17 18:18:10'),(11,'Laura Mendoza','laura.mendoza@outlook.com','$2b$12$O.7YxaKUsbWoVFiYKSOtNu7NGpDFghZ3baoTNfmOQwJFbHBJcfKSC','sitter','2025-05-17 18:18:18'),(12,'Carlos Torres','carlos.torres@gmail.com','$2b$12$vSEopbxCDilanHrm4k8M.uHhEnKYaYv2r63wLWWzJfYgTSfD9gJxm','sitter','2025-05-17 18:18:25'),(13,'Ana Ramirez','ana.ramirez@hotmail.com','$2b$12$Lbr2mLWpW1QMKWOKGpZRJOuqFzFhHaFMEhvl1E4gLRfm01cKQeRHq','sitter','2025-05-17 18:18:32'),(14,'Diego Sanchez','diego.sanchez@yahoo.com','$2b$12$QxKmlLkFPNVLgcOBI6qUYee/iyli8cRX3354HKZ2Un6InybAq1P.W','sitter','2025-05-17 18:18:40'),(15,'Elena Vargas','elena.vargas@outlook.com','$2b$12$cvfw2.QOmLM.QCkvsCotZ.dfuFSKY11OSjpJ6RbugaUpz/dWqKRS2','sitter','2025-05-17 18:18:47'),(16,'Jorge Martinez','jorge.martinez@gmail.com','$2b$12$MARwWmqDHnwmdJgiadf.WeALrPP4EP/dCQqY7xBa5CkHkpqEuPOIO','sitter','2025-05-17 18:18:53'),(17,'Sofia Lopez','sofia.lopez@hotmail.com','$2b$12$7q7ZsnRXGMTuqnEExomASONdLR11.1auTUE/cRWZaZ4ir2DtwxnkW','sitter','2025-05-17 18:19:00');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'doggodb'
--
