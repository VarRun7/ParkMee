<?php
// Connect to your database
// Include database connection script
include "dbconnection.php";

// Connect to the database
$con = dbconnection();

// Prepare SQL statement (assuming permit_type is not used for filtering)
$sql = "SELECT garage_name, open_spots FROM ParkingSpotDB.garages WHERE permit_type LIKE '%?%';";

$result = $conn->query($sql);

$garages = [];

if ($result->num_rows > 0) {
  // Loop through results and create an array of garage information
  while($row = $result->fetch_assoc()) {
    $garages[] = array(
      "garage_name" => $row["garage_name"],
      "open_spots" => $row["open_spots"]
    );
  }
}

$conn->close();

echo json_encode($garages);
?>
class _MarkSpotScreenState extends State<MarkSpotScreen> {
  bool isParked = false;
  int availableSpots = 0; // Store available spots

  @override
  void initState() {
    super.initState();
    availableSpots = widget.selectedGarage["open_spots"]; // Initial value
    fetchAvailableSpots(); // Fetch initial available spots
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mark Spot'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Available Spots: $availableSpots',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // ... rest of your code for marking a spot (optional)
          ],
        ),
      ),
    );
  }

  void fetchAvailableSpots() async {
    final response = await http.get(
      Uri.parse('http://127.0.0.1/ParkMee_api/get_available_spots.php?garage_name=${widget.selectedGarage["garage_name"]}'),
    );

    if (response.statusCode == 200) {
      final newAvailableSpots = json.decode(response.body)["available_spots"];
      setState(() {
        availableSpots = newAvailableSpots;
      });
    } else {
      // Handle error fetching available spots
    }

    // Schedule another fetch after a certain interval (e.g., 30 seconds)
    Future.delayed(const Duration(seconds: 30), fetchAvailableSpots);
  }
}
