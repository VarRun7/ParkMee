// ignore_for_file: prefer_const_constructors, non_constant_identifier_names

import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'package:parkmee/view_user_data.dart';
Timer? _timer;

class GlobalData {
  static String? username;
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ParkMee',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome to ParkMee'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/parkmee_sign.png'),
            fit: BoxFit.cover,  // Ensures the image covers the container without overflowing
            alignment: Alignment(0, -1), // Shifts the image down; adjust the second parameter as needed
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 140),  // Space to adjust the position of the buttons
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegistrationScreen()),
                ),
                child: const Text('Sign Up'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  
                  MaterialPageRoute(builder: (context) => const SignInScreen()),
                ),
                  // Implement navigation to Sign In screen if you have one
                
                child: const Text('Sign In'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});


  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController(); // Use separate controller for password
  bool _isPasswordObscured = true; // State to toggle visibility
   // Variable to store the selected permit type

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background1.png"), // Specify the path to your background image
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            children: [
              SizedBox(height: 10), // Space for the logo
              Image.asset('assets/logo1.png', height: 100), // Adjust the path and size as necessary
              SizedBox(height: 20), // Additional space after the logo
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              TextField(
                controller: _passwordController,
                obscureText: _isPasswordObscured,
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordObscured ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordObscured = !_isPasswordObscured;
                      });
                    },
                  ),
                ),
              ),
              
              Spacer(),
              ElevatedButton(
                onPressed: () {
                // Set the global username before signing in
                GlobalData.username = _usernameController.text;

                // Now call the sign-in function
                _SignInUser(context);
              },
              child: const Text('Sign In'),
              ),

            ],
          ),
        ),
      ),
    );
  }

  void _SignInUser(BuildContext context) async {
  // Get the username and password from the text controllers
  String username = _usernameController.text.trim(); //trimming removes blank spaces 
  String password = _passwordController.text;

  // URL of your PHP API endpoint
  var url = Uri.parse('http://127.0.0.1/ParkMee_api/sign_in.php');

  // POST request to the server
  var response = await http.post(url, body: {
    'username': username,
    'password': password
  });

  // Decode the JSON response from the server
  var data = jsonDecode(response.body);

  // Handle the response
  if (response.statusCode == 200) {
    if (data['success']) {
      GlobalData.username = username;
      // On successful sign-in, navigate to the next page or update UI
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ParkingDashboard()), // Navigate to Dashboard
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login successful')),
      );
    } else {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: ${data['message']}')),
      );
    }
  } else {
    // Handle HTTP errors here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Network error')),
    );
  }
}
}

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController username = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController first_name = TextEditingController();
  final TextEditingController last_name = TextEditingController();
  final TextEditingController user_password = TextEditingController();
  final TextEditingController _passwordController1 = TextEditingController(); // Use separate controller for password
  bool _isPasswordObscured = true; // State to toggle visibility
  
  Future<void> insert_record() async {
    if(username.text!="" || email.text!="" || first_name.text!="" || last_name.text!="" || user_password.text!=""){
      try {
        print("try tag");
        String uri = "http://127.0.0.1/ParkMee_api/insert_record.php";

        var res = await http.post(Uri.parse(uri), body:{
          "username": username.text,
          "email": email.text,
          "first_name": first_name.text,
          "last_name": last_name.text,
          "user_password": user_password.text
        });

        if(res.body.isNotEmpty) {
          var response = json.decode(res.body);  // Decoding the JSON response
          if (response["success"] == "true") {
            print("Record Inserted");
            username.text = "";
            email.text = "";
            first_name.text = "";
            last_name.text = "";
            user_password.text = "";
          } else {
            print("Some Issue");
          }
        }
      } catch(e, s) {
          print(s);
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Account'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background1.png"), // Specify the path to your background image
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            children: [
              SizedBox(height: 10), // Space for the logo
              Image.asset('assets/logo1.png', height: 100), // Adjust the path and size as necessary
              SizedBox(height: 20), // Additional space after the logo
              TextFormField(
                controller: username,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              TextFormField(
                controller: email,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              TextFormField(
                controller: first_name,
                decoration: const InputDecoration(labelText: 'First Name'),
              ),
              TextFormField(
                controller: last_name,
                decoration: const InputDecoration(labelText: 'Last Name'),
              ),
              TextFormField(
                controller: user_password,
                obscureText: _isPasswordObscured,
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordObscured ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordObscured = !_isPasswordObscured;
                      });
                    },
                  ),
                ),
              ),
              TextFormField(
                controller: _passwordController1,
                obscureText: _isPasswordObscured,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordObscured ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordObscured = !_isPasswordObscured;
                      });
                    },
                  ),
                ),
              ),
              
              Spacer(),
              ElevatedButton(
                onPressed: () {
                  insert_record();
                  print("Button pressed, calling insert_record.");
                  _NextRegistrationPage();
                  GlobalData.username = username.text;
                },
                child: const Text('Next Page'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _NextRegistrationPage() {
    GlobalData.username = username.text;
    // Here, you would typically send this data to a backend server.
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegistrationScreen2()),
    );
  }
}
class RegistrationScreen2 extends StatefulWidget {
  const RegistrationScreen2({super.key});

  @override
  State<RegistrationScreen2> createState() => _RegistrationScreenState2();
}

class _RegistrationScreenState2 extends State<RegistrationScreen2> {
  final TextEditingController _plateNumController = TextEditingController();
  final TextEditingController _makeController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _manuYearController = TextEditingController();
  String? _compactSizeSelector;  // Variable to store the selected permit type
  String? _selectedPermitType;
  
  Future<void> insert_vehicle_record() async {
  if (_plateNumController.text.isNotEmpty && _makeController.text.isNotEmpty && _modelController.text.isNotEmpty && _manuYearController.text.isNotEmpty && _compactSizeSelector != null && _selectedPermitType != null) {
    try {
      String uri = "http://127.0.0.1/ParkMee_api/insert_vehicle_record.php";
      var response = await http.post(Uri.parse(uri), body: {
        "plate_num": _plateNumController.text,
        "make": _makeController.text,
        "model": _modelController.text,
        "year_manufactured": _manuYearController.text,
        "compact_size": _compactSizeSelector!,
        "permit_type": _selectedPermitType!,
        "owner_of_vehicle": GlobalData.username ?? 'defaultUser', // Ensure there's a fallback or check
      });

      if (response.body.isNotEmpty) {
        var data = json.decode(response.body);
        if (data["success"] == "true") {
          print("Record Inserted");
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Successfully Registered Vehicle!')));
        } else {
          print("Some Issue: " + data["message"]);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to register vehicle: ' + data["message"])));
        }
      }
    } catch (e, s) {
      print(s);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('An error occurred')));
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill all the fields')));
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicle Details'),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/background1.png"), // Specify the path to your background image
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            children: [
              SizedBox(height: 10), // Space for the logo
              Image.asset('assets/logo1.png', height: 100), // Adjust the path and size as necessary
              SizedBox(height: 20), // Additional space after the logo
              TextField(
                controller: _plateNumController,
                decoration: const InputDecoration(labelText: 'Plate Number'),
              ),
              TextField(
                controller: _makeController,
                decoration: const InputDecoration(labelText: 'Make'),
              ),
              TextField(
                controller: _modelController,
                decoration: const InputDecoration(labelText: 'Model'),
              ),
              TextField(
                controller: _manuYearController,
                decoration: const InputDecoration(labelText: 'Maufacturing Year'),
              ),
              
              DropdownButtonFormField<String>(
                value: _compactSizeSelector,
                decoration: const InputDecoration(labelText: 'Compact Sized Car'),
                items: const [
                  DropdownMenuItem(value: 'Yes', child: Text('Yes')),
                  DropdownMenuItem(value: 'No', child: Text('No')),
                ],
                onChanged: (String? newValue) {
                  setState(() {
                    _compactSizeSelector = newValue;
                  });
                },
                hint: Text('Select Compact Sized Car (Y/N)'),
              ),
              DropdownButtonFormField<String>(
                value: _selectedPermitType,
                decoration: const InputDecoration(labelText: 'Permit Type'),
                items: const [
                  DropdownMenuItem(value: 'S', child: Text('S')),
                  DropdownMenuItem(value: 'R', child: Text('R')),
                  DropdownMenuItem(value: 'E', child: Text('E')),
                  DropdownMenuItem(value: 'DV', child: Text('DV')),
                  DropdownMenuItem(value: 'GZ', child: Text('GZ')),
                ],
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedPermitType = newValue;
                  });
                },
                hint: Text('Select Permit Type'),
              ),
              Spacer(),
              ElevatedButton(
                onPressed: _registerUser,
                child: const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _registerUser() {
    insert_vehicle_record();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ParkingDashboard()), // Replace with your dashboard route
    );

    // Handle the case where data is not defined
    final snackBar = SnackBar(content: Text('Succesfully Registered!'));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

}
class ParkingDashboard extends StatelessWidget {
  const ParkingDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Parking Dashboard'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => view_user_data())
                );
              },
            ),
          ],
        ),
        body: TabBarView(
          children: [
            GarageOptions(),
            const LotOptions(),
          ],
        ),
      ),
    );
  }
}

class GarageOptions extends StatelessWidget {
  GarageOptions({Key? key}) : super(key: key);

  Future<List<Map<String, dynamic>>> fetchGarages() async {
    //final username = GlobalData.username;
    print(GlobalData.username);
    //if (username == null) throw Exception('Username not available');

    final response = await http.post(
  Uri.parse('http://127.0.0.1/ParkMee_api/get_permit_type.php'),
  body: {'owner_of_vehicle': GlobalData.username},  // Sending data as form data
);

if (response.statusCode == 200) {
  String permitType = jsonDecode(response.body);
  return fetchGaragesWithPermitType(permitType);
} else {
  throw Exception('Failed to fetch permit type (status code: ${response.statusCode})');
}
  }

  Future<List<Map<String, dynamic>>> fetchGaragesWithPermitType(String permitType) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1/ParkMee_api/get_garages.php'),
      body: {'permit_type': permitType},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      return data.map((item) => item as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to fetch garages: ${response.statusCode}');
    }
  }

  @override
Widget build(BuildContext context) {
  return FutureBuilder<List<Map<String, dynamic>>>(
    future: fetchGarages(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        // Show loading indicator while data is being fetched
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        // Properly display the error
        return Center(child: Text('Error: ${snapshot.error.toString()}'));
      } else if (snapshot.hasData && snapshot.data != null) {
        // Ensure data is not null
        final garages = snapshot.data!;
        if (garages.isEmpty) {
          // Handle the case where there is no data returned
          return const Center(child: Text('No garages found'));
        }
        return ListView.builder(
          itemCount: garages.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: Text(garages[index]["garage_name"]),
                trailing: Text('${garages[index]["open_spots"]} spots'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MarkSpotScreen(garageName: garages[index]["garage_name"]),
                    ),
                  );
                },
              ),
            );
          },
        );
      } else {
        // Handle the case where there is no data even if there's no error
        return const Center(child: Text('No garages available'));
      }
    },
  );
}
}

class LotOptions extends StatelessWidget {
  const LotOptions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> lots = [
      {"name": "Lot 3", "availableSpots": 20},
      {"name": "Lot 6", "availableSpots": 10},
      {"name": "Lot 21", "availableSpots": 12},
      {"name": "Lot 29", "availableSpots": 35},
      {"name": "Lot 36", "availableSpots": 7},
    ];

    return ListView.builder(
      itemCount: lots.length,
      itemBuilder: (context, index) {
        return Card(
          child: ListTile(
            title: Text(lots[index]["name"]),
            trailing: Text('${lots[index]["availableSpots"]} spots'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MarkSpotScreen(garageName: "Specific Garage Name"),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

void navigateToSpotActions(BuildContext context) {
  //Map<String, dynamic> SelectedGarage;
  // Navigation logic to the SearchSpotsScreen
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => MarkSpotScreen(garageName: "Specific Garage Name")),
  );
}

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: Stack(
        children: [
          ListView(
            // ignore: prefer_const_literals_to_create_immutables
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Username: user123'),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Email: user@example.com'),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('First Name: Vee'),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Last Name: Jay'),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Password: ******'),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: ElevatedButton(
                    onPressed: () => _showSignOutConfirmationDialog(context),
                    child: const Text('Sign Out'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: ElevatedButton(
                    onPressed: () => _showDeleteConfirmationDialog(context),
                    child: const Text('Delete Account'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete your account?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Dismisses the dialog only
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst); // Navigates back to the first screen
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void _showSignOutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Sign Out'),
          content: const Text('Are you sure you want to sign out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Dismisses the dialog only
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst); // Navigates back to the welcome screen
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}




class SearchSpotsScreen extends StatelessWidget {
  const SearchSpotsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search for Spots'),
      ),
      body: const Center(
        child: Text('Displaying available spots...'),
      ),
    );
  }
}

class MarkSpotScreen extends StatefulWidget {
  final String garageName;
  const MarkSpotScreen({Key? key, required this.garageName}) : super(key: key);
  @override
  State<MarkSpotScreen> createState() => _MarkSpotScreenState();
}

class _MarkSpotScreenState extends State<MarkSpotScreen> {
  bool isParked = false; // Initial state indicating whether a spot is marked as parked.
  int availableSpots = 0; // Store available spots

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
            Text(isParked ? 'Spot is marked as parked' : 'Spot is available'),
            ElevatedButton(
              onPressed: toggleParkingStatus, // Calls the toggle function when pressed
              child: Text(isParked ? 'Unmark as parked' : 'Mark as parked'),
            ),
          ],
        ),
      ),
    );
  }

  void fetchAvailableSpots() async {
    final response = await http.get(
      Uri.parse('http://127.0.0.1/ParkMee_api/available_spots.php?garage_name=Collins'), // Replace with actual garage name
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
    Future.delayed(const Duration(seconds: 5), fetchAvailableSpots);
  }
  void toggleParkingStatus() async {
  String garageName = "Collins"; // This should be dynamically set based on user selection
  var url = Uri.parse('http://127.0.0.1/ParkMee_api/toggle_parking.php');
  var response = await http.post(url, body: {
    'username': GlobalData.username ?? '',
    'garage_name': garageName,
    'is_parked': isParked ? '1' : '0',  // Assuming your API expects a flag to mark/unmark
  });

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    if (data['success']) {
      setState(() {
        isParked = !isParked;  // Toggle the local state only if the backend operation was successful
        availableSpots = data['available_spots'];  // Assuming your API returns the new available spots count
      });
    }
  } else {
    // Handle errors
    print("Failed to toggle parking status: ${response.body}");
  }
}
}