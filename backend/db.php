<?php
$host = "localhost";
$user = "root";
$pass = "";
$dbname = "iot-smart-ui";

$conn = new mysqli($host, $user, $pass, $dbname);
if ($conn->connect_error) {
    die(json_encode(["status"=>"error","message"=>"DB connection failed: ".$conn->connect_error]));
}
?>
