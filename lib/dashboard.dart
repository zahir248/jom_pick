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
import 'item_detail.dart';
import 'dart:typed_data';

class DashBoard extends StatefulWidget {
  const DashBoard({Key? key}) : super(key: key);

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  int _selectedIndex = 0; // Index of the selected tab
  int? userId;

  List<Item> itemData = []; // List to store fetched data
  List<Item> filteredItemData = []; // List to store filtered data

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchItemData(); // Fetch user data when the widget is created
  }

  // Fetch user data based on the user ID stored in SharedPreferences
  Future<void> fetchItemData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('user_id');

    if (userId != null) {
      final response = await http.get(Uri.parse('http://192.168.0.113/itemHome.php?user_id=$userId'));

      print('Raw JSON response: ${response.body}');

      if (response.statusCode == 200) {
        try {
          // Attempt to decode the response body as JSON
          final List<dynamic> jsonData = json.decode(response.body);

          setState(() {
            itemData = (jsonData as List).map((item) => Item.fromJson(item)).toList();
            itemData.sort((a, b) => b.registerDate!.compareTo(a.registerDate!)); // Reverse order based on registerDate
            filteredItemData = List.from(itemData); // Initialize filteredItemData
          });
        } catch (e) {
          print('Server responded with "0 results". User has no item data.');
          setState(() {
            itemData = []; // Set itemData to an empty list
            filteredItemData = []; // Set filteredItemData to an empty list
          });
        }
      } else {
        throw Exception('Failed to load user data. Status code: ${response.statusCode}');
      }
    } else {
      print('User ID not found in SharedPreferences');
    }
  }


  Widget _buildListView() {
    return Expanded(
      child: filteredItemData.isEmpty
          ? Center(
        child: Text(
          'No data available',
          style: TextStyle(fontSize: 16.0),
        ),
      )
          : Center(
        child: Scrollbar(
          child: ListView.builder(
            itemCount: filteredItemData.length,
            itemBuilder: (context, index) {
              return Card(
                margin: EdgeInsets.all(8.0),
                elevation: 4.0, // Set the elevation (shadow) here
                child: Padding(
                  padding: EdgeInsets.only(bottom: 15.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        contentPadding: EdgeInsets.all(0), // Remove default ListTile padding
                        leading: Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: AssetImage('assets/jompick.jpg'), // adjust the path accordingly
                            ),
                          ),
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              filteredItemData[index].itemName,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                        subtitle: Text(
                          filteredItemData[index].location,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        trailing: Container(
                          width: 90,
                          height: 25,
                          decoration: BoxDecoration(
                            color: Colors.red,
                          ),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.error,
                                color: Colors.white,
                                size: 16,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Pending',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
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
                            Icon(Icons.calendar_today),
                            SizedBox(width: 8),
                            Text(
                              filteredItemData[index].registerDate != null
                                  ? DateFormat('EEEE, dd MMMM yyyy').format(filteredItemData[index].registerDate!)
                                  : "N/A",
                              style: TextStyle(fontSize: 14),
                            ),
                            SizedBox(width: 46),
                            Icon(Icons.access_time),
                            SizedBox(width: 4),
                            Text(
                              filteredItemData[index].registerDate != null
                                  ? DateFormat('h:mm a').format(filteredItemData[index].registerDate!)
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
                              _detailsItem(
                                filteredItemData[index].itemId,
                                filteredItemData[index].itemName,
                                filteredItemData[index].trackingNumber,
                                filteredItemData[index].itemType,
                                filteredItemData[index].imageData,
                                filteredItemData[index].status,
                                filteredItemData[index].confirmationDate,
                              );
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

  void _detailsItem(int itemId, String itemName, String trackingNumber, String itemType, Uint8List imageData, String status, DateTime confirmationDate) {
    // Navigate to the item detail page and pass the item_id
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemDetailPage(
            itemId: itemId,
            itemName: itemName,
            trackingNumber : trackingNumber,
            itemType : itemType,
            imageData: imageData,
            status: status,
            confirmationDate: confirmationDate,
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

  // Update the filterItems method to filter itemData only when the search bar has a value
  void filterItems(String query) {
    if (query.isNotEmpty) {
      setState(() {
        filteredItemData = itemData
            .where((item) => item.itemName.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    } else {
      setState(() {
        filteredItemData = List.from(itemData);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 50.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'JomPick',
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.settings),
                  onPressed: () {
                    handleSetting(); // Logout when the button is pressed
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: filterItems,
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.white24, // Set the background color to grey
                contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0), // Adjust the padding as needed
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