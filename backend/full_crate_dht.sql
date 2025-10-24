CREATE DATABASE IF NOT EXISTS `DHT` CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `DHT`;

CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(50),
  password_hash VARCHAR(255),
  email VARCHAR(100),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE devices (
  id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT,
  name VARCHAR(50),
  location VARCHAR(50),
  api_key VARCHAR(64) UNIQUE,
  status ENUM('online','offline') DEFAULT 'offline',
  battery_level TINYINT DEFAULT 100,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE sensor_data (
  id BIGINT AUTO_INCREMENT PRIMARY KEY,
  device_id INT,
  temperature DECIMAL(4,1),
  humidity DECIMAL(4,1),
  timesamp DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE controls (
  id INT AUTO_INCREMENT PRIMARY KEY,
  device_id INT,
  command VARCHAR(32),
  value VARCHAR(32),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO users (username, password_hash, email) 
VALUES ('admin', SHA2('1234', 256), 'admin@example.com');

INSERT INTO devices (user_id, name, location, api_key, status)
VALUES (1, 'ESP32-DHT', 'Lab IoT', 'APIKEY_SIM_ABC123456789', 'online');
