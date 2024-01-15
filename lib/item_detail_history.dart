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
  final DateTime dueDate;
  final Uint8List imageProofData;
  final DateTime pickUpDate;

  ItemDetailPage({
    required this.itemId,
    required this.itemName,
    required this.trackingNumber,
    required this.itemType,
    required this.imageData,
    required this.status,
    required this.dueDate,
    required this.imageProofData,
    required this.pickUpDate,
  });

  @override
  _ItemDetailPageState createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  int _currentIndex = 0; // Index for BottomNavigationBar

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: double.infinity,
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
                          Navigator.pop(context);
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                            16.0, 50.0, 16.0, 10.0),
                        child: Text(
                          'History Detail',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 50),
                    ],
                  ),
                  /*SizedBox(height: 30),
                  buildDetailItem("Item ID", widget.itemId.toString()),*/
                  SizedBox(height: 20),
                  buildDetailItem("Name", widget.itemName),
                  Divider(),
                  SizedBox(height: 20),
                  buildDetailItem("Tracking Number", widget.trackingNumber),
                  Divider(),
                  SizedBox(height: 20),
                  buildDetailItem("Type", widget.itemType),
                  Divider(),
                  SizedBox(height: 20),
                  buildDetailItem("Picture", ""),
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Container(
                        width: 350,
                        height: 200,
                        child: Image.memory(
                          widget.imageData,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Divider(),
                  SizedBox(height: 20),
                  buildDetailItem("Status", widget.status),
                  Divider(),
                  SizedBox(height: 20),
                  buildDetailItem(
                      "Pick Up Date",
                      DateFormat('d MMMM yyyy')
                          .format(widget.pickUpDate)),
                  Divider(),
                  SizedBox(height: 20),
                  buildDetailItem("Pick Up Proof", ""),
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Container(
                        width: 350,
                        height: 350,
                        child: Image.memory(
                          widget.imageProofData,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 50),
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
          SizedBox(height: 5),
          Text(
            formattedValue,
            style: TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}