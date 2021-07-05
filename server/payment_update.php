<?php
error_reporting(0);
include_once("dbconnect.php");

$mobile = $_GET['mobile'];
$amount = $_GET['amount'];
$message = $_GET['message'];
$email = $_GET['email'];
$address = $_GET['address'];

$data = array(
    'id'=> $_GET['billplz']['id'],
    'paid_at'=>$_GET['billplz']['paid_at'],
    'paid'=>$_GET['billplz']['paid'],
    'x_signature' => $_GET['billplz']['x_signature'],
    );

$paidstatus = $_GET['billplz']['paid'];

if ($paidstatus == "true"){
    $receiptid = $_GET['billplz']['id'];
    $signing = '';
     foreach ($data as $key => $value){
         $signing.='billplz'.$key .$value;
         if($key === 'paid'){
             break;
         }else{
             $signing .= '|';
         }
     }
     
     $signed = hash_hmac('sha256',$signing, 'S-ZKRu82ixgdDUaMx8u1L5Sg');
     if ($signed === $data['x_signature']){
         
     }
     
     $sqlinsertpurchased = "INSERT INTO tbl_purchased(orderid,email,paid,message,status) VALUES ('$receiptid','$email','$amount','$message','paid')";
     $sqldeletecart = "DELETE FROM cart WHERE email = '$email'";
     
     $stmt = $conn ->prepare($sqlinsertpurchased);
     $stmt ->execute();
     $stmtdel = $conn ->prepare($sqldeletecart);
     $stmtdel ->execute();
     
     echo '<br><br><body><div><h2><br><br><center>Your Receipt</center>
     </h1>
     <table border =1 width=85% align=center>
     <tr><td>Recept ID</td><td>'.$receiptid.'</td></tr><tr><td>Email to </td>
     <td>'.$email. '</td></tr><td>Amount </td><td>RM '.$amount.'</td></tr>
     <tr><td>Payment Status </td><td>'.$paidstatus.'</td></tr>
     <tr><td>Message </td><td>'.$message.'</td></tr>
     <tr><td>Address </td><td>'.$address.'</td></tr>
     <tr><td>Date </td><td>'.date("d/m/Y").'</td></tr>
     <tr><td>Time </td><td>'.date("h:i a").'</td></tr>
     </table><br>
     <p><center>Press back button to return to your apps</center></p></div></body>';
}
else{
    echo 'Payment Failed!';
}
    
?>