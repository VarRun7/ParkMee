<?php
// Include database connection settings
include 'dbconnection.php';

// Connect to the database
$con = dbconnection();

// Set content type to JSON for the response
header('Content-Type: application/json');

// Check if the request is a POST request
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    // Extract data from POST
    $username = isset($_POST['username']) ? $_POST['username'] : null;
    $email = isset($_POST['email']) ? $_POST['email'] : null;
    $first_name = isset($_POST['first_name']) ? $_POST['first_name'] : null;
    $last_name = isset($_POST['last_name']) ? $_POST['last_name'] : null;
    $password = isset($_POST['user_password']) ? $_POST['user_password'] : null;

    // Validate received data
    if (!$username || !$email || !$first_name || !$last_name || !$password) {
        echo json_encode(['success' => false, 'message' => 'All fields are required.']);
        exit;
    }

    // Prepare an SQL statement for safe insertion into the database
    $stmt = $con->prepare("INSERT INTO users (username, email, first_name,
     last_name, user_password) VALUES (?, ?, ?, ?, ?)");

    // Hash the password before storing it
    //$hashedPassword = password_hash($password, PASSWORD_DEFAULT);

    // Bind parameters to the SQL query
    $stmt->bind_param("sssss", $username, $email, $first_name, $last_name, $user_password);

    // Execute the query and check for success
    if ($stmt->execute()) {
        echo json_encode(['success' => true, 'message' => 'User successfully added.']);
    } else {
        // Return detailed error information in case of failure
        echo json_encode(['success' => false, 'message' => 'Failed to add user: ' . $stmt->error]);
    }

    // Close the prepared statement
    $stmt->close();
} else {
    // Return error if not a POST request
    echo json_encode(['success' => false, 'message' => 'Invalid request method. Only POST is allowed.']);
}

// Close database connection
$con->close();
?>
