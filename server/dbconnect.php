<?php
$servername = "localhost";
$username = "crimsonw_organadoraadmin";
$password = "w28J0CyfDygZ";
$dbname = "crimsonw_organadoradb";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error){
    die("Connection failed:" . $conn->connect_error);
}
?>
