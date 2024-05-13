<?php
$host = "localhost";
$user = "root";
$pass = "";
$db= "products";

$productsLink = mysqli_connect($host,$user,$pass,$db); 
if ($productsLink->connect_errno>0) 
{
    die('Could not connect: ' . $db->error ); 
}

$db_selected = mysqli_select_db($productsLink, $db); 
if (!$db_selected) 
{
    die ('Can\'t use database $db : ' . $db->error); 
}
	
?>
