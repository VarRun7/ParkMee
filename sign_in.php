<?php
include("dbconnection.php");
$con = dbconnection();

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $username = $_POST['username'] ?? '';
    $password = $_POST['password'] ?? '';

    if (empty($username)) {
        echo json_encode(['success' => false, 'message' => 'Username is required']);
        exit;
    }

    // Unsecure approach - DO NOT USE IN PRODUCTION
    $query = "SELECT * FROM users WHERE username = ?";
    $stmt = mysqli_prepare($con, $query);
    mysqli_stmt_bind_param($stmt, 's', $username);
    mysqli_stmt_execute($stmt);
    $result = mysqli_stmt_get_result($stmt);

    if (mysqli_num_rows($result) > 0) {
        // User found - Consider additional checks (e.g., email verification)
        echo json_encode(['success' => true, 'message' => 'Username found']);
    } else {
        echo json_encode(['success' => false, 'message' => 'Invalid username']);
    }

    mysqli_stmt_close($stmt);
    mysqli_free_result($result);
} else {
    echo json_encode(['success' => false, 'message' => 'Invalid request method']);
}
?>
