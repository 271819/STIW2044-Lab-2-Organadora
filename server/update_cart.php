<?php


include_once("dbconnect.php");

$op = $_POST['op'];
$prid = $_POST['prid'];
$qty = $_POST['qty'];

if ($op == "addcart") {
    $sqlupdateusercart = "UPDATE cart SET Quantity = Quantity +1 WHERE ID = '$prid'";
    if ($conn->query($sqlupdateusercart) === TRUE) {
        echo "success";
    } else {
        echo "failed";
    }
}
if ($op == "removecart") {
    if ($qty == 1) {
        echo "failed";
    } else {
        $sqlupdateusercart = "UPDATE cart SET Quantity = Quantity - 1 WHERE ID = '$prid'";
        if ($conn->query($sqlupdateusercart) === TRUE) {
            echo "success";
        } else {
            echo "failed";
        }
    }
}
?>