import 'dart:async';
import 'package:flutter/material.dart';

import 'main.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Add a delay to simulate the splash screen for 2 seconds
    Timer(
      Duration(seconds: 2),
          () {
        // Navigate to the login screen after the delay
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyHomePage()),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Display your logo image here
            Image.asset(
              'assets/jompick2.png',  // Replace with the path to your logo image
              width: 350,  // Adjust the width as needed
              height: 350,  // Adjust the height as needed
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
