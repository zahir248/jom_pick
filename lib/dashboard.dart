import 'package:flutter/material.dart';
import 'setting.dart';
import 'profile.dart';
import 'penalty.dart';
import 'history.dart';
import '../models/item.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart'; // Import the intl package

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  int _selectedIndex = 0; // Index of the selected tab
  int? userId;

  List<Item> itemData = []; // List to store fetched data

  @override
  void initState() {
    super.initState();
    fetchItemData(); // Fetch user data when the widget is created
  }

  // Fetch user data based on the user ID stored in SharedPreferences
  // Fetch user data based on the user ID stored in SharedPreferences
  Future<void> fetchItemData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('user_id');

    if (userId != null) {
      final response = await http.get(Uri.parse('http://10.200.90.242/item.php?user_id=$userId'));

      print('Raw JSON response: ${response.body}');


      if (response.statusCode == 200) {

        final List<dynamic> jsonData = json.decode(response.body);

        setState(() {
          itemData = (jsonData as List).map((item) => Item.fromJson(item)).toList();
        });
      } else {
        throw Exception('Failed to load user data. Status code: ${response.statusCode}');
      }
    } else {
      print('User ID not found in SharedPreferences');
    }
  }

  Widget _buildListView() {
    return Expanded(
      child: itemData.isEmpty
          ? Center(
        child: Text(
          'No data available',
          style: TextStyle(fontSize: 16.0),
        ),
      )
          : Center(
        child: Scrollbar(
          child: ListView.builder(
            itemCount: itemData.length,
            itemBuilder: (context, index) {
              return Card(
                margin: EdgeInsets.all(8.0),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 15.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.blue, // Change the color to blue or any other color you prefer
                          ),
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              itemData[index].itemName,
                              style: TextStyle(
                                fontSize: 18, // Adjust the font size as needed for itemName
                                fontWeight: FontWeight.bold, // Make itemName bold
                              ),
                            ),
                            SizedBox(height: 10), // Adjust the height for the desired space
                          ],
                        ),
                        subtitle: Text(
                          itemData[index].location,
                          style: TextStyle(
                            fontSize: 14, // Adjust the font size as needed for location
                          ),
                        ),
                      ),
                      Divider(
                        height: 20.0,
                        thickness: 1.0,
                        color: Colors.grey.withOpacity(0.5),
                        indent: 15.0,
                        endIndent: 15.0,
                      ),
                      ListTile(
                        leading: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.calendar_today), // Add the calendar icon
                            SizedBox(width: 8), // Adjust the width for spacing
                            Text(
                              // Format the date using the intl package
                              itemData[index].registerDate != null
                                  ? DateFormat('EEEE, dd MMMM yyyy').format(itemData[index].registerDate!)
                                  : "N/A",
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ElevatedButton(
                            onPressed: () {
                              //_detailsUser(index);
                            },
                            style: ElevatedButton.styleFrom(
                              fixedSize: Size(340, 45),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                            child: Text('Details', style: TextStyle(fontSize: 16)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }


  void handleSetting() async {

    // Navigate to the login page (Assuming your login page is named Setting)
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Setting()));
  }

  void _onItemTapped(int index) {
    if (index == 3) {
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
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DashBoard(),
        ),
      );
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('JomPick'),
        automaticallyImplyLeading: false, // Remove the back button
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              handleSetting(); // Logout when the button is pressed
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.white10, // Set the background color to grey
                border: OutlineInputBorder( // Use OutlineInputBorder for border
                  borderSide: BorderSide(color: Colors.white12), // Set the border color to grey
                  borderRadius: BorderRadius.circular(10.0), // Adjust the border radius as needed
                ),
              ),
            ),
          ),
          _buildListView(), // Use the custom ListView
        ],
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
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
