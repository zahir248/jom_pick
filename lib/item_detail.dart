import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'pickup_detail.dart';
import 'main.dart';
import 'pickup_confirmation.dart';
import '../models/confirmation_model.dart';


class ItemDetailPage extends StatefulWidget {
  final int itemId;
  final String itemName;
  final String trackingNumber;
  final String itemType;
  final String status;
  //final Uint8List imageData;
  final DateTime confirmationDate;
  final String address;

  ItemDetailPage({
    required this.itemId,
    required this.itemName,
    required this.trackingNumber,
    required this.itemType,
    //required this.imageData,
    required this.status,
    required this.confirmationDate,
    required this.address,
  });

  @override
  _ItemDetailPageState createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  int _currentIndex = 0; // Index for BottomNavigationBar

  bool hasExtendedPickupDate = false; // Flag to track whether pick-up date has been extended

  int? userId;
  int? itemId;

  List<Confirmation> confirmationData= [];  // List to store fetch confirmation data
  List<Confirmation> filteredConfirmationData = [];

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
                          'Item Detail',
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
                  SizedBox(height: 20),
                  buildDetailItem("Tracking Number", widget.trackingNumber),
                  SizedBox(height: 20),
                  buildDetailItem("Type", widget.itemType),
                  SizedBox(height: 20),
                  buildDetailItem("Pick-up Location", widget.address),
                  SizedBox(height: 20),
                  buildDetailItem("Picture", ""),
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Container(
                        width: 350,
                        height: 200,
                        // child: Image.memory(
                        //   widget.imageData,
                        //   fit: BoxFit.cover,
                        // ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  buildDetailItem("Status", widget.status),
                  SizedBox(height: 20),
                  buildDetailItem(
                      "Pick-up Due Date",
                      DateFormat('d MMMM yyyy')
                          .format(widget.confirmationDate)),
                  SizedBox(height: 50),
                  Container(
                    height: 95,
                    padding: EdgeInsets.all(16),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(onPressed: (){

                          },
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(200, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                elevation: 9,
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 30),
                              ),
                              child: Text('Extend',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold,
                                ),
                              ),
                          ),
                          SizedBox(width: 40),
                          Column(
                            children: <Widget>[
                              //ListView.builder(
                                // itemCount: filteredConfirmationData.length,
                                // itemBuilder: (BuildContext context, int index){
                                  //Confirmation item = filteredConfirmationData[index];
                                  ElevatedButton(
                                    onPressed: (){
                                      _pickupConfirmation( context
                                        // filteredConfirmationData[index].confirmationId,
                                        // filteredConfirmationData[index].status,
                                        // filteredConfirmationData[index].confirmationDate as Duration,
                                        // filteredConfirmationData[index].currentLocation,
                                        // filteredConfirmationData[index].pickUpDuration as DateTime,
                                        // filteredConfirmationData[index].pickUpLocation,
                                        // context,
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      fixedSize: Size(200, 50),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(100),
                                      ),
                                      elevation: 9,
                                      padding: EdgeInsets.symmetric(
                                          vertical: 10, horizontal: 30),
                                    ),
                                    child: Text('Pick Up',
                                      style: TextStyle(
                                        fontSize: 16, fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                //},),
                            ],
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: [
          buildBottomNavBarItem("Extend Pick-up Due Date"),
          buildBottomNavBarItem("Pick-up Detail"),
        ],
        onTap: (index) async {
          // Handle button taps here
          if (index == 0) {
            _showExtendDueDateForm();
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PickupDetailPage(
                    address: widget.address,
                    itemId: widget.itemId,
                    confirmationDate: widget.confirmationDate, // Pass the confirmationDate to PickupDetailPage
                ),
              ),
            );
          }
          setState(() {
            _currentIndex = index;
          });
        },
        elevation: 8.0,
        selectedItemColor: Colors.blue,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  void _showExtendDueDateForm() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        DateTime newPickupDate = widget.confirmationDate.add(Duration(days: 3));

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: Icon(Icons.cancel),
                    onPressed: () {
                      if (mounted) {
                        Navigator.pop(context);
                      }
                    },
                  ),
                ),
                Text(
                  'Extend Pick-up Date',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  '*Pick-up deadline will be extended to 3 days from the current date. Beyond this, a RM5 fee applies. If not collected within 7 days after the date, the item may be disposed of by management.',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 25),
                Text(
                  'New Pick-Up Date: ${DateFormat('d MMMM yyyy').format(newPickupDate)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (mounted && !hasExtendedPickupDate) {
                        // Send a request to the server to update the pick-up date
                        final updateStatus = await updateConfirmationDateOnServer(widget.itemId, newPickupDate);

                        if (updateStatus == "Update successful") {
                          // Set the flag to true after extending the pick-up date
                          setState(() {
                            hasExtendedPickupDate = true;
                          });

                          // Show toast after successful update
                          Fluttertoast.showToast(
                            msg: "Pick-up date extended successfully",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );

                          Navigator.pop(context);
                        } else {
                          // Display a message based on the server response
                          Fluttertoast.showToast(
                            msg: updateStatus,
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        }
                      } else {
                        // Display a message if the user attempts to extend again
                        Fluttertoast.showToast(
                          msg: "You have already extended the pick-up date before",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    child: Text('Confirm'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<String> updateConfirmationDateOnServer(int itemId, DateTime newPickupDate) async {
    try {
      final url = Uri(
        scheme: 'http',
        host: MyApp.baseIpAddress,
        path: MyApp.updateConfirmationDatePath,
      );

      // Send a POST request to the server
      final response = await http.post(
        url,
        body: {
          'itemId': itemId.toString(),
          'newPickupDate': newPickupDate.toIso8601String(),
        },
      );

      return response.body;
    } catch (e) {
      print('Error updating confirmation date: $e');
      return ''; // Return an empty string or handle the error as needed
    }
  }


  BottomNavigationBarItem buildBottomNavBarItem(String label) {
    return BottomNavigationBarItem(
      icon: Container(
        width: 180,
        height: 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.blue,
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14, // Adjust the font size here
            ),
          ),
        ),
      ),
      label: '', // Empty label to hide default label
    );
  }
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: _currentIndex,
      //   items: [
      //     buildBottomNavBarItem("Extend Due Date"),
      //     buildBottomNavBarItem("Pick Now"),
      //   ],
      //   onTap: (index) {
      //     // Handle button taps here
      //     if (index == 0) {
      //       // Logic for the first button (Edit)
      //       // Add your code to handle the 'Edit' button tap
      //     } else if (index == 1) {
      //       // Logic for the second button (Delete)
      //       // Add your code to handle the 'Delete' button tap
      //     }
      //     setState(() {
      //       _currentIndex = index;
      //     });
      //   },
      //   elevation: 8.0,
      //   selectedItemColor: Colors.blue,
      //   type: BottomNavigationBarType.fixed,
      // ),
    );
  }

  // BottomNavigationBarItem buildBottomNavBarItem(String label) {
  //   return BottomNavigationBarItem(
  //     icon: Container(
  //       width: 170,
  //       height: 45,
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.circular(10),
  //         color: Colors.blue,
  //       ),
  //       child: Center(
  //         child: Text(
  //           label,
  //           style: TextStyle(
  //             color: Colors.white,
  //             fontWeight: FontWeight.bold,
  //             fontSize: 14, // Adjust the font size here
  //           ),
  //         ),
  //       ),
  //     ),
  //     label: '', // Empty label to hide default label
  //   );
  // }

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

void _pickupConfirmation(context){

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context)=> pickupConfirmation(),
    ),
  );
}

// void _pickupConfirmation(
//     int confirmationId,
//     String status,
//     Duration pickUpDuration,
//     String currentLocation,
//     DateTime confirmationDate,
//     String pickUpLocation,
//     BuildContext context){
//
//   Navigator.push(
//       context,
//       MaterialPageRoute(
//           builder: (context)=> pickupConfirmation(
//             confirmationId: confirmationId,
//             status: status,
//             pickUpDuration: pickUpDuration,
//             currentLocatin: currentLocation,
//             confirmationDate: confirmationDate,
//             pickUpLocation: pickUpLocation,
//           ),
//       ),
//   );
// }


