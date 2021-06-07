<?php
include_once("dbconnect.php");
$cateid = $_POST['id'];
$sqlloadcategories ="SELECT * FROM products WHERE cateid ='$cateid'";
$result = $conn-> query ($sqlloadcategories);

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
        $list[Images] = $row['Images'];
        array_push($response["products"],$list);
    }
    echo json_encode($response);
}else{
    echo "nodata";
}
?>