import 'package:flutter/material.dart';
import 'package:jom_pick/HomeScreen.dart';
import 'package:jom_pick/setting.dart';

class UserManual extends StatelessWidget {
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
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Setting()),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 1.0, 16.0, 10.0),
              child: Container(
                alignment: Alignment.center, // Center alignment for "User Manual" text
                child: Text(
                  'User Manual',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
            SizedBox(height: 16),
            Text(
              '1. Introduction',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 1.0, 16.0, 10.0),
              child: Text(
                'This user manual provides information on how to use the application',
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center, // Center alignment for this specific text
              ),
            ),
            SizedBox(height: 16),
            Text(
              '2. Getting Started',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'To get started, follow these steps:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text('- Step 1: Open the app'),
            Text('- Step 2: Explore the features'),
            // Add more steps as needed
          ],
        ),
      ),
    );
  }
}
