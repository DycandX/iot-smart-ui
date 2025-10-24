<?php
header('Content-Type: application/json');
require 'db_connect.php';

$api_key = $_GET['api_key'] ?? '';
$stmt = $pdo->prepare("SELECT id FROM devices WHERE api_key=? LIMIT 1");
$stmt->execute([$api_key]);
$dev = $stmt->fetch();
if (!$dev) { echo json_encode(['status'=>'error','message'=>'Invalid API Key']); exit; }

$device_id = $dev['id'];
$q = $pdo->prepare("SELECT * FROM device_commands WHERE device_id=? AND status='pending' ORDER BY id ASC LIMIT 1");
$q->execute([$device_id]);
$cmd = $q->fetch(PDO::FETCH_ASSOC);

if ($cmd) {
    $pdo->prepare("UPDATE device_commands SET status='sent' WHERE id=?")->execute([$cmd['id']]);
    echo json_encode(['status'=>'ok','command'=>$cmd]);
} else {
    echo json_encode(['status'=>'empty']);
}
