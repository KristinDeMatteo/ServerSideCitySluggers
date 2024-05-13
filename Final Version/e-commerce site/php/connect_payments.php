<?php
$host = "localhost";
$user = "root";
$pass = "";
$db= "payments";

$paymentsLink = mysqli_connect($host,$user,$pass,$db); 
if ($paymentsLink->connect_errno>0) 
{
    die('Could not connect: ' . $db->error ); 
}

$db_selected = mysqli_select_db($paymentsLink, $db); 
if (!$db_selected) 
{
    die ('Can\'t use database $db : ' . $db->error); 
}
	
?>