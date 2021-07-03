<?php
include_once("dbconnect.php");

$sqlcartitem ="SELECT * FROM cart ";
$result = $conn-> query ($sqlcartitem);


if($result ->num_rows >0){
    $rowcount=mysqli_num_rows($result);
     echo $rowcount;
}else{
    echo "nodata";
}
?>