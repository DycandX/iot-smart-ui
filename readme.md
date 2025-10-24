## 🌡️ Smart IoT ESP32 Web Dashboard (DHT + LED Control + Pressure)

### 🧩 Deskripsi

Proyek ini adalah **sistem IoT berbasis ESP32 dan Web Dashboard** yang digunakan untuk:

* Mengirim data sensor suhu, kelembapan, tekanan udara, dan level baterai dari **ESP32** ke **server lokal (XAMPP)**.
* Menampilkan data sensor secara **real-time di halaman web GUI** dengan tampilan mirip LCD.
* Mengontrol **LED pada ESP32** melalui tombol **Switch 1** di web.
* Menyediakan tombol tambahan (Switch 2–4) sebagai dummy dengan efek interaktif dan hover.

---

## ⚙️ Fitur Utama

✅ Tampilan web modern berbasis **Tailwind CSS** (mirip UI Smart Home).
✅ ESP32 mengirim data dalam **format JSON** ke backend PHP.
✅ Tombol Switch 1 di web mengirim perintah **ON/OFF ke LED ESP32** melalui endpoint `controls.php`.
✅ Menyimpan semua data ke database MySQL (`iot-smart-ui`).
✅ Mendukung data tekanan udara (outdoor pressure).
✅ Respon cepat dan ringan (komunikasi berbasis HTTP + JSON).

---

## 🧱 Struktur Proyek

```
iot-smart-ui/
├── backend/
│   ├── upload.php         → Menerima data JSON dari ESP32
│   ├── controls.php       → Menerima perintah dari web (LED ON/OFF)
│   ├── api.php            → Endpoint untuk menampilkan data terbaru
│   ├── db.php             → Koneksi database
│   └── iot-smart-ui.sql   → Struktur database lengkap
│
├── web/
│   ├── index.html         → Tampilan utama dashboard
│   ├── app.js             → Logika fetch data + kontrol tombol
│   └── style.css          → Styling UI
│
└── esp32/
    └── main.py            → Script MicroPython (Thonny)
```

---

## 🧩 Kebutuhan Sistem

### 💻 Server (Backend)

* **XAMPP / Laragon**
* **PHP ≥ 7.4**
* **MySQL / MariaDB**

### 🔌 Perangkat IoT

* **ESP32** dengan **MicroPython**
* **Thonny IDE** untuk upload `main.py`
* Modul sensor DHT22 (opsional, atau pakai data dummy)

---

## 🗂️ Langkah Instalasi Lengkap

### 1️⃣ Clone atau Download Repository

```bash
git clone https://github.com/username/iot-smart-ui.git
```

Lalu pindahkan folder ke:

```
C:\xampp\htdocs\iot-smart-ui
```

---

### 2️⃣ Import Database

1. Buka **phpMyAdmin**
2. Klik **Import**
3. Pilih file `iot-smart-ui.sql` dari folder `backend/`
4. Klik **Go**

Database akan otomatis berisi tabel:

* `devices`
* `sensor_data`
* `commands`

---

### 3️⃣ Konfigurasi File `db.php`

Pastikan pengaturan sesuai:

```php
<?php
$host = "localhost";
$user = "root";
$pass = "";
$db   = "iot-smart-ui";
$conn = new mysqli($host, $user, $pass, $db);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>
```

---

### 4️⃣ Jalankan Web Dashboard

Buka di browser:

```
http://localhost/iot-smart-ui/web/
```

---

### 5️⃣ Upload `main.py` ke ESP32

Gunakan **Thonny IDE**, lalu upload script `main.py` berikut:

```python
# main.py - ESP32 (MicroPython) untuk kirim data JSON & kontrol LED

import network, urequests as requests, utime, random, json
from machine import Pin

SSID = "WiFi_Kamu"
PASSWORD = ""
SERVER = "http://192.168.1.10/iot-smart-ui/backend"
API_KEY = "APIKEY_SIM_ABC123456789"
INTERVAL = 5  # detik

led = Pin(2, Pin.OUT)
led.off()

def connect_wifi():
    wlan = network.WLAN(network.STA_IF)
    wlan.active(True)
    if not wlan.isconnected():
        print("Connecting to WiFi...")
        wlan.connect(SSID, PASSWORD)
        for _ in range(15):
            if wlan.isconnected():
                break
            utime.sleep(1)
    print("Connected:", wlan.ifconfig())
    return wlan

connect_wifi()

while True:
    # Data dummy
    temp = round(random.uniform(25, 40), 1)
    hum = round(random.uniform(40, 90), 1)
    pres = round(random.uniform(1000, 1020), 1)
    bat = random.randint(80, 100)

    payload = {
        "api_key": API_KEY,
        "temperature": temp,
        "humidity": hum,
        "pressure": pres,
        "battery": bat
    }

    try:
        r = requests.post(f"{SERVER}/upload.php", headers={"Content-Type": "application/json"}, data=json.dumps(payload))
        print("Sent:", payload, "->", r.status_code, r.text)
        r.close()
    except Exception as e:
        print("Error sending:", e)

    # Cek command dari server
    try:
        res = requests.get(f"{SERVER}/api.php?action=latest_command&api_key={API_KEY}")
        cmd_data = res.json()
        if cmd_data["status"] == "ok" and cmd_data["command"] == "led":
            if cmd_data["value"] == "on":
                led.on()
            else:
                led.off()
        res.close()
    except Exception as e:
        print("Command check failed:", e)

    utime.sleep(INTERVAL)
```

---

## 🌐 API Endpoint Utama

| Endpoint                                             | Method      | Fungsi                        |
| ---------------------------------------------------- | ----------- | ----------------------------- |
| `/backend/upload.php`                                | POST (JSON) | ESP32 kirim data sensor       |
| `/backend/api.php?action=latest&device_id=1`         | GET         | Ambil data sensor terbaru     |
| `/backend/api.php?action=latest_command&api_key=...` | GET         | ESP32 ambil perintah LED      |
| `/backend/controls.php`                              | POST (JSON) | Web kirim perintah LED ON/OFF |

---

## 💡 Tampilan GUI

Tampilan web berbasis Tailwind CSS dengan gaya **abu-abu LCD-style**:

* Bagian atas: suhu, kelembapan, dan tekanan udara
* Bagian bawah: kontrol 4 tombol switch (1 LED nyata + 3 dummy)
* Responsif untuk perangkat mobile

---

## ⚡ Pengujian

### Kirim Data Manual

```bash
curl -X POST http://localhost/iot-smart-ui/backend/upload.php \
  -H "Content-Type: application/json" \
  -d '{"api_key":"APIKEY_SIM_ABC123456789","temperature":30.5,"humidity":55.2,"pressure":1010.3,"battery":95}'
```

### Kirim Perintah LED ON

```bash
curl -X POST http://localhost/iot-smart-ui/backend/controls.php \
  -H "Content-Type: application/json" \
  -d '{"api_key":"APIKEY_SIM_ABC123456789","command":"led","value":"on"}'
```

---

## 🧠 Pengembang

**👤 Zulvikar**
💼 D4 Teknologi Rekayasa Komputer | Politeknik Negeri Semarang
💡 Proyek ini dibuat untuk demonstrasi sistem IoT berbasis ESP32 dan Web Dashboard.

---
