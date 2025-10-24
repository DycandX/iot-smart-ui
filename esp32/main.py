# main.py - ESP32 (MicroPython)
# Mengirim data suhu & kelembapan dummy ke server PHP (JSON)
# dan menerima perintah LED dari web UI

import network
import urequests as requests
import utime
import random
from machine import Pin

# -------------- KONFIGURASI --------------
SSID = "Wifi Sekolah B"           # ganti sesuai WiFi kamu
PASSWORD = ""                     # isi jika pakai password
SERVER_URL = "http://172.16.92.223/iot-smart-ui/backend"
API_KEY = "APIKEY_SIM_ABC123456789"
INTERVAL = 5  # detik antar kirim data
# ----------------------------------------

led = Pin(2, Pin.OUT)
led.off()
print("Booting ESP32 IoT...")

def connect_wifi(ssid, password, timeout=20):
    wlan = network.WLAN(network.STA_IF)
    wlan.active(True)
    if not wlan.isconnected():
        print("Menghubungkan ke WiFi...")
        wlan.connect(ssid, password)
        t = 0
        while not wlan.isconnected() and t < timeout:
            utime.sleep(1)
            t += 1
            print(".", end="")
    if wlan.isconnected():
        print("\nWiFi Tersambung:", wlan.ifconfig())
        return True
    else:
        print("\nGagal terhubung WiFi.")
        return False


def send_sensor_data():
    """Mengirim data dummy suhu & kelembapan ke server"""
    temperature = round(random.uniform(25.0, 40.0), 1)
    humidity = round(random.uniform(30.0, 80.0), 1)
    pressure = round(random.uniform(1000.0, 1020.0), 1)
    battery = random.randint(80, 100)

    data = {
        "api_key": API_KEY,
        "temperature": temperature,
        "humidity": humidity,
        "pressure": pressure,
        "battery": battery
    }

    try:
        res = requests.post(
            SERVER_URL + "/upload.php",
            json=data,
            headers={"Content-Type": "application/json"},
        )
        print(f"Sent -> {temperature}°C / {humidity}% | {res.status_code} {res.text}")
        res.close()
    except Exception as e:
        print("Gagal mengirim data:", e)


def check_command():
    """Mengecek perintah terbaru dari backend"""
    try:
        url = f"{SERVER_URL}/api.php?action=latest_command&device_id=1"
        res = requests.get(url)
        if res.status_code == 200:
            result = res.json()
            if result.get("status") == "ok" and result.get("command"):
                cmd = result["command"]["command"]
                val = result["command"]["value"]
                print("Perintah diterima:", cmd, val)
                if cmd == "led":
                    if val.lower() == "on":
                        led.on()
                    else:
                        led.off()
            else:
                print("Tidak ada perintah baru.")
        res.close()
    except Exception as e:
        print("Error check_command:", e)


# ------------------- MAIN LOOP -------------------
if connect_wifi(SSID, PASSWORD):
    while True:
        send_sensor_data()
        check_command()
        utime.sleep(INTERVAL)
else:
    print("WiFi gagal tersambung, reboot manual diperlukan.")
