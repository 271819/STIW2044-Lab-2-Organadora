<?php
include_once("dbconnect.php");

$prid = $_POST['prid'];

$sqldelcart = "DELETE FROM cart WHERE ID = '$prid'";
if ($conn->query($sqldelcart) === TRUE) {
    echo "success";
} else {
    echo "failed";
}
?>