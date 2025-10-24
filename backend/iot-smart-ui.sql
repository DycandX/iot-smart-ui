-- ======================================================
-- Database: iot-smart-ui
-- Struktur lengkap untuk sistem IoT DHT + kontrol LED
-- ======================================================

CREATE DATABASE IF NOT EXISTS `iot-smart-ui` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `iot-smart-ui`;

-- ======================================================
-- 1️⃣  Tabel devices → menyimpan daftar perangkat
-- ======================================================
CREATE TABLE IF NOT EXISTS `devices` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) DEFAULT NULL,
  `api_key` VARCHAR(100) NOT NULL,
  `location` VARCHAR(100) DEFAULT NULL,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Tambah perangkat contoh
INSERT INTO `devices` (`name`, `api_key`, `location`) 
VALUES ('ESP32-DHT', 'APIKEY_SIM_ABC123456789', 'Mulawarman Hill A4');

-- ======================================================
-- 2️⃣  Tabel sensor_data → menyimpan data suhu, kelembapan, tekanan, baterai
-- ======================================================
CREATE TABLE IF NOT EXISTS `sensor_data` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `device_id` INT(11) NOT NULL,
  `temperature` FLOAT DEFAULT NULL,
  `humidity` FLOAT DEFAULT NULL,
  `pressure` FLOAT DEFAULT NULL,
  `battery` INT DEFAULT NULL,
  `timestamp` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`device_id`) REFERENCES `devices`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ======================================================
-- 3️⃣  Tabel commands → menyimpan perintah (misalnya LED on/off)
-- ======================================================
CREATE TABLE IF NOT EXISTS `commands` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `device_id` INT(11) NOT NULL,
  `command` VARCHAR(50) NOT NULL,
  `value` VARCHAR(50) NOT NULL,
  `executed` TINYINT(1) DEFAULT 0,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`device_id`) REFERENCES `devices`(`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ======================================================
-- 4️⃣  Contoh data dummy (opsional)
-- ======================================================
INSERT INTO `sensor_data` (`device_id`, `temperature`, `humidity`, `pressure`, `battery`)
VALUES
(1, 29.5, 65.2, 1012.5, 90),
(1, 30.1, 63.7, 1011.8, 88);

-- ======================================================
-- 5️⃣  View optional untuk debugging cepat
-- ======================================================
CREATE OR REPLACE VIEW `latest_sensor` AS
SELECT d.name AS device_name, s.*
FROM sensor_data s
JOIN devices d ON s.device_id = d.id
WHERE s.id = (SELECT MAX(id) FROM sensor_data WHERE device_id = d.id);
