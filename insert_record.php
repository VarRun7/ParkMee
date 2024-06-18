<?php
// Include database connection script
include "dbconnection.php";

// Connect to the database
$con = dbconnection();
header('Content-Type: application/json');

// Print all POST data for debugging purposes
//echo "POST data received:\n";
//print_r($_POST); // This will print a readable version of the $_POST array

// Continue with your existing logic...
$username = $_POST['username'];
$email = $_POST['email'];
$first_name = $_POST['first_name'];
$last_name = $_POST['last_name'];
$user_password = $_POST['user_password'];
//print_r($_POST);

// Check if the request is a POST request
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Extract data from POST
   
    // Define required fields
    $required_fields = ['username', 'email', 'first_name', 'last_name', 'user_password'];
    $missing_fields = [];
    
    // Check for presence of all required fields
    foreach ($required_fields as $field) {
        if (empty($_POST[$field])) {
            $missing_fields[] = $field;
        }
    }

    // If any fields are missing, return an error
    if (!empty($missing_fields)) {
        echo json_encode([
            'success' => 'false',
            'error' => 'Missing fields: ' . implode(', ', $missing_fields)
        ]);
        return;
    }

    // Prepare an SQL statement for safe insertion into the database
    $query = $con->prepare("INSERT INTO `users`(`username`, `email`, `first_name`, `last_name`, `user_password`)
                            VALUES (?, ?, ?, ?, ?)");
    
    // Bind parameters to the SQL query
    $query->bind_param("sssss", $username, $email, $first_name, $last_name, $user_password);

    // Execute the query and check for success
    if ($query->execute()) {
        //echo json_encode(['success' => 'true']);
    } else {
        // Return detailed error information in case of failure
        echo json_encode([
            'success' => 'false',
            'error' => $query->error
        ]);
    }
} else {
    // Handle incorrect request method
    //echo json_encode(['received_method' => $_SERVER['REQUEST_METHOD']]);
}

?>