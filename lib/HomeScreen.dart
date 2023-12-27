import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jom_pick/DashBoard.dart';
import 'package:jom_pick/history.dart';
import 'package:jom_pick/models/item.dart';
import 'package:jom_pick/penalty.dart';
import 'package:jom_pick/pickup_location.dart';
import 'package:jom_pick/profile.dart';
import 'package:jom_pick/setting.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'PickUpLocationMap.dart';
import 'main.dart';
import 'models/latestRegisteredItem.dart';
import 'models/notification_model.dart';
import 'models/user.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {

  int? userId;
  int _selectedIndex = 0;

  List<latestRegisteredItem> itemData = [];
  List<latestRegisteredItem> filteredItemData =[];
  List<User> userData = [];

  @override
  void initState() {
    super.initState();
    fetchItemData();
    fetchUserData();
  }

  Future<void> fetchItemData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('user_id');

    if (userId != null) {

      final response = await http.get(Uri.parse('http://${MyApp.baseIpAddress}${MyApp.latestRegisteredItem}?user_id=$userId'));
      print('Raw JSON response: ${response.body}');

      if (response.statusCode == 200) {

        final List<dynamic> jsonData = json.decode(response.body);

        setState(() {
          itemData = (jsonData as List).map((item) => latestRegisteredItem.fromJson(item)).toList();
          //filteredItemData = List.from(itemData); // Initialize filteredItemData

        });
      } else {
        throw Exception('Failed to load user data. Status code: ${response.statusCode}');
      }
    } else {
      print('User ID not found in SharedPreferences');
    }
  }


  Future<void> fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('user_id');

    if (userId != null) {

      final response = await http.get(Uri.parse('http://${MyApp.baseIpAddress}${MyApp.user}?user_id=$userId'));
      print('Raw JSON response: ${response.body}');

      if (response.statusCode == 200) {

        final List<dynamic> jsonData = json.decode(response.body);

        setState(() {
          userData = (jsonData as List).map((item) => User.fromJson(item)).toList();
          //filteredItemData = List.from(itemData); // Initialize filteredItemData

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
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color.fromRGBO(244, 243, 243, 1),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height*0.3,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        Colors.blue.shade100,
                        Colors.blue.shade200,
                        Colors.blue.shade300,
                        Colors.blue.shade400,
                      ]
                  ),
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(40)),
                ),
                //padding: EdgeInsets.all(20.0),
                child: Stack(
                  children: <Widget>[
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.vertical(bottom: Radius.circular(40.0)), // Adjust the radius as needed
                          child: Image.asset(
                            'assets/jompick_homepage.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.blue, // Optional: Set the background color of the circle
                                ),
                                child: ClipOval(
                                  child: Image.memory(
                                    userData.isNotEmpty && userData[0].image != null
                                          ? userData[0].image!
                                    :Uint8List(0),
                                    //'assets/jompick.jpg', 
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            SizedBox(height: 10),// Adjust the spacing between the image and text
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Text(
                                    'Hi ${userData.isNotEmpty ? userData[0].userName : ''}',
                                    style: TextStyle(
                                      fontFamily: 'Monoton',
                                        color: Colors.black87,
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Manage your item here',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                          ],
                        ),
                        SizedBox(height: 60),
                        // Container(
                        //   padding: EdgeInsets.all(5),
                        //   decoration: BoxDecoration(
                        //     color: Color.fromRGBO(244, 243, 243, 1),
                        //     borderRadius: BorderRadius.circular(15),
                        //   ),
                        //   child: TextField(
                        //     decoration: InputDecoration(
                        //       border: InputBorder.none,
                        //       prefixIcon: Icon(
                        //         Icons.search,
                        //         color: Colors.black87,
                        //       ),
                        //       hintText: "Search you're looking for",
                        //       hintStyle: TextStyle(color: Colors.grey, fontSize: 15),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(height: 5),
                    Text('Activities : ',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: 220,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: <Widget>[
                          promoCard1(context, 'assets/parcel_icon.jpg'),
                          promoCard2(context, 'assets/map_icon2.jpg'),
                        ],
                      ),
                    ),
                    SizedBox(height: 25),

                    Text('Latest Update : ',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      // decoration: BoxDecoration(
                      //   color: Colors.blue[100],
                      //   borderRadius: BorderRadius.circular(20),
                      // ),
                      child: itemData.isNotEmpty
                          ? Card(
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        color: Colors.blue[100],
                        child: ListTile(
                          title: RichText(
                            text: TextSpan(
                              text: itemData[0].itemName,
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                height: 1.5,
                              ),
                              // children: [
                              //   TextSpan(
                              //     text: '\n',
                              //   ),
                              // ],
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: getStatusColor(itemData[0].status),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  itemData[0].status,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(
                                itemData[0].registerDate != null
                                    ? "\n Arrived on ${DateFormat('EEEE, dd MMMM yyyy').format(itemData[0].registerDate!)} \n"
                                    : "N/A",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  //fontStyle: FontStyle.italic,
                                  //color: Colors.grey.shade800,
                                ),
                              ),
                              Text(
                                itemData[0].confirmationDate != null
                                    ? " Due on ${DateFormat('EEEE, dd MMMM yyyy').format(itemData[0].confirmationDate!)} \n"
                                    : "N/A",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  //fontStyle: FontStyle.italic,
                                  //color: Colors.grey.shade800,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                          : Container(),
                      height: 140,
                    ),


                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.error),
            label: 'Penalty',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Setting',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }


  MaterialColor getStatusColor(String status){
    if(status == 'Picked'){
      return Colors.green;
    }else if(status == 'Pending'){
      return Colors.yellow;
    }else if(status == 'Disposed'){
      return Colors.red;
    }else{
      return Colors.grey;
    }
  }

  void _onItemTapped(int index) {
    if (index == 4) {
      // If the "Profile" button is tapped (index 2), navigate to the profile page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Profile(),
        ),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Penalty(),
        ),
      );
    } else if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => History(),
        ),
      );
    }else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Setting(),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  Widget promoCard1(BuildContext context, String image) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: () {
        // Navigate to the new screen when the promoCard is tapped
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DashBoard(),
          ),
        );
      },
      child: AspectRatio(
        aspectRatio: 2.62 / 3,
        child: Container(
          //height: screenHeight,
          width: screenWidth *0.8,
          margin: EdgeInsets.only(right: screenWidth*0.02),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(screenWidth*0.04),
            image: DecorationImage(fit: BoxFit.cover, image: AssetImage(image)),
          ),
          child: Container(
            padding: EdgeInsets.all(screenWidth*0.03), // Add padding to create space for text
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(screenWidth*0.04),
                bottomRight: Radius.circular(screenWidth*0.04),
              ),
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withOpacity(0.4),
                  Colors.transparent,
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Items', // Add your text here
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget promoCard2(BuildContext context, String image) {

    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        // Navigate to the new screen when the promoCard is tapped
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => pickupLocation(),
          ),
        );
      },
      child: AspectRatio(
        aspectRatio: 2.62 / 3,
        child: Container(
          width: screenWidth,
          height: screenHeight,
          margin: EdgeInsets.only(right: 15.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(fit: BoxFit.cover, image: AssetImage(image)),
          ),
          child: Container(
            padding: EdgeInsets.all(16), // Add padding to create space for text
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withOpacity(0.4),
                  Colors.transparent,
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'PickUp Store', // Add your text here
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}

