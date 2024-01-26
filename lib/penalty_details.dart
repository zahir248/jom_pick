
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class penaltyDetailPage extends StatefulWidget {
  final int itemId;
  final String itemName;
  final String itemType;
  final String confirmationStatus;
  final String trackingNumber;
  final DateTime dueDate;
  final String dueDateStatus;
  Uint8List imageData;
  final String paymentStatus;
  final String paymentAmount;
  final String pickUpLocation;

  penaltyDetailPage({
    required this.itemId,
    required this.itemName,
    required this.trackingNumber,
    required this.itemType,
    required this.confirmationStatus,
    required this.imageData,
    required this.dueDate,
    required this.dueDateStatus,
    required this.paymentStatus,
    required this.paymentAmount,
    required this.pickUpLocation,
  });

  @override
  State<penaltyDetailPage> createState() => penaltyDetailPageState();
}

class penaltyDetailPageState extends State<penaltyDetailPage> {
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
                            16.0, 40.0, 16.0, 10.0),
                        child: Text(
                          'Penalty Details',
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
                  buildDetailItem("Pick Up Location", widget.pickUpLocation),
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
                  // SizedBox(height: 20),
                  // buildDetailItem("Status", widget.dueDateStatus),
                  // Divider(),
                  SizedBox(height: 20),
                  buildDetailItem(
                    "Due Date",
                    DateFormat('d MMMM yyyy').format(widget.dueDate),
                  ),
                  Divider(),
                  SizedBox(height: 20),
                  buildDetailItem("Payment Amount (RM)", widget.paymentAmount),
                  Divider(),
                  SizedBox(height: 20),
                  buildDetailItem("Payment Status", widget.paymentStatus),
                  Divider(),
                  SizedBox(height: 50),
                  // Container(
                  //   height: 95,
                  //   padding: EdgeInsets.all(16),
                  //   child: Align(
                  //     alignment: Alignment.bottomCenter,
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.center,
                  //       children: [
                  //         ElevatedButton(onPressed: () {
                  //
                  //         },
                  //           style: ElevatedButton.styleFrom(
                  //             fixedSize: Size(200, 50),
                  //             shape: RoundedRectangleBorder(
                  //               borderRadius: BorderRadius.circular(100),
                  //             ),
                  //             elevation: 9,
                  //             padding: EdgeInsets.symmetric(
                  //                 vertical: 10, horizontal: 30),
                  //           ),
                  //           child: Text('Extend',
                  //             style: TextStyle(
                  //               fontSize: 16, fontWeight: FontWeight.bold,
                  //             ),
                  //           ),
                  //         ),
                  //         SizedBox(width: 40),
                  //         Column(
                  //           children: <Widget>[
                  //             //ListView.builder(
                  //             // itemCount: filteredConfirmationData.length,
                  //             // itemBuilder: (BuildContext context, int index){
                  //             //Confirmation item = filteredConfirmationData[index];
                  //             ElevatedButton(
                  //               onPressed: () {
                  //
                  //               },
                  //               style: ElevatedButton.styleFrom(
                  //                 fixedSize: Size(200, 50),
                  //                 shape: RoundedRectangleBorder(
                  //                   borderRadius: BorderRadius.circular(100),
                  //                 ),
                  //                 elevation: 9,
                  //                 padding: EdgeInsets.symmetric(
                  //                     vertical: 10, horizontal: 30),
                  //               ),
                  //               child: Text('Pick Up',
                  //                 style: TextStyle(
                  //                   fontSize: 16, fontWeight: FontWeight.bold,
                  //                 ),
                  //               ),
                  //             ),
                  //             //},),
                  //           ],
                  //         )
                  //       ],
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDetailItem(String label, dynamic value, {TextStyle? textStyle}) {
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

MaterialColor getStatusColor(String status){
  if(status == 'paid'){
    return Colors.green;
  }else if(status == 'unpaid'){
    return Colors.red;
  }else{
    return Colors.grey;
  }
}
