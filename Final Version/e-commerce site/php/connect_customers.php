<?php
$host = "localhost";
$user = "root";
$pass = "";
$db= "customers";

$customersLink = mysqli_connect($host,$user,$pass,$db); 
if ($customersLink->connect_errno>0) 
{
    die('Could not connect: ' . $db->error ); 
}

$db_selected = mysqli_select_db($customersLink, $db); 
if (!$db_selected) 
{
    die ('Can\'t use database $db : ' . $db->error); 
}
	
?>
