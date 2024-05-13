<?php
$host = "localhost";
$user = "root";
$pass = "";
$db= "orders";

$ordersLink = mysqli_connect($host,$user,$pass,$db); 
if ($ordersLink->connect_errno>0) 
{
    die('Could not connect: ' . $db->error ); 
}

$db_selected = mysqli_select_db($ordersLink, $db); 
if (!$db_selected) 
{
    die ('Can\'t use database $db : ' . $db->error); 
}
	
?>