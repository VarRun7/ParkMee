<?php
$host = '127.0.0.1'; // or your host, e.g., IP or URL
$dbname = 'ParkingSpotDB'; // your database name
$user = 'root'; // your database username
$password = 'root'; // your database password

// Create connection
function dbconnection()
{
    $con = new mysqli('127.0.0.1', 'root', 'Varun@2512', 'parkingspotdb');
    return $con;
}

?>