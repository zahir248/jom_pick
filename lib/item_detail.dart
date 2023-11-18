import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:intl/intl.dart';

class ItemDetailPage extends StatefulWidget {
  final int itemId;
  final String itemName;
  final String trackingNumber;
  final String itemType;
  final String status;
  final Uint8List imageData;
  final DateTime confirmationDate;

  ItemDetailPage({
    required this.itemId,
    required this.itemName,
    required this.trackingNumber,
    required this.itemType,
    required this.imageData,
    required this.status,
    required this.confirmationDate,
  });

  @override
  _ItemDetailPageState createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
        child: Container(
          width: double.infinity, // Expand the container to take the full width
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 30, 16.0, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () {
                        Navigator.pop(
                            context); // Go back to the previous screen
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(
                          16.0, 50.0, 16.0, 10.0),
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
                SizedBox(height: 30),
                // Increased space
                buildDetailItem("Item ID", widget.itemId.toString()),
                SizedBox(height: 20),
                // Increased space
                buildDetailItem("Name", widget.itemName),
                SizedBox(height: 20),
                // Increased space
                buildDetailItem("Tracking Number", widget.trackingNumber),
                SizedBox(height: 20),
                // Increased space
                buildDetailItem("Type", widget.itemType),
                SizedBox(height: 20),
                // Increased space
                buildDetailItem("Picture", ""),
                // Add an empty value for the image label
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    // Adjust the border radius as needed
                    child: Container(
                      width: 350, // Adjust the width as needed
                      height: 200, // Adjust the height as needed
                      child: Image.memory(
                        widget.imageData,
                        fit: BoxFit.cover, // Adjust the fit property as needed
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Increased space
                buildDetailItem("Status", widget.status),
                SizedBox(height: 20),
                // Increased space
                buildDetailItem("Due Date", DateFormat('d MMMM yyyy').format(widget.confirmationDate)),
                SizedBox(height: 100), // Additional space
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }

  Widget buildDetailItem(String label, dynamic value) {
    String formattedValue = value is DateTime
        ? DateFormat('yyyy-MM-dd').format(value)
        : value.toString();

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
            formattedValue, // Use formattedValue here
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}