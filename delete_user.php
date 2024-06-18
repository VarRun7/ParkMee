<?php
include("dbconnection.php");
$con = dbconnection();

// Assuming you pass the user ID as a POST variable
$username = $_POST['username'];

if (!$username) {
    http_response_code(400);
    echo json_encode(['error' => 'User name is required']);
    exit;
}

$query = "DELETE FROM users WHERE username = ?;";
$exe = mysqli_prepare($con, $query);
mysqli_stmt_bind_param($exe, 'i', $username);
$result = mysqli_stmt_execute($exe);
//$arr = [];
if ($result) {
    echo json_encode(['success' => 'Account deleted successfully']);
} else {
    http_response_code(500);
    echo json_encode(['error' => 'Failed to delete account']);
}
//print(json_encode(username))
?>
