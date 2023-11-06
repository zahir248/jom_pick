import 'package:flutter/material.dart';
import 'package:jom_pick/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dashboard.dart';

class Penalty extends StatefulWidget {
  const Penalty({Key? key}) : super(key: key);

  @override
  _PenaltyState createState() => _PenaltyState();
}

class _PenaltyState extends State<Penalty> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Redirects to the dashboard page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => DashBoard()),
            );
          },
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
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
    );
  }
}






