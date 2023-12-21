import 'package:flutter/material.dart';
import 'package:jom_pick/HomeScreen.dart';
import 'package:jom_pick/history.dart';
import 'package:jom_pick/main.dart';
import 'package:jom_pick/penalty.dart';
import 'package:jom_pick/profile.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'change_password.dart';
import 'dashboard.dart';
import 'user_manual.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class Setting extends StatefulWidget {
  const Setting({Key? key}) : super(key: key);

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {

  int _selectedIndex = 3;

  void handleLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Clear the user session data
    prefs.remove('username');
    prefs.remove('icNumber');
    prefs.remove('fullName');
    prefs.remove('phoneNumber');
    prefs.remove('emailAddress');
    prefs.remove('user_id');
    prefs.remove('imagePath');

    // Clear the cache
    DefaultCacheManager().emptyCache();

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
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 50, 16.0, 0),
              child: Container(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                  onPressed: () {
                    // Navigate to the home page and replace the current page
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen()),
                    );
                    },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 1.0, 16.0, 10.0),
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
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to Change Password Page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChangePasswordPage()),
                  );                },
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(340, 45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(10.0), // Adjust the padding as needed
                  child: Text(
                    'Change Password',
                    style: TextStyle(fontSize: 16), // Increase the font size here
                  ),
                ),
              ),
            ),
            SizedBox(height: 5), // Add space between the second and third buttons
            Container(
              child: ElevatedButton(
                onPressed: () {
                // Navigate to User Manual Page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserManual()),
                  );},
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(340, 45),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(10.0), // Adjust the padding as needed
                  child: Text(
                    'User Manual',
                    style: TextStyle(fontSize: 16), // Increase the font size here
                  ),
                ),
              ),
            ),
            SizedBox(height: 20), // Add space between the third and fourth buttons
            Container(
              width: 340, // Set the same fixed width for all buttons
              child: ElevatedButton(
                onPressed: () {
                  handleLogout(); // Logout when the button is pressed
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100), // Adjust the value to control roundness
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  side: MaterialStateProperty.all(BorderSide(color: Colors.red)), // Set the border color to red
                ),
                child: Padding(
                  padding: EdgeInsets.all(10.0), // Adjust the padding as needed
                  child: Text(
                    'Logout',
                    style: TextStyle(fontSize: 16, color: Colors.red), // Increase the font size here
                  ),
                ),
              ),
            ),
          ],
        )
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
            icon: Icon(Icons.settings),
            label: 'Setting',
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

  void _onItemTapped(int index) {
    if (index == 4) {
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
    }else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Setting(),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
      setState(() {
        _selectedIndex = index;
      });
    }
  }

}
