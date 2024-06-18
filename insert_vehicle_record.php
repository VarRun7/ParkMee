<?php
include("dbconnection.php");
$con = dbconnection();

$plate_num = $_POST["plate_num"] ?? '';
$make = $_POST["make"] ?? '';
$model = $_POST["model"] ?? '';
$year_manufactured = $_POST["year_manufactured"] ?? '';
$compact_size = $_POST["compact_size"] ?? '';
$permit_type = $_POST["permit_type"] ?? '';
$owner_of_vehicle = $_POST["owner_of_vehicle"] ?? '';

// Prepared statement to insert data
$sql = "INSERT INTO ParkingSpotDB.vehicle (plate_num, make, model, year_manufactured, compact_size, permit_type, owner_of_vehicle) VALUES (?, ?, ?, ?, ?, ?, ?)";

$stmt = mysqli_prepare($con, $sql);
if ($stmt === false) {
    echo json_encode(array("success" => "false", "message" => "Error preparing statement: " . mysqli_error($con)));
    exit;
}

mysqli_stmt_bind_param($stmt, 'sssssss', $plate_num, $make, $model, $year_manufactured, $compact_size, $permit_type, $owner_of_vehicle);

if (mysqli_stmt_execute($stmt)) {
    echo json_encode(array("success" => "true"));
} else {
    echo json_encode(array("success" => "false", "message" => "Error inserting record: " . mysqli_error($con)));
}

mysqli_stmt_close($stmt);
mysqli_close($con);
?>
