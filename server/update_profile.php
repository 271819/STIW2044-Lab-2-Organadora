<?php

include_once("dbconnect.php");
$name = $_POST['name'];
$phone = $_POST['phone'];
$email = $_POST['email'];
$encoded_string = $_POST["encoded_string"];
						
$sql = "SELECT * FROM tbl_user WHERE user_email = '$email'";
$result = $conn->query($sql);
    if($result -> num_rows > 0){
        $sqlupdate = "UPDATE tbl_user SET name='$name',phone='$phone' WHERE user_email='$email'";
        if($conn-> query($sqlupdate) ===TRUE){
            $decoded_string = base64_decode($encoded_string);
        $filename = mysqli_insert_id($conn);
        $path = '../images/profile_image/'.$filename.'.jpg';
        $is_written = file_put_contents($path, $decoded_string);
            echo 'success';
        }else{
            echo 'failed';
        }
        
    }else{
        echo "failed";
    }
?>