document.addEventListener("DOMContentLoaded", () => {
  const BASE_URL = "http://localhost/iot-smart-ui/backend";
  const API_KEY = "APIKEY_SIM_ABC123456789";

  const tempSpan = document.querySelector(".temperature");
  const humSpan = document.querySelector(".humidity");
  const pressSpan = document.querySelector(".pressure");

  async function fetchSensor() {
    try {
      const res = await fetch(`${BASE_URL}/api.php?action=latest&device_id=1`);
      const data = await res.json();
      if (data.status === "ok") {
        tempSpan.textContent = `${parseFloat(data.data.temperature).toFixed(1)}°C`;
        humSpan.textContent = `${parseFloat(data.data.humidity).toFixed(1)}%`;
        pressSpan.textContent = `${(1000 + Math.random() * 30).toFixed(1)} hPa`; // dummy pressure
      }
    } catch (e) {
      console.error(e);
    }
  }

  setInterval(fetchSensor, 5000);
  fetchSensor();

  // tombol toggle
  document.querySelectorAll(".toggle-btn").forEach((btn, idx) => {
    btn.addEventListener("click", async () => {
      btn.classList.toggle("active");
      const parent = btn.closest(".flex-col");
      const labelOff = parent?.querySelector(".label-off");
      const labelOn = parent?.querySelector(".label-on");

      if (labelOff && labelOn) {
        const isOn = btn.classList.contains("active");
        labelOff.style.display = isOn ? "none" : "inline";
        labelOn.style.display = isOn ? "inline" : "none";
      }

      // Hanya switch pertama kirim ke backend
      if (btn.classList.contains("led-btn")) {
        await fetch(`${BASE_URL}/controls.php`, {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({
            api_key: API_KEY,
            command: "led",
            value: btn.classList.contains("active") ? "on" : "off",
          }),
        });
      }
    });
  });
});
