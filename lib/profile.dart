import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dashboard.dart';
import 'penalty.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int _selectedIndex = 2; // Index of the selected tab
  String icNumber = ''; // Variable to store the IC number
  int? userId;
  String fullName = ''; // Variable to store the full name
  String phoneNumber = ''; // Variable to store the phone number
  String emailAddress = ''; // Variable to store the email address

  @override
  void initState() {
    super.initState();
    getSharedDataFromSharedPreferences();
  }

  Future<void> getSharedDataFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('user_id');
    String? storedIcNumber = prefs.getString('icNumber');
    String? storedFullName = prefs.getString('fullName');
    String? storedPhoneNumber = prefs.getString('phoneNumber');
    String? storedEmailAddress = prefs.getString('emailAddress');

    if (storedIcNumber != null) {
      setState(() {
        icNumber = storedIcNumber;
      });
    }
    if (storedFullName != null) {
      setState(() {
        fullName = storedFullName;
      });
    }
    if (storedPhoneNumber != null) {
      setState(() {
        phoneNumber = storedPhoneNumber;
      });
    }
    if (storedEmailAddress != null) {
      setState(() {
        emailAddress = storedEmailAddress;
      });
    }
  }

  void _onItemTapped(int index) {
    if (index == 2) {
      // If the "Profile" button is tapped (index 2), navigate to the profile page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Profile(),
        ),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Penalty(),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DashBoard(),
        ),
      );
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  Widget buildProfileField(String label, String value) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.only(left: 20, right: 20), // Add left and right padding
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align items at the start and end
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 20, // Reduce the font size for the label
                    fontWeight: FontWeight.bold, // Make the label bold
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.edit), // Edit icon
                  onPressed: () {
                    // Handle the edit action here
                  },
                ),
              ],
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 18, // Font size for the value
              ),
            ),
            SizedBox(height: 15), // Add space between the fields
          ],
        ),
      ),
    );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(70.0),
              child: Text(
                'Profile',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            buildProfileField('Full Name', fullName),
            buildProfileField('Phone Number', phoneNumber),
            buildProfileField('IC Number', icNumber),
            buildProfileField('Email Address', emailAddress),
            SizedBox(height: 20), // Add space between the second and third buttons
            Container(
                width: 300, // Set a fixed width for all the buttons, you can adjust this value
                child:ElevatedButton(
                  onPressed: () {
                    // Handle the update action here
                  },
                  child: Text('Update',
                    style: TextStyle(fontSize: 15), // Increase the font size here
                  ),
                )
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.error),
            label: 'Penalty',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
