<?php
include("dbconnection.php");

$response = array('success' => false, 'message' => '');

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $username = $_POST['username'] ?? '';
    $garage_name = $_POST['garage_name'] ?? '';

    $con = dbconnection();
    // Check if the user is currently parked
    $checkQuery = "SELECT * FROM parked_at WHERE pa_username = ? AND pa_garage_name = ?";
    $stmt = mysqli_prepare($con, $checkQuery);
    mysqli_stmt_bind_param($stmt, 'ss', $username, $garage_name);
    mysqli_stmt_execute($stmt);
    $result = mysqli_stmt_get_result($stmt);

    if (mysqli_num_rows($result) > 0) {
        // User is parked, so unpark them
        $deleteQuery = "DELETE FROM parked_at WHERE pa_username = ? AND pa_garage_name = ?";
        $deleteStmt = mysqli_prepare($con, $deleteQuery);
        mysqli_stmt_bind_param($deleteStmt, 'ss', $username, $garage_name);
        mysqli_stmt_execute($deleteStmt);
        $response['success'] = true;
        $response['message'] = 'Spot unmarked.';
    } else {
        // User is not parked, so park them
        $insertQuery = "INSERT INTO parked_at (time_parked, pa_username, pa_garage_name) VALUES (CURRENT_TIMESTAMP, ?, ?)";
        $insertStmt = mysqli_prepare($con, $insertQuery);
        mysqli_stmt_bind_param($insertStmt, 'ss', $username, garage_name);
        mysqli_stmt_execute($insertStmt);
        $response['success'] = true;
        $response['message'] = 'Spot marked as parked.';
    }

    mysqli_stmt_close($stmt);
    mysqli_close($con);
}

echo json_encode($response);
?>
