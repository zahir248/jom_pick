import 'dart:typed_data';
import 'package:flutter/material.dart';

class ItemDetailPage extends StatefulWidget {
  final int itemId;
  final String itemName;
  final String trackingNumber;

  ItemDetailPage({
    required this.itemId,
    required this.itemName,
    required this.trackingNumber,
  });

  @override
  _ItemDetailPageState createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
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
                    Navigator.pop(context); // Go back to the previous screen
                  },
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
            ),
            Text(
              'Item Name: ${widget.itemName}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Tracking Number: ${widget.trackingNumber}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            // Display the image using Image.memory
          ],
        ),
      ),
    );
  }
}
