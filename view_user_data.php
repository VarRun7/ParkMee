<?php

error_reporting(E_ALL);
ini_set('display_errors', 1);

include("dbconnection.php"); // Include the database connection script

$con = dbconnection(); // Establish the database connection
//var_dump(mysqli_error($con));

// Construct the query to select all user data for 'anthonyroberts'
$query = "SELECT * FROM users WHERE `username` = 'Varennyam'";
//var_dump($query);

// Execute the query
$result = mysqli_query($con, $query);
//var_dump($result);
//var_dump(mysqli_error($con));

// Check for errors during data retrieval
try {
  if ($result) {
    $user_data = mysqli_fetch_assoc($result);
    echo json_encode($user_data);
  } else {
    throw new Exception("Error retrieving data: " . mysqli_error($con));
  }
} catch (Exception $e) {
  echo "Error: " . $e->getMessage();
}

// Close the database connection
mysqli_close($con);

?>
