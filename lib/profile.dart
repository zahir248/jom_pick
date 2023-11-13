import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dashboard.dart';
import 'penalty.dart';
import 'history.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  int _selectedIndex = 3; // Index of the selected tab
  String icNumber = ''; // Variable to store the IC number
  int? userId;
  String fullName = ''; // Variable to store the full name
  String phoneNumber = ''; // Variable to store the phone number
  String emailAddress = ''; // Variable to store the email address
  String username = ''; // Variable to store the email address

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
    String? storedUsername = prefs.getString('username');

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
    if (storedUsername != null) {
      setState(() {
        username = storedUsername;
      });
    }
  }

  Future<void> _showEditDialog(String label, String currentValue) async {
    TextEditingController controller = TextEditingController(text: currentValue);
    TextInputType keyboardType = TextInputType.text; // Default to a text keyboard

    // Set the keyboardType based on the label
    if (label == 'Phone Number' || label == 'IC Number') {
      keyboardType = TextInputType.number;
    }

    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit $label'),
          content: TextField(
            controller: controller,
            keyboardType: keyboardType, // Set the keyboard type
            decoration: InputDecoration(labelText: label),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                // Update the respective value based on the label
                setState(() {
                  if (label == 'Full Name') {
                    fullName = controller.text;
                  } else if (label == 'Phone Number') {
                    phoneNumber = controller.text;
                  } else if (label == 'IC Number') {
                    icNumber = controller.text;
                  } else if (label == 'Email Address') {
                    emailAddress = controller.text;
                  }
                });
                // Update SharedPreferences here
                updateSharedPreferences();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> updateProfile() async {
    try {
      // Assuming you have an API endpoint for updating the user profile
      final response = await http.post(
        Uri.http('10.200.90.242', '/update.php', {'q': '{http}'}),
        body: {
          'user_id': userId.toString(),
          'fullName': fullName,
          'phoneNumber': phoneNumber,
          'icNumber': icNumber,
          'emailAddress': emailAddress,
        },
      );

      if (response.statusCode == 200) {
        // Successfully updated the profile
        // Parse the JSON response
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['success']) {
          // Update was successful, show the toast and update state
          Fluttertoast.showToast(
            backgroundColor: Colors.green,
            textColor: Colors.white,
            msg: 'Profile updated successfully',
            toastLength: Toast.LENGTH_SHORT,
          );

          // Update the state variables directly
          setState(() {
            fullName = responseData['fullName'];
            phoneNumber = responseData['phoneNumber'];
            icNumber = responseData['icNumber'];
            emailAddress = responseData['emailAddress'];
          });

          // Update SharedPreferences here
          updateSharedPreferences();
        } else {
          // Update failed, show an error toast
          Fluttertoast.showToast(msg: 'No changes to update');
        }
      } else {
        // HTTP request failed, show an error toast
        Fluttertoast.showToast(msg: 'Failed to update profile');
      }
    } catch (error) {
      // Handle any exceptions that might occur during the update
      print('Error updating profile: $error');
    }
  }


  void updateSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('icNumber', icNumber);
    prefs.setString('fullName', fullName);
    prefs.setString('phoneNumber', phoneNumber);
    prefs.setString('emailAddress', emailAddress);
  }

  void _onItemTapped(int index) {
    if (index == 3) {
      // If the "Profile" button is tapped (index 2), navigate to the profile page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Profile(),
        ),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Penalty(),
        ),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => History(),
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
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // Show the edit dialog when the edit icon is pressed
                    _showEditDialog(label, value);
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
              padding: const EdgeInsets.only(top: 70.0), // Adjust the top padding value
              child: Text(
                'Profile',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 30), // Adjust the height as needed
            CircleAvatar(
              radius: 70, // Adjust the radius as needed
              backgroundColor: Colors.blue, // Set the background color to blue
            ),
            SizedBox(height: 15), // Adjust the height as needed
            Text(
              username, // Replace with the actual username variable
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30), // Add space between the second and third buttons
            buildProfileField('Full Name', fullName),
            buildProfileField('Phone Number', phoneNumber),
            buildProfileField('IC Number', icNumber),
            buildProfileField('Email Address', emailAddress),
            SizedBox(height: 20), // Add space between the second and third buttons
            Container(
                width: 300, // Set a fixed width for all the buttons, you can adjust this value
                child:ElevatedButton(
                  onPressed: () {
                    updateProfile();
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0), // Adjust the value to control roundness
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all(Colors.blue), // Change the background color as needed
                  ),
                  child: Text('Update Profile',
                    style: TextStyle(fontSize: 15), // Increase the font size here
                  ),
                )
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
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





