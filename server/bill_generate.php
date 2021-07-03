<?php
error_reporting(0);
//include_once("dbconnect.php");


$email = $_GET['email'];
$name = $_GET['name'];
$mobile = $_GET['mobile'];
$amount = $_GET['amount'];
$message = $_GET['message'];

$api_key ='2a6d876b-c9cf-4366-a033-b4f95ddcab15';
$collection_id = 'wbsdurjw';
$host = 'https://billplz-staging.herokuapp.com/api/v3/bills';

$data = array(
    'collection_id' => $collection_id,
    'email'=> $email,
    'name'=> $name,
    'mobile'=> $mobile,
    'amount'=> $amount * 100,
    'description'=>'Payment for order',
    'callback_url'=> "https://crimsonwebs.com/s271819/organadora/php/return_url",
    'redirect_url'=> "https://crimsonwebs.com/s271819/organadora/php/payment_update.php?email=$email&mobile=$mobile&message=$message&amount=$amount"
    );

$process = curl_init($host );
curl_setopt($process, CURLOPT_HEADER, 0);
curl_setopt($process, CURLOPT_USERPWD, $api_key . ":");
curl_setopt($process, CURLOPT_TIMEOUT, 30);
curl_setopt($process, CURLOPT_RETURNTRANSFER, 1);
curl_setopt($process, CURLOPT_SSL_VERIFYHOST, 0);
curl_setopt($process, CURLOPT_SSL_VERIFYPEER, 0);
curl_setopt($process, CURLOPT_POSTFIELDS, http_build_query($data) ); 


$return = curl_exec($process);
curl_close($process);

$bill = json_decode($return,true);

echo "<pre>".print_r($bill,true)."</pre";
header("Location: {$bill['url']}");




?>