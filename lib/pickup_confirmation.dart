import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jom_pick/models/confirmation_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class pickupConfirmation extends StatefulWidget {
 const pickupConfirmation({super.key});

  // final int confirmationId;
  // final String status;
  // final Duration pickUpDuration;
  // final String currentLocatin;
  // final DateTime confirmationDate;
  // final String pickUpLocation;
  //
  // pickupConfirmation({
  //   required this.confirmationId,
  //   required this.status,
  //   required this.pickUpDuration,
  //   required this.currentLocatin,
  //   required this.confirmationDate,
  //   required this.pickUpLocation,
//});

  @override
  State<pickupConfirmation> createState() => _pickupConfirmationState();
}

class _pickupConfirmationState extends State<pickupConfirmation> {

  int? userId;
  int? itemId;

  List<Confirmation> confirmationData = []; // List to store confirmatin Data
  List<Confirmation> filteredConfirmationData = []; // Copy of confirmationData list

  @override
  void initState(){
    super.initState();
    fetchConfirmationData();
  }

  Future<void> fetchConfirmationData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('user_id');
    //itemId = prefs.getInt('item_id');

    if(userId != null ) {
      final response = await http.get(Uri.parse(
          'http://192.168.0.119/confirmation.php?user_id=$userId&item_id=$itemId'));

      print('Raw JSON response: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);

        setState(() {
          confirmationData = (jsonData as List).map((item) => Confirmation.fromJson(item)).toList();
          filteredConfirmationData = List.from(confirmationData); // Copy confirmationData into filteredConfirmationData
          //confirmationData = json.decode(response.body);
        });
      } else {
        throw Exception(
            'Failed to load data.Status code ${response.statusCode}');
      }
    }else {
      print('User ID or Item ID not found in SharedPreferences');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(5, 15, 0, 0),

              child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                ),
                ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 65.0, 16.0, 0),
                child: Text(
                  'Confirmation',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 50),
            ],
          ),
          Container(
            height: 900, // Set the initial container height as needed
            decoration: BoxDecoration(
              color: Colors.white,
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.only(topLeft: Radius.circular(70), topRight: Radius.circular(70),
                ),
              ),
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Expanded(
                      child: ListView.builder(
                          itemCount: filteredConfirmationData.length,
                           itemBuilder: (context, index){
                            return ListTile(
                              leading: Text(filteredConfirmationData[index].status),
                            );
                          },
                      ),
                      ),

                  Align(
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
                          child: Text('Cancel',
                            style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(width: 60),
                        ElevatedButton(
                          onPressed: (){

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
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Container(
          //   height: 95,
          //   padding: EdgeInsets.all(16),
          //   child: Align(
          //     alignment: Alignment.bottomCenter,
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         ElevatedButton(onPressed: (){
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
          //           child: Text('Cancel',
          //             style: TextStyle(
          //               fontSize: 16, fontWeight: FontWeight.bold,
          //             ),
          //           ),
          //         ),
          //         SizedBox(width: 40),
          //         ElevatedButton(
          //           onPressed: (){
          //
          //           },
          //           style: ElevatedButton.styleFrom(
          //             fixedSize: Size(200, 50),
          //             shape: RoundedRectangleBorder(
          //               borderRadius: BorderRadius.circular(100),
          //             ),
          //             elevation: 9,
          //             padding: EdgeInsets.symmetric(
          //                 vertical: 10, horizontal: 30),
          //           ),
          //           child: Text('Pick Up',
          //             style: TextStyle(
          //               fontSize: 16, fontWeight: FontWeight.bold,
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}


