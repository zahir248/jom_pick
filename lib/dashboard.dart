import 'package:flutter/material.dart';
import 'setting.dart';
import 'profile.dart';
import 'penalty.dart';
import 'history.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  int _selectedIndex = 0; // Index of the selected tab
  String? username = '';
  String? user_id; // Define user_id as an instance variable

  @override
  void initState() {
    super.initState();
  }

  void handleSetting() async {

    // Navigate to the login page (Assuming your login page is named Setting)
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Setting()));
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JomPick'),
        automaticallyImplyLeading: false, // Remove the back button
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              handleSetting(); // Logout when the button is pressed
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.white10, // Set the background color to grey
                border: OutlineInputBorder( // Use OutlineInputBorder for border
                  borderSide: BorderSide(color: Colors.white12), // Set the border color to grey
                  borderRadius: BorderRadius.circular(10.0), // Adjust the border radius as needed
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
            ),
          ),
        ],
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
