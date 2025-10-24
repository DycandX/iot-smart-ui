```markdown
# 🌡️ Smart Home IoT UI — ESP32 + PHP + MySQL

![IoT Project](https://img.shields.io/badge/IoT-ESP32-blue?style=flat-square)
![License](https://img.shields.io/badge/license-MIT-green?style=flat-square)
![Status](https://img.shields.io/badge/status-Working-success?style=flat-square)

Proyek ini adalah **Smart Home Web UI** yang terhubung ke **ESP32 (MicroPython)** melalui **backend PHP & MySQL**.  
UI menampilkan data suhu, kelembapan, dan tekanan udara dari sensor (dummy atau real), serta menyediakan **4 tombol switch** untuk mengontrol perangkat.

- 🔹 **Switch 1** → menyalakan/mematikan LED di ESP32
- 🔹 **Switch 2–4** → dummy (tombol simulasi dengan efek hover)
- 🔹 Data sensor dikirim dari ESP32 → PHP (API backend) → tampil otomatis di UI
- 🔹 Data diperbarui setiap 5 detik secara otomatis

---

## 🧩 Fitur Utama

| Fitur                | Deskripsi                                            |
| -------------------- | ---------------------------------------------------- |
| 🌡️ Monitoring Sensor | Menampilkan suhu, kelembapan, dan tekanan dari ESP32 |
| 💡 Kontrol LED       | Switch 1 mengontrol LED di ESP32 via API             |
| 🖥️ Realtime UI       | Data diperbarui otomatis setiap 5 detik              |
| 🧰 Backend PHP       | API `upload.php`, `api.php`, dan `controls.php`      |
| 🧠 Database MySQL    | Menyimpan data sensor dan perintah kontrol           |
| 🪶 Frontend Modern   | Desain responsif dengan TailwindCSS                  |

---

## 📁 Struktur Folder
```
```
iot-smart-ui/
│
├── backend/ # Server-side PHP API
│ ├── db.php # Koneksi MySQL
│ ├── upload.php # Endpoint kirim data sensor
│ ├── api.php # Endpoint ambil data sensor & command
│ ├── controls.php # Endpoint kirim perintah kontrol (LED)
│ └── create_dht.sql # Skrip SQL database
│
├── web/ # Frontend UI
│ ├── index.html # Tampilan utama
│ ├── app.js # Logika UI & komunikasi API
│ └── style.css # Styling kustom
│
└── esp32/
└── main.py # Kode MicroPython ESP32

```

---

## ⚙️ Kebutuhan Sistem

- 🧠 **ESP32** (MicroPython Firmware)
- 💻 **XAMPP / Laragon / WAMP** (Apache + MySQL)
- 🧮 **PHP 7+** dengan ekstensi `mysqli`
- 🧰 **Thonny** (atau rshell / ampy untuk upload kode)
- 🌐 Koneksi Wi-Fi (ESP32 dan PC di jaringan sama)
- 🧱 **Browser modern** (Chrome/Edge/Firefox)

---

## 🧾 Instalasi & Konfigurasi

### 1️⃣ Import Database

1. Buka `phpMyAdmin`
2. Buat database baru: `DHT`
3. Import file:
```

backend/create_dht.sql

```
4. Pastikan tabel `devices`, `sensor_data`, `controls` terbuat otomatis
dan terdapat 1 data device dengan:
```

api_key = APIKEY_SIM_ABC123456789

```

---

### 2️⃣ Setup Backend (PHP + MySQL)

1. Salin folder `backend/` ke direktori server (contoh XAMPP):
```

C:\xampp\htdocs\iot-smart-ui\backend

````
2. Ubah kredensial database di `backend/db.php`:
```php
$host = "localhost";
$user = "root";
$pass = "";
$dbname = "DHT";
````

3. Jalankan Apache & MySQL
4. Tes endpoint:

   ```
   http://localhost/iot-smart-ui/backend/api.php?action=latest&device_id=1
   ```

---

### 3️⃣ Setup Frontend

1. Salin folder `web/` ke direktori publik:

   ```
   C:\xampp\htdocs\iot-smart-ui\web
   ```

2. Buka `web/app.js`, ubah konfigurasi berikut bila perlu:

   ```js
   const BASE_URL = "http://localhost/iot-smart-ui/backend";
   const API_KEY = "APIKEY_SIM_ABC123456789";
   ```

3. Buka browser dan akses:

   ```
   http://localhost/iot-smart-ui/web/index.html
   ```

---

### 4️⃣ Setup ESP32 (MicroPython)

1. Buka **Thonny IDE**
2. Upload file `esp32/main.py` ke board ESP32
3. Edit isi file agar sesuai Wi-Fi dan server lokal kamu:

   ```python
   SSID = "NamaWiFi"
   PASSWORD = "PasswordWiFi"
   SERVER = "http://192.168.1.100/iot-smart-ui/backend"  # IP PC kamu
   API_KEY = "APIKEY_SIM_ABC123456789"
   ```

4. Jalankan atau reboot ESP32
   ESP akan menampilkan log:

   ```
   Connecting to WiFi...
   Connected. IP: 192.168.x.x
   Sent: {temperature, humidity, pressure, battery}
   ```

---

## 💡 Cara Penggunaan

1. Jalankan Apache + MySQL
2. Jalankan ESP32 (Wi-Fi tersambung ke jaringan sama)
3. Buka `index.html` di browser
4. Lihat data sensor realtime
5. Tekan **Switch 1** → LED di ESP menyala/mati
6. Tekan **Switch 2–4** → hanya simulasi UI (dummy toggle dengan efek hover)

---

## 🔍 API Endpoint Summary

| Endpoint                                     | Method | Deskripsi                         |
| -------------------------------------------- | ------ | --------------------------------- |
| `/upload.php`                                | `POST` | ESP mengirim data sensor          |
| `/api.php?action=latest&device_id=1`         | `GET`  | Web ambil data terbaru            |
| `/controls.php`                              | `POST` | Web kirim perintah LED ke backend |
| `/api.php?action=latest_command&device_id=1` | `GET`  | ESP membaca perintah terbaru      |

---

## 🧮 Contoh CURL Test

```bash
# Kirim data sensor manual
curl -X POST http://localhost/iot-smart-ui/backend/upload.php \
-H "Content-Type: application/json" \
-d '{"api_key":"APIKEY_SIM_ABC123456789","temperature":30.5,"humidity":65.2,"pressure":1009.2,"battery":90}'

# Ambil data terakhir
curl http://localhost/iot-smart-ui/backend/api.php?action=latest&device_id=1

# Kirim perintah LED
curl -X POST http://localhost/iot-smart-ui/backend/controls.php \
-H "Content-Type: application/json" \
-d '{"api_key":"APIKEY_SIM_ABC123456789","command":"led","value":"on"}'
```

---

## 🔧 Troubleshooting

| Masalah                     | Penyebab                  | Solusi                                        |
| --------------------------- | ------------------------- | --------------------------------------------- |
| ❌ `404 Not Found`          | URL salah                 | Pastikan `BASE_URL` dan path di ESP benar     |
| ❌ Data tidak muncul di web | Tidak ada data di DB      | Cek `sensor_data` di phpMyAdmin               |
| ⚠️ LED tidak menyala        | ESP tidak polling command | Cek koneksi Wi-Fi & endpoint `latest_command` |
| ⚙️ CORS Error               | Akses beda domain         | Tambahkan header CORS di file PHP             |
| ⚡ Timeout                  | Wi-Fi tidak stabil        | Gunakan IP statis dan router yang sama        |

---

## 🧰 Tools yang Digunakan

- 🪶 **Tailwind CSS** – styling modern responsif
- 💾 **PHP & MySQL** – backend dan penyimpanan data
- 🌐 **Fetch API (JS)** – komunikasi frontend-backend
- ⚙️ **MicroPython (ESP32)** – pengirim data sensor
- 🔌 **Thonny IDE** – upload & monitoring log

---

## 📸 Tampilan UI

<img src="https://github.com/yourusername/iot-smart-ui/assets/demo_ui.png" alt="Smart Home UI" width="400">

---

## 🧑‍💻 Kontributor

| Nama        | Peran                      |
| ----------- | -------------------------- |
| 👤 Zulvikar | Developer & Designer UI    |
| 🤖 ChatGPT  | Assistant Technical Writer |

---

## 📄 Lisensi

Proyek ini dirilis di bawah lisensi **MIT** — silakan gunakan, ubah, dan kembangkan untuk proyek IoT kamu sendiri.

---

### ⭐ Jangan lupa berikan bintang di repo ini jika bermanfaat!

