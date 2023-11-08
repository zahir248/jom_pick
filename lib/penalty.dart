import 'package:flutter/material.dart';
import 'package:jom_pick/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dashboard.dart';
import 'profile.dart';
import 'penalty.dart';

class Penalty extends StatefulWidget {
  const Penalty({Key? key}) : super(key: key);

  @override
  _PenaltyState createState() => _PenaltyState();
}

class _PenaltyState extends State<Penalty> {
  int _selectedIndex = 1; // Index of the selected tab

  void _onItemTapped(int index) {
    if (index == 2) {
      // If the "Profile" button is tapped (index 2), navigate to the profile page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              Profile(), // Replace "ProfilePage()" with the actual profile page widget
        ),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              Penalty(), // Replace "PenaltyPage()" with the actual profile page widget
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              DashBoard(), // Replace "DashBoardPage()" with the actual profile page widget
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
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(70.0),
              child: Text(
                'Penalty',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
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






