<?php

include("dbconnection.php"); // Include the database connection script

$con = dbconnection(); // Establish the database connection

if (mysqli_error($con)) {
  echo "Connection Error: " . mysqli_error($con);
} else {
  echo "Connection Successful!";
}

mysqli_close($con); // Close the connection

?>
