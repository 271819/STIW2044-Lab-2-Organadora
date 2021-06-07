<?php
include_once("dbconnect.php");

$sqlloadcategories ="SELECT * FROM food_categories";
$result = $conn-> query ($sqlloadcategories);

if($result ->num_rows >0){
    $response["categories"]=array();
    while ($row = $result -> fetch_assoc()){
        $list = array();
        $list[id] = $row['ID'];
        $list[categories] = $row['Categories'];
        $list[Images] = $row['Images'];
        array_push($response["categories"],$list);
    }
    echo json_encode($response);
}else{
    echo "nodata";
}
?>