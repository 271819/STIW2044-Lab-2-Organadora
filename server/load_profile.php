<?php
include_once("dbconnect.php");

$email = $_POST['email'];
$sqlloadproduct ="SELECT name,phone FROM tbl_user WHERE user_email=$email";
$result = $conn->query($sqlloadproduct);

if($result ->num_rows >0){

    while ($row = $result -> fetch_assoc()){
        $list = array();
        $list[id] = $row['prid'];
        $list[name] = $row['prname'];
        $list[type] = $row['prtype'];
        $list[price] = $row['prprice'];
        $list[qty] = $row['prqty'];
        $list[datecreated] = $row['datecreated'];
        array_push($response["products"],$list);
    }
    echo json_encode($response);
}else{
    echo "nodata";
}
?>