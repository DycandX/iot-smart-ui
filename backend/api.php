<?php
header("Content-Type: application/json");
require_once "db.php";

$action = $_GET["action"] ?? "";
$device_id = $_GET["device_id"] ?? 1;

if ($action == "latest") {
    $sql = "SELECT * FROM sensor_data WHERE device_id=$device_id ORDER BY timesamp DESC LIMIT 1";
    $res = $conn->query($sql);
    if ($res->num_rows > 0) {
        echo json_encode(["status"=>"ok","data"=>$res->fetch_assoc()]);
    } else echo json_encode(["status"=>"no_data"]);
}

if ($action == "latest_command") {
    $sql = "SELECT command,value FROM controls WHERE device_id=$device_id ORDER BY created_at DESC LIMIT 1";
    $r = $conn->query($sql);
    echo json_encode(["status"=>"ok","data"=>$r->fetch_assoc()]);
}
?>
