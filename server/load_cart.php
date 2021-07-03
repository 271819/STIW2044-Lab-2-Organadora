<?php
include_once("dbconnect.php");

$sqlloadcategories ="SELECT * FROM cart ORDER BY ID DESC";
$result = $conn-> query ($sqlloadcategories);

if($result ->num_rows >0){
    $response["cart"]=array();
    while ($row = $result -> fetch_assoc()){
        $list = array();
        $list[prid] = $row["ID"];
        $list[name] = $row['Name'];
        $list[price] = $row['Price'];
        $list[quantity] = $row['Quantity'];
        array_push($response["cart"],$list);
    }
    echo json_encode($response);
}else{
    echo "nodata";
}
?>