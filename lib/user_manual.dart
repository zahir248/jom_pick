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

            SizedBox(height: 8),
            SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '1. Introduction',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                 Text(
                    'This user manual provides information on how to use the application',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center, // Center alignment for this specific text
                  ),
                SizedBox(height: 18),
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
                Text('Pending Items :',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold
                  ),
                ),
                SizedBox(height: 10),
                Text('1. Open Items box at the homescreen'),
                Text('2. Click on Details button for your item'),
                Text('3. You can extend your pickup day up to 3 days but only for once'),
                Text('4. Click Pick-up Detail button see pick-up option'),
                Text('5. Click Go button if you want to get direction to your pick-up location '),
                Text('6. Click Select button on Choose Pick-up date to choose a specific pick-up date'),
                Text('7. Click Pick Now button to pick-up your item at current time'),
                Text('8. Click Show button when you arrived at pick-up location to let the staff verify your item by scanning the QR code'),
              ],
            ),
            SizedBox(height: 8),

            // Add more steps as needed
          ],
        ),
      ),
    );
  }
}
