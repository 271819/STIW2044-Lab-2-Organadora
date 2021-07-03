<?php

include_once("dbconnect.php");
$email = $_POST['email'];
$address = $_POST['address'];
						
$sql = "SELECT * FROM tbl_user WHERE user_email = '$email'";
$result = $conn->query($sql);
    if($result -> num_rows > 0){
        $sqlupdate = "UPDATE tbl_user SET address='$address'WHERE user_email='$email'";
        if($conn-> query($sqlupdate) ===TRUE){
            echo 'success';
        }else{
            echo 'failed';
        }
        
    }else{
        echo "failed";
    }
?>