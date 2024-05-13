<?php
require("connect_customers.php");
require("connect_products.php");
require("connect_payments.php");
require("connect_orders.php");

// Collect all relevant cookies
$shippingFirstName = $_COOKIE["shipping-firstname"];
$shippingLastName = $_COOKIE["shipping-lastname"];
$shippingEmail = $_COOKIE["shipping-email"];
$shippingAddress = $_COOKIE["shipping-address"];
$shippingCity = $_COOKIE["shipping-city"];
$shippingState = $_COOKIE["shipping-state"];
$shippingZip = $_COOKIE["shipping-zip"];
$billingFirstName = $_COOKIE["billing-firstname"];
$billingLastName = $_COOKIE["billing-lastname"];
$billingEmail = $_COOKIE["billing-email"];
$billingAddress = $_COOKIE["billing-address"];
$billingCity = $_COOKIE["billing-city"];
$billingState = $_COOKIE["billing-state"];
$billingZip = $_COOKIE["billing-zip"];
$cardNumber = $_COOKIE["card-number"];
$cardName = $_COOKIE["card-name"];
$expiryDate = $_COOKIE["expiry-date"];
$cardMonth = explode("/", $expiryDate)[0];
$cardYear = explode("/", $expiryDate)[1];
$cvv = $_COOKIE["cvv"];
$cart = $_COOKIE["cart"];
$cart = json_decode($cart, true);
$uniqueItems = array_keys($cart);

//Validate data before sending to database
$namePattern = "/^[a-zA-Z\s]+$/";
$emailPattern = "/^\w+([.-]?\w+)@\w+([.-]?\w+)(.\w{2,4})+$/"; // Email regex gotten from John Groton
// address regex gotten from:
//https://community.alteryx.com/t5/Alteryx-Designer-Desktop-Discussions/RegEx-Addresses-different-formats-and-headaches/td-p/360147
$addressPattern = "/^(\d+) ?([A-Za-z](?= ))? (.*?) ([^ ]+?) ?((?<= )APT)? ?((?<= )\d*)?$/";
$zipPattern = "/^\d{5}$/";
$statePattern = "/^[a-zA-Z\s]{2}+$/";
$cardNumberPattern = "/^\d{16}$/";
$cvvPattern = "/^\d{3}$/";
$expiryDatePattern = "/^\d{2}$/";

// Validate data with namePattern (first name, last name, city)
if(in_array(0, [preg_match($namePattern, $shippingFirstName), 
preg_match($namePattern, $shippingLastName), 
preg_match($namePattern, $shippingCity),
preg_match($namePattern, $billingFirstName),
preg_match($namePattern, $billingLastName),
preg_match($namePattern, $billingCity)]))
{
    //echo "ERROR! Issue with name pattern";
    header('Location: ../htm/sorry.html');
}

// Validate emails
if(in_array(0, [preg_match($emailPattern, $shippingEmail), 
preg_match($emailPattern, $billingEmail)]))
{
    //echo "ERROR! Issue with email";
    header('Location: ../htm/sorry.html');
}

// Validate addresses
if(in_array(0, [preg_match($addressPattern, $shippingAddress), 
preg_match($addressPattern, $billingAddress)]))
{
    //echo "ERROR! Issue with zip code";
    header('Location: ../htm/sorry.html');
}

// Validate zip codes
if(in_array(0, [preg_match($zipPattern, $shippingZip), 
preg_match($zipPattern, $billingZip)]))
{
    //echo "ERROR! Issue with zip code";
    header('Location: ../htm/sorry.html');
}

// Validate states
if(in_array(0, [preg_match($statePattern, $shippingState), 
preg_match($statePattern, $billingState)]))
{
    //echo "ERROR! Issue with state";
    header('Location: ../htm/sorry.html');
}

// Validate card number
if(preg_match($cardNumberPattern, $cardNumber) == 0)
{
    //echo "ERROR! Issue with card number";
    header('Location: ../htm/sorry.html');
}

// Validate CVV
if(preg_match($cvvPattern, $cvv) == 0)
{
    //echo "ERROR! Issue with cvv";
    header('Location: ../htm/sorry.html');
}

// Validate expiryDate
if(in_array(0, [preg_match($expiryDatePattern, $cardMonth), 
preg_match($expiryDatePattern, $cardYear)]))
{
    //echo "ERROR! Issue with expiry date";
    header('Location: ../htm/sorry.html');
}


// Create all ID's needed for queries
$shippingCID = 0;
$billingCID = 0;
$shippingAddressID = 0;
$billingAddressID = 0;
$orderID = 0;

// Shipping customer ID and billing customer ID
if ($result = $customersLink -> query("SELECT MAX(cid) FROM Customer")) {
    $row = $result -> fetch_row();
    $shippingCID = $row[0] + 1;
    $billingCID = $shippingCID + 1;
}

// Shipping address ID and billing address ID
if ($result = $customersLink -> query("SELECT MAX(add_id) FROM address")) {
    $row = $result -> fetch_row();
    $shippingAddressID = $row[0] + 1;
    $billingAddressID = $shippingAddressID + 1;
}

// Order ID
if ($result = $ordersLink -> query("SELECT MAX(order_id) FROM orderdata;")) {
    $row = $result -> fetch_row();
    $orderID = $row[0] + 1;
}

// Create instert/update statements
// Customers database
// Customer table
$customerShipping = "insert into Customer values($shippingCID,'$shippingFirstName','$shippingLastName');";
$customerBilling = "insert into Customer values($billingCID,'$billingFirstName','$billingLastName');";
// CustomerContact table
// We only take personal emails, so second parameter (contact type id) is always 11 (personal email)
$customerContactShipping = "insert into CustomerContact values ($shippingCID,11,'$shippingEmail');";
$customerContactBilling = "insert into CustomerContact values ($billingCID,11,'$billingEmail');";
// CustomerAddressType table
// Address type id's: {shipping: 333, billing: 111}
$customerAddressTypeShipping = "insert into CustomerAddressType values($shippingCID,$shippingAddressID,333);";
$customerAddressTypeBilling = "insert into CustomerAddressType values($billingCID,$billingAddressID,111);";
// Address table
$addressShipping = "insert into Address values($shippingAddressID,'$shippingAddress','$shippingCity','$shippingState','$shippingZip');";
$addressBilling = "insert into Address values($billingAddressID,'$billingAddress','$billingCity','$billingState','$billingZip');";

// Payments database
// CustomerPaymentMethod table
// Since we only take credit card at the moment, method_id will always be 111
$customerPaymentMethod = "insert into CustomerPaymentMethod values($billingCID, 111);";
// CreditDebit table
$creditDebit = "insert into CreditDebit values($billingCID, 111, '$cardNumber');";
// CustCard table (assumption: card expires after 2000 and before 2100)
$custCard = "insert into CustCard values('$cardNumber', '$cardName', '$cvv', '$billingZip', '$cardMonth', '20$cardYear');";

// Orders database
// OrderData table
$orderData = "insert into OrderData values($billingCID,$orderID,'".date("Y-m-d")."');";
// LineItems table (potentially multiple queries)
$lineItemsQueries = [];
for ($i=0; $i < count($uniqueItems); $i++) 
{ 
    if ($uniqueItems[$i] == "Premier Mountain Bike")
    {
        array_push($lineItemsQueries, "insert into LineItem values($orderID,023,".$cart[$uniqueItems[$i]]["quantity"].");");
    }
    elseif ($uniqueItems[$i] == "Racing Bike")
    {
        array_push($lineItemsQueries, "insert into LineItem values($orderID,125,".$cart[$uniqueItems[$i]]["quantity"].");");
    }
    elseif ($uniqueItems[$i] == "The Road Warrior")
    {
        array_push($lineItemsQueries, "insert into LineItem values($orderID,896,".$cart[$uniqueItems[$i]]["quantity"].");");
    }
    elseif ($uniqueItems[$i] == "Cruising Bike")
    {
        array_push($lineItemsQueries, "insert into LineItem values($orderID,705,".$cart[$uniqueItems[$i]]["quantity"].");");
    }
}
// OrderPayment table
$orderPayment = "insert into OrderPayment values($orderID,$billingCID,111);";
// OrderStatus table
$orderStatus = "insert into OrderStatus values($orderID,1,'".date("Y-m-d")." 00:00:00');";

// Products database
// ProductInventory table
$productInventoryUpdates = [];
for ($i=0; $i < count($uniqueItems); $i++) 
{ 
    if ($uniqueItems[$i] == "Premier Mountain Bike")
    {
        $currentPid = "023";
    }
    elseif ($uniqueItems[$i] == "Racing Bike")
    {
        $currentPid = "125";
    }
    elseif ($uniqueItems[$i] == "The Road Warrior")
    {
        $currentPid = "896";
    }
    elseif ($uniqueItems[$i] == "Cruising Bike")
    {
        $currentPid = "705";
    }
    array_push($productInventoryUpdates, "UPDATE ProductInventory SET qty_on_hand = qty_on_hand - ".$cart[$uniqueItems[$i]]["quantity"].", as_of_date = '".date("Y-m-d")." 00:00:00' WHERE pid = $currentPid;");
}

// Output inserts/updates for testing purposes
echo "<p>Queries:</p><p>$customerShipping</p><p>$customerBilling</p>";
echo "<p>$customerContactShipping</p><p>$customerContactBilling</p>";
echo "<p>$customerAddressTypeShipping</p><p>$customerAddressTypeBilling</p>";
echo "<p>$addressShipping</p><p>$addressBilling</p>";
echo "<p>$customerPaymentMethod</p><p>$creditDebit</p><p>$custCard</p>";
echo "<p>$orderData</p>";
for ($i=0; $i < count($lineItemsQueries); $i++) 
{ 
    echo "<p>".$lineItemsQueries[$i]."</p>";
}
echo "<p>$orderPayment</p><p>$orderStatus</p>";
for ($i=0; $i < count($productInventoryUpdates); $i++) 
{ 
    echo "<p>".$productInventoryUpdates[$i]."</p>";
}

// Send data to databases
$result1 = mysqli_query($customersLink,$customerShipping);
$result2 = mysqli_query($customersLink,$customerBilling);
$result3 = mysqli_query($customersLink,$customerContactShipping);
$result4 = mysqli_query($customersLink,$customerContactBilling);
$result5 = mysqli_query($customersLink,$customerAddressTypeShipping);
$result6 = mysqli_query($customersLink,$customerAddressTypeBilling);
$result7 = mysqli_query($customersLink,$addressShipping);
$result8 = mysqli_query($customersLink,$addressBilling);
$result9 = mysqli_query($paymentsLink,$customerPaymentMethod);
$result10 = mysqli_query($paymentsLink,$creditDebit);
// Account for trying to input duplicate data
try
{
    $result11 = mysqli_query($paymentsLink,$custCard);
}
catch(Exception $e){}
$result12 = mysqli_query($ordersLink,$orderData);
for ($i=0; $i < count($lineItemsQueries); $i++) 
{ 
    $result13 = mysqli_query($ordersLink,$lineItemsQueries[$i]);
}
$result14 = mysqli_query($ordersLink,$orderPayment);
$result15 = mysqli_query($ordersLink,$orderStatus);
for ($i=0; $i < count($productInventoryUpdates); $i++) 
{ 
    $result13 = mysqli_query($productsLink,$productInventoryUpdates[$i]);
}

mysqli_close($productsLink);
mysqli_close($customersLink);
mysqli_close($paymentsLink);
mysqli_close($ordersLink);

header('Location: ../htm/thankyou.html');
?>