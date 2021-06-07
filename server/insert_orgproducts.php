<?php
include_once("dbconnect.php");

$name = $_POST['name'];
$price = $_POST['price'];
$weight = $_POST['weight'];
$quantity =$_POST['qty'];
$encoded_string = $_POST["encoded_string"];

$sqlinsert = "INSERT INTO org_products(Name,Price,Weight,Quantity) VALUES('$name','$price','$weight','$quantity')";
if ($conn->query($sqlinsert) === TRUE){
    $decoded_string = base64_decode($encoded_string);
    $filename = mysqli_insert_id($conn);
    $path = '../images/org_products/'.$filename.'.png';
    $is_written = file_put_contents($path, $decoded_string);
    echo "success";
}else{
    echo "failed";
}

?>