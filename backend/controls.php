<?php
header("Content-Type: application/json");
require_once "db.php";

$data = json_decode(file_get_contents("php://input"), true);

if (!isset($data["api_key"]) || !isset($data["command"]) || !isset($data["value"])) {
    echo json_encode(["status"=>"error","message"=>"Missing parameters"]);
    exit;
}

$api_key = $data["api_key"];
$cmd = $data["command"];
$val = $data["value"];

$q = $conn->prepare("SELECT id FROM devices WHERE api_key=?");
$q->bind_param("s", $api_key);
$q->execute();
$res = $q->get_result();

if ($res->num_rows == 0) {
    echo json_encode(["status"=>"error","message"=>"Invalid API key"]);
    exit;
}
$device_id = $res->fetch_assoc()["id"];

$stmt = $conn->prepare("INSERT INTO controls (device_id, command, value) VALUES (?, ?, ?)");
$stmt->bind_param("iss", $device_id, $cmd, $val);
$stmt->execute();

echo json_encode(["status"=>"ok","device_id"=>$device_id,"command"=>$cmd,"value"=>$val]);
?>
