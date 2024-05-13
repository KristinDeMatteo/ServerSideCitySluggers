<?php
// Include the file with the database connection
require("connect_customers.php");

// Function to sanitize user input
function sanitize_input($data) {
    $data = trim($data);
    $data = stripslashes($data);
    $data = htmlspecialchars($data);
    return $data;
}

// Retrieve user input from POST request
$email = sanitize_input($_POST['email']);
$password = sanitize_input($_POST['password']);

// Query the database to check if user exists
$sql = "SELECT * FROM CustLogin WHERE cusername = '$email' AND cpswd = '$password'";
$result = mysqli_query($customersLink, $sql);

if ($result && mysqli_num_rows($result) > 0) {
    // User exists, set session or cookie to indicate logged in state
    session_start();
    $_SESSION['loggedIn'] = true;
    echo "Logged In!";
} else {
    // User does not exist or incorrect password
    echo "Invalid email or password.";
}

mysqli_close($customersLink);
?>
