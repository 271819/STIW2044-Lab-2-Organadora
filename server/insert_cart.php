<?php
include_once("dbconnect.php");


$name = $_POST['name'];
$price= $_POST['price'];
$prid = $_POST['prid'];
$quantity = $_POST['quantity'];
$email = $_POST['email'];

if($quantity == ""){
    $qty = "1";
}else{
    $qty = $quantity;
}

$sqlinsert = "INSERT INTO cart(email,ID,Name,Price,Quantity) VALUES('$email','$prid','$name','$price','$qty')";
if ($conn->query($sqlinsert) === TRUE){
    echo "success";
}else{
    echo "failed";
}

?>