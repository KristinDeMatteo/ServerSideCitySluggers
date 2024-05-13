<?php
session_start();
require("connect_orders.php");
require("connect_customers.php");
require("connect_products.php");

if (isset($_COOKIE['loggedIn'])) {
    $email = $_COOKIE['loggedIn'];

    // Query the database to fetch the user's ID based on their email
    $sql = "SELECT cid FROM CustLogin WHERE cusername = '$email'";
    $result = mysqli_query($customersLink, $sql);

    if ($result && mysqli_num_rows($result) > 0) {
        $row = mysqli_fetch_assoc($result);
        $cid = $row['cid'];

        // Query the orders database to fetch order history for the user
        $sql_orders = "SELECT od.order_id, od.order_date, os.as_of_date, os.statusID, s.status_desc
                       FROM OrderData od
                       JOIN OrderStatus os ON od.order_id = os.order_id
                       JOIN CurrStatus s ON os.statusID = s.statusID
                       WHERE od.cid = $cid";
        $result_orders = mysqli_query($ordersLink, $sql_orders);

        if ($result_orders && mysqli_num_rows($result_orders) > 0) {
            echo "<ul>";
            while ($row_order = mysqli_fetch_assoc($result_orders)) {
                $order_id = $row_order['order_id'];
                $order_date = $row_order['order_date'];
                $status_date = $row_order['as_of_date'];
                $status_desc = $row_order['status_desc'];

                echo "<li>Order ID: $order_id - Order Date: $order_date - Status: $status_desc (Updated on: $status_date)</li>";
                
                // Query the orders database to fetch line items for each order
                $sql_line_items = "SELECT pid FROM LineItem WHERE order_id = $order_id";
                $result_line_items = mysqli_query($ordersLink, $sql_line_items);

                if ($result_line_items && mysqli_num_rows($result_line_items) > 0) {
                    echo "<ul>";
                    while ($row_item = mysqli_fetch_assoc($result_line_items)) {
                        $pid = $row_item['pid'];

                        // Query the products database to fetch product details
                        $sql_product = "SELECT prod_name, price FROM Product WHERE pid = $pid";
                        $result_product = mysqli_query($productsLink, $sql_product);

                        if ($result_product && mysqli_num_rows($result_product) > 0) {
                            $row_product = mysqli_fetch_assoc($result_product);
                            echo "<li>Product Name: " . $row_product['prod_name'] . " - Price: $" . $row_product['price'] . "</li>";
                        } else {
                            echo "<li>Product not found</li>";
                        }
                    }
                    echo "</ul>";
                } else {
                    echo "<li>No line items found</li>";
                }
            }
            echo "</ul>";
        } else {
            echo "No orders found.";
        }
    } else {
        echo "User not found.";
    }
} else {
    echo "Please log in to view order history.";
}

mysqli_close($productsLink);
mysqli_close($customersLink);
mysqli_close($ordersLink);
?>
