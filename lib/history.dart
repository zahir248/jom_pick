import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:jom_pick/setting.dart';
import 'dashboard.dart';
import 'models/item.dart';
import 'profile.dart';
import 'penalty.dart';
import '../models/item.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart'; // Import the intl package
import 'item_detail_history.dart';
import 'dart:typed_data';

import 'main.dart';


import 'package:jom_pick/HomeScreen.dart';


class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  int _selectedIndex = 1; // Index of the selected tab
  int? userId;
  String? jomPickId;
  bool isLoading = true;

  List<Item> itemData = []; // List to store fetched data
  List<Item> filteredItemData = []; // List to store filtered data

  final List<String> categories = [
    'Picked',
    'Disposed'
  ];
  final List<String> selectedCategories = [];

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchItemData(); // Fetch user data when the widget is created
  }

  // Fetch user data based on the user ID stored in SharedPreferences
  Future<void> fetchItemData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //userId = prefs.getInt('user_id');
    jomPickId = prefs.getString('JomPick_ID');

    if (jomPickId != null) {
      try {
        final response = await http.get(
          Uri.parse('http://${MyApp.baseIpAddress}${MyApp.itemHistoryPath}?JomPick_ID=\'${jomPickId}\''),
        );

        print('Raw JSON response: ${response.body}');

        if (response.statusCode == 200) {
          final String responseBody = response.body.trim();

          if (responseBody.isNotEmpty) {
            if (responseBody != '0 results') {
              final List<dynamic> jsonData = json.decode(responseBody);

              setState(() {
                itemData = (jsonData as List).map((item) => Item.fromJson(item)).toList();
                itemData.sort((a, b) => b.registerDate!.compareTo(a.registerDate!));
                filteredItemData = List.from(itemData);
                isLoading = false;
              });
            } else {
              print('Server responded with "0 results". User has no item data.');
              setState(() {
                itemData = [];
                filteredItemData = [];
              });
            }
          } else {
            print('Empty response body');
            setState(() {
              itemData = [];
              filteredItemData = [];
            });
          }
        } else {
          throw Exception('Failed to load user data. Status code: ${response.statusCode}');
        }
      } catch (e) {
        print('Error fetching item data: $e');
        setState(() {
          isLoading = false;
        });
      }
    } else {
      print('User ID not found in SharedPreferences');
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildListView() {

    final filterCategory = filteredItemData.where((Item) {
      return selectedCategories.isEmpty ||
          selectedCategories.contains(Item.status);
    }).toList();


    return isLoading
        ? Center(
      child: SpinKitChasingDots(
        itemBuilder: (BuildContext context, int index) {
          return DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: index.isEven ? Colors.blue : Colors.grey,
            ),
          );
        },
      ),
    )

     : filterCategory.isEmpty
          ? Center(
        child: Text(
          'No data available',
          style: TextStyle(fontSize: 16.0),
        ),
      )
          : Center(
        child: Scrollbar(
          child: ListView.builder(
            //itemCount: filteredItemData.length,
            itemCount: filterCategory.length,
            itemBuilder: (context, index) {
              //final category = filterCategory[index];

              print('Filtered items count: ${filterCategory.length}');

              //print("Payment Status adaaaaa: ${filteredItemData[index].paymentStatus}");

              return Card(
                margin: EdgeInsets.all(8.0),
                elevation: 4.0, // Set the elevation (shadow) here
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
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              //image: AssetImage('assets/jompick.jpg'), // adjust the path accordingly
                              image: MemoryImage(
                                  filterCategory[index].imageData
                              ),
                            ),
                          ),
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    filterCategory[index].itemName, // Use filteredItemData instead of itemData
                                    // Avoid text from exceed the status container
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8), // Adjust the spacing between item name and status
                              ],
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                        subtitle: Text(
                          'Picked at ${filterCategory[index].pickUpLocation}',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        trailing: Container(
                          width: 90,
                          height: 25,
                          decoration: BoxDecoration(
                            color: getStatusColor(filterCategory[index].status),
                          ),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(width: 4),
                              Text(
                                filterCategory[index].status,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
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
                              filterCategory[index].registerDate != null
                                  ? DateFormat('EEEE, dd MMMM yyyy').format(filterCategory[index].registerDate!)
                                  : "N/A",
                              style: TextStyle(fontSize: 14),
                            ),
                            SizedBox(width: 46),
                            Icon(Icons.access_time),
                            SizedBox(width: 4),
                            Text(
                              filterCategory[index].registerDate != null
                                  ? DateFormat('h:mm a').format(filterCategory[index].registerDate!)
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
                                filterCategory[index].itemId,
                                filterCategory[index].itemName,
                                filterCategory[index].trackingNumber,
                                filterCategory[index].itemType,
                                filterCategory[index].imageData,
                                filterCategory[index].status,
                                filterCategory[index].dueDate,
                                filterCategory[index].imageProofData,
                                filterCategory[index].pickUpDate,
                                filterCategory[index].address,
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
      );

  }

  void _detailsItem(int itemId, String itemName, String trackingNumber, String itemType, Uint8List imageData, String status, DateTime dueDate, Uint8List imageProofData, DateTime pickUpDate, String address, ) {
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
          dueDate: dueDate,
          imageProofData: imageProofData,
          pickUpDate : pickUpDate,
          address : address,
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    if (index == 2) {
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
    } else if (index == 3) {
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

  MaterialColor getStatusColor(String status){
    if(status == 'Picked'){
      return Colors.green;
    }else if(status == 'Disposed'){
      return Colors.red;
    }else{
      return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Stack(
        children:[
         Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 50.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'History',
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                    ),
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

            Container(
              padding: const EdgeInsets.all(1.0),
              margin: const EdgeInsets.all(1.0),
              child: Row(
                children: categories.map(
                        (status) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FilterChip(
                          selected: selectedCategories.contains(status),
                          label: Text(status),
                          onSelected: (selected){
                            setState(() {
                              if(selected){
                                selectedCategories.add(status);
                              }else{
                                selectedCategories.remove(status);
                              }
                            });
                          }),
                    )
                ).toList(),
              ),
            ),
            Expanded(
              child: _buildListView(),
            ),
          ],
         ),
          if (isLoading)
            Positioned.fill(
              child: Container(
                child: Center(
                  // child: SpinKitThreeInOut(
                  //   itemBuilder: (BuildContext context, int index) {
                  //     return DecoratedBox(
                  //       decoration: BoxDecoration(
                  //         shape: BoxShape.circle,
                  //         color: index.isEven ? Colors.blue : Colors.grey,
                  //       ),
                  //     );
                  //   },
                  // ),
                ),
              ),
            ),
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
            icon: Icon(Icons.settings),
            label: 'Setting',
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.person),
          //   label: 'Profile',
          // ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}






