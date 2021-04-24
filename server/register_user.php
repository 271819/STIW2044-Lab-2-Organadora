<?php

use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

require '/home8/crimsonw/public_html/s271819/organadora/php/PHPMailer/Exception.php';
require '/home8/crimsonw/public_html/s271819/organadora/php/PHPMailer/PHPMailer.php';
require '/home8/crimsonw/public_html/s271819/organadora/php/PHPMailer/SMTP.php';

include_once("dbconnect.php");

$name = $_POST['name'];
$user_email = $_POST['email'];
$password = $_POST['password'];
$passha1 = sha1($password);
$otp = rand(1000,9999);
$rating = "0";
$credit = "0";
$status = "active";

$sqlregister = "INSERT INTO tbl_user(user_email,password,otp,rating,credit,status) VALUES('$user_email','$passha1','$otp','$rating','$credit','$status')";
if ($conn->query($sqlregister) === TRUE){
    echo "success";
    sendEmail($otp,$user_email);
}else{
    echo "failed";
}

function sendEmail($otp,$user_email){
    $mail = new PHPMailer(true);
    $mail->SMTPDebug = 0;                                   //Disable verbose debug output
    $mail->isSMTP();                                        //Send using SMTP
    $mail->Host       = 'mail.crimsonwebs.com';             //Set the SMTP server to send through
    $mail->SMTPAuth   = true;                               //Enable SMTP authentication
    $mail->Username   = 'organadora@crimsonwebs.com';       //SMTP username
    $mail->Password   = '';                     //SMTP password
    $mail->SMTPSecure = 'tls';         
    $mail->Port       = 587;
    
    $from = "organadora@crimsonwebs.com";
    $to = $user_email;
    $subject = "From Organadora. Please Verify your account";
    $message = 
       
        "<h1>&emsp;&ensp;Email Confirmation </h1>
        <hr>
        <h3>
        <p>
        Hey, You are almost ready to start enjoying organadora. 
        <p>
        Simply click the link below to verify your email. <p>
        </h3>
        <p><br>
        &emsp;&emsp;&emsp;
        <a href='https://crimsonwebs.com/s271819/organadora/php/verify_account.php?email=".$user_email."&key=".$otp."'>
        Verify Email Address.
        </a>";

    $mail->setFrom($from,"Organadora");
    $mail->addAddress($to);                                             //Add a recipient
    
    //Content
    $mail->isHTML(true);                                                //Set email format to HTML
    $mail->Subject = $subject;
    $mail->Body    = $message;
    $mail->send();
}
?>
