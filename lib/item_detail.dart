import 'package:flutter/material.dart';
import 'dashboard.dart';

class ItemDetailPage extends StatefulWidget {
  final int itemId;

  ItemDetailPage({required this.itemId});

  @override
  _ItemDetailPageState createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  // You can add state variables here if needed

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
                      // Navigate to the home page and replace the current page
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => DashBoard()),
                      );                  },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 1.0, 16.0, 10.0),
                child: Text(
                  'Detail',
                  style: TextStyle(
                    fontSize: 30, // Adjust the font size as needed
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Item ID: ${widget.itemId}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),// Add space between the title and the first button
            ],
          )
      ),
    );
  }
}
