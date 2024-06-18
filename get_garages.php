<?php
include("dbconnection.php");

header('Content-Type: application/json');
$con = dbconnection();

$permit_type = $_POST['permit_type'] ?? '';

if (empty($permit_type)) {
    echo json_encode(['success' => false, 'message' => 'Permit type is required']);
    exit;
}

$query = "SELECT garage_name, open_spots FROM garages WHERE permit_type LIKE ?";
$stmt = mysqli_prepare($con, $query);
$like_permit = "%$permit_type%";
mysqli_stmt_bind_param($stmt, 's', $like_permit);
mysqli_stmt_execute($stmt);
$result = mysqli_stmt_get_result($stmt);

$garages = [];
while ($row = mysqli_fetch_assoc($result)) {
    $garages[] = $row;
}

if (!empty($garages)) {
    echo json_encode($garages);
} else {
    echo json_encode(['success' => false, 'message' => 'No garages found for this permit type']);
}

mysqli_stmt_close($stmt);
mysqli_close($con);
?>
