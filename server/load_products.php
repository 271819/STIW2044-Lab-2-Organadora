<?php
include_once("dbconnect.php");

$srcname = $_POST['name'];

if ($srcname == "") {
    $sqlloadproduct = "SELECT * FROM products ORDER BY Prid DESC";
} 
else{
    $sqlloadproduct = "SELECT * FROM products WHERE Name LIKE '%$srcname%'";
}

$result = $conn-> query($sqlloadproduct);

if($result ->num_rows >0){
    $response["products"]=array();
    while ($row = $result -> fetch_assoc()){
        $list = array();
        $list[prid] = $row['Prid'];
        $list[name] = $row['Name'];
        $list[price] = $row['Price'];
        $list[weight] = $row['Weight'];
        $list[quantity]=$row['Quantity'];
        $list[ingredient]=$row['Ingredient'];
        $list[date]=$row['datareg'];
        array_push($response["products"],$list);
    }
    echo json_encode($response);
}else{
    echo "nodata";
}
?>