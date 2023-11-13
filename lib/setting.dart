import 'package:flutter/material.dart';
import 'package:jom_pick/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dashboard.dart';

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  void handleLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Clear the user session data
    prefs.remove('username');
    prefs.remove('icNumber');
    prefs.remove('fullName');
    prefs.remove('phoneNumber');
    prefs.remove('emailAddress');
    prefs.remove('user_id');

    // Show a toast message to indicate successful logout
    Fluttertoast.showToast(
      msg: "Logout successful",
      backgroundColor: Colors.green,
      textColor: Colors.white,
      toastLength: Toast.LENGTH_SHORT,
    );

    // Navigate to the login page (Assuming your login page is named MyHomePage)
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyHomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Redirects to the dashboard page
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => DashBoard()));
          },
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0), // Adjust the padding as needed for the title
              child: Text(
                'Setting',
                style: TextStyle(
                  fontSize: 30, // Adjust the font size as needed
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20), // Add space between the title and the first button
            Container(
              width: 300, // Set a fixed width for all the buttons, you can adjust this value
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to Change Password Page
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9.0), // Adjust the value to control roundness
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all(Colors.blue), // Change the background color as needed
                ),
                child: Padding(
                  padding: EdgeInsets.all(10.0), // Adjust the padding as needed
                  child: Text(
                    'Change Password',
                    style: TextStyle(fontSize: 15), // Increase the font size here
                  ),
                ),
              ),
            ),
            SizedBox(height: 5), // Add space between the second and third buttons
            Container(
              width: 300, // Set the same fixed width for all buttons
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to User Manual Page
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9.0), // Adjust the value to control roundness
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all(Colors.blue), // Change the background color as needed
                ),
                child: Padding(
                  padding: EdgeInsets.all(10.0), // Adjust the padding as needed
                  child: Text(
                    'User Manual',
                    style: TextStyle(fontSize: 15), // Increase the font size here
                  ),
                ),
              ),
            ),
            SizedBox(height: 20), // Add space between the third and fourth buttons
            Container(
              width: 300, // Set the same fixed width for all buttons
              child: ElevatedButton(
                onPressed: () {
                  handleLogout(); // Logout when the button is pressed
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9.0), // Adjust the value to control roundness
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  side: MaterialStateProperty.all(BorderSide(color: Colors.red)), // Set the border color to red
                ),
                child: Padding(
                  padding: EdgeInsets.all(10.0), // Adjust the padding as needed
                  child: Text(
                    'Logout',
                    style: TextStyle(fontSize: 15, color: Colors.red), // Increase the font size here
                  ),
                ),
              ),
            ),
          ],
        )
      ),
    );
  }
}
