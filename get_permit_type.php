<?php
include("dbconnection.php");

header('Content-Type: application/json');
$con = dbconnection();

$owner_of_vehicle = $_POST['username'] ?? '';  // Accessing username directly from $_POST

if (empty($owner_of_vehicle)) {
    echo json_encode(['success' => false, 'message' => 'Username is required']);
    exit;
}

$query = "SELECT permit_type FROM users WHERE owner_of_vehicle = ?";
$stmt = mysqli_prepare($con, $query);
mysqli_stmt_bind_param($stmt, 's', $owner_of_vehicle);
mysqli_stmt_execute($stmt);
$result = mysqli_stmt_get_result($stmt);

if ($row = mysqli_fetch_assoc($result)) {
    echo json_encode(['permit_type' => $row['permit_type']]); // Return the permit type as JSON
} else {
    echo json_encode(['success' => false, 'message' => 'No such user found']);
}

mysqli_stmt_close($stmt);
mysqli_close($con);
?>
