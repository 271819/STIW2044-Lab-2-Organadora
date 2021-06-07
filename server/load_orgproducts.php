<?php

include_once("dbconnect.php");
$srcname = $_POST['name'];

if ($srcname == "") {
    $sqlloadproduct = "SELECT * FROM org_products ORDER BY ID DESC";
} 
else{
    $sqlloadproduct = "SELECT * FROM org_products WHERE Name LIKE '%$srcname%'";
}

$result = $conn-> query($sqlloadproduct);

if($result ->num_rows >0){
    $response["products"]=array();
    while ($row = $result -> fetch_assoc()){
        $list = array();
        $list[prid] = $row['ID'];
        $list[name] = $row['Name'];
        $list[price] = $row['Price'];
        $list[weight] = $row['Weight'];
        $list[quantity]=$row['Quantity'];
        array_push($response["products"],$list);
    }
    echo json_encode($response);
}else{
    echo "nodata";
}

?>