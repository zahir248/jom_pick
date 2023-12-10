import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:jom_pick/main.dart';

import 'dashboard.dart';
import 'package:flutter/material.dart';
import 'package:jom_pick/models/notification_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class userNotification extends StatefulWidget {
  const userNotification({super.key});

  @override
  State<userNotification> createState() => _notificationState();
}

class _notificationState extends State<userNotification> {

  int? userId;

  List<SendNotification> itemData = [];
  List<SendNotification> filteredItemData =[];

  @override
  void initState() {
    super.initState();
    fetchItemData();
  }

  Future<void> fetchItemData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('user_id');

    if (userId != null) {

      final response = await http.get(Uri.parse('http://${MyApp.baseIpAddress}${MyApp.notification}?user_id=$userId'));
      print('Raw JSON response: ${response.body}');

      if (response.statusCode == 200) {

        final List<dynamic> jsonData = json.decode(response.body);

        setState(() {
          itemData = (jsonData as List).map((item) => SendNotification.fromJson(item)).toList();
          filteredItemData = List.from(itemData); // Initialize filteredItemData

        });
      } else {
        throw Exception('Failed to load user data. Status code: ${response.statusCode}');
      }
    } else {
      print('User ID not found in SharedPreferences');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(left: 16,right: 16, top: 50),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        'Detail',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 50),
                  ],
                ),
                Text(
                  'Notification',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filteredItemData.length,  // to ensure ListViee.builder know the number of item it need to build
                itemBuilder: (context, index) {
                  return  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)
                    ),
                    color: Colors.lightBlueAccent,
                    child: ListTile(
                      title: RichText(
                        text: TextSpan(
                          text: filteredItemData[index].itemName,
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            height: 1.5,
                          ),
                          children: [
                            TextSpan(
                              text: '\n${filteredItemData[index].pickUpLocation}',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.normal, // Adjusted the fontWeight
                                fontSize: 15,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          filteredItemData[index].registerDate != null
                              ? " Arrived on ${DateFormat('EEEE, dd MMMM yyyy').format(filteredItemData[index].registerDate!)} \n"
                              "Pick up before ${filteredItemData[index].dueDate!}"
                              : "N/A",
                          style: TextStyle(
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      ),
                      trailing: IconButton(
                        onPressed: (){},
                        icon: const Icon(
                            Icons.delete
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

