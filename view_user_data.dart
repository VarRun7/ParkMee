// ignore_for_file: prefer_const_constructors, camel_case_types, use_super_parameters, prefer_const_constructors_in_immutables, avoid_print

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:parkmee/main.dart';

class view_user_data extends StatefulWidget {
    view_user_data({Key? key}) : super(key: key);

    @override
    State<view_user_data> createState() => _view_user_dataState();
}


class _view_user_dataState extends State<view_user_data> {
  Map<String, dynamic> userdata = {}; // To store user data

  Future<void> getrecord() async {
    String uri = "http://127.0.0.1/ParkMee_api/view_user_data.php";
    try {
      var response = await http.get(Uri.parse(uri));
      //var data = jsonDecode(response.body);
      //if (data.isNotEmpty) {
        setState(() {
        userdata = jsonDecode(response.body); // Assuming the API returns a list of users, and we take the first one
        });
    //}
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getrecord();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      body: Stack(
        children: [
          ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Username: ${userdata['username'] ?? "Loading..."}'),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Email: ${userdata['email'] ?? "Loading..."}'),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('First Name: ${userdata['first_name'] ?? "Loading..."}'),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Last Name: ${userdata['last_name'] ?? "Loading..."}'),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Password: ${"******"}'), // Presumably you don't actually fetch and show passwords
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
    Future<void> delrecord(String? username) async
    {
      try {
        String uri = "http://127.0.0.1/ParkMee_api/delete_user.php";
        var res = await http.post(Uri.parse(uri), body: {'username': GlobalData.username});
        var response = jsonDecode(res.body);
        if (response["success"]=="true"){
          print("record deleted");
        } else {
          print("Some issue deleteing the record");
        }
      } catch (e){
        print(e);
      }
    }
    //const username = 1; // You need to replace this with the actual user ID

    

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
                String? user = GlobalData.username;
                delrecord(user);
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
