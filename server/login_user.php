<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];
$password = sha1($_POST['password']);

$sqllogin = "SELECT * FROM tbl_user WHERE user_email = '$email' AND password = '$password' AND otp = '0'";
$result = $conn->query($sqllogin);

if ($result ->num_rows > 0) {
    while ($row = $result ->fetch_assoc()){
       echo $data = "success,".$row["name"].",".$row["date_reg"].",".$row["rating"].",".$row["credit"].",".$row["status"];
<<<<<<< HEAD
=======
        //echo "success";
>>>>>>> 7a1d7b6db05596dd2e9a993f70c18739156a6a72
    }
    }else{
        echo "failed";
    }

<<<<<<< HEAD
?>
=======
?>
>>>>>>> 7a1d7b6db05596dd2e9a993f70c18739156a6a72
