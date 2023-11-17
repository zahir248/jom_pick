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
        child: Container(
          width: double.infinity, // Expand the container to take the full width
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 50, 16.0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () {
                        Navigator.pop(context); // Go back to the previous screen
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16.0, 50.0, 16.0, 10.0),
                      child: Text(
                        'Detail',
                        style: TextStyle(
                          fontSize: 30, // Adjust the font size as needed
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 50), // Adjust the width as needed
                  ],
                ),
                SizedBox(height: 30), // Increased space
                buildDetailItem("Item ID", widget.itemId.toString()),
                SizedBox(height: 20), // Increased space
                buildDetailItem("Name", widget.itemName),
                SizedBox(height: 20), // Increased space
                buildDetailItem("Tracking Number", widget.trackingNumber),
                SizedBox(height: 30), // Increased space
                // Display the image using Image.memory
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5), // Increased space between label and value
          Text(
            value,
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
