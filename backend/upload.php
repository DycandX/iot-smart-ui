<?php
header("Content-Type: application/json");
require_once "db.php";

$data = json_decode(file_get_contents("php://input"), true);

if (!isset($data["api_key"]) || !isset($data["temperature"]) || !isset($data["humidity"]) || !isset($data["pressure"])) {
    echo json_encode(["status" => "error", "message" => "Missing parameters"]);
    exit;
}

$api_key = $data["api_key"];
$temp = $data["temperature"];
$hum = $data["humidity"];
$press = $data["pressure"];
$batt = $data["battery"] ?? 100;

$q = $conn->prepare("SELECT id FROM devices WHERE api_key=?");
$q->bind_param("s", $api_key);
$q->execute();
$res = $q->get_result();

if ($res->num_rows == 0) {
    echo json_encode(["status"=>"error","message"=>"Invalid API key"]);
    exit;
}

$device_id = $res->fetch_assoc()["id"];

$stmt = $conn->prepare("INSERT INTO sensor_data (device_id, temperature, humidity, pressure) VALUES (?, ?, ?, ?)");
$stmt->bind_param("iddd", $device_id, $temp, $hum, $press);
$stmt->execute();

$conn->query("UPDATE devices SET battery_level=$batt, status='online' WHERE id=$device_id");

echo json_encode(["status"=>"ok","device_id"=>$device_id,"temperature"=>$temp,"humidity"=>$hum,"pressure"=>$press]);
?>
