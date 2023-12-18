import 'package:flutter/material.dart';
import 'package:jom_pick/PickUpLocationMap.dart';
import 'HomeScreen.dart';
import 'models/pickup_location_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'main.dart';
import 'package:url_launcher/url_launcher.dart';

// void main() {
//   runApp(MyLocationList());
// }
//
// class MyLocationList extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Your App Title',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: pickupLocation(),
//     );
//   }
// }
//

class pickupLocation extends StatefulWidget {
  const pickupLocation({Key? key}) : super(key: key);

  @override
  _pickupLocation createState() => _pickupLocation();
}

class _pickupLocation extends State<pickupLocation> {

  int? userId;
  late String destinationAddress  ;

  List<pickupLocationList> itemData = []; // List to store fetched data
  List<pickupLocationList> filteredItemData = []; // List to store filtered data

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchItemData(); // Fetch user data when the widget is created
  }

  // Fetch user data based on the user ID stored in SharedPreferences
  Future<void> fetchItemData() async {
    try {
      final response = await http.get(
        Uri.parse('http://${MyApp.baseIpAddress}${MyApp.pickupLocationPath}'),
      );

      print('Raw JSON response: ${response.body}');

      if (response.statusCode == 200) {
        try {
          final List<dynamic> jsonData = json.decode(response.body);

          setState(() {
            itemData = (jsonData as List).map((item) => pickupLocationList.fromJson(item)).toList();
            filteredItemData = List.from(itemData);
          });
        } catch (e) {
          print('Error parsing JSON: $e');
          setState(() {
            itemData = [];
            filteredItemData = [];
          });
        }
      } else {
        throw Exception('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching data: $e');
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
                margin: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 16.0),
                elevation: 4.0, // Set the elevation (shadow) here
                child: SizedBox(
                  width: double.infinity,
                  height: 130.0 ,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 15.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        SizedBox(height: 10),
                        ListTile(
                          contentPadding: EdgeInsets.all(0),
                          // Remove default ListTile padding
                          leading: Container(
                            width: 190.0,
                            height: 250.0,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.memory(
                                filteredItemData[index].imageData ?? Uint8List(0),
                                width: double.infinity,
                                height: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                filteredItemData[index].address,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                          // subtitle: Text(
                          //   filteredItemData[index].location,
                          //   style: TextStyle(
                          //     fontSize: 14,
                          //   ),
                          // ),
                          // trailing: Container(
                          //   width: 90,
                          //   height: 25,
                          //   decoration: BoxDecoration(
                          //     color: Colors.red,
                          //   ),
                          //   alignment: Alignment.center,
                          //   child: Row(
                          //     mainAxisSize: MainAxisSize.min,
                          //     children: [
                          //       Icon(
                          //         Icons.error,
                          //         color: Colors.white,
                          //         size: 16,
                          //       ),
                          //       SizedBox(width: 4),
                          //       Text(
                          //         'Pending',
                          //         style: TextStyle(
                          //           color: Colors.white,
                          //           fontSize: 12,
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child:  ElevatedButton(
                            onPressed: (){
                              _launchGoogleMaps(filteredItemData[index].address);
                            },
                            style: ElevatedButton.styleFrom(
                              fixedSize: Size(340, 45),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                              minimumSize: Size(150, 45), // set width and height
                            ),
                            child: Text('View Location',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }


  void _launchGoogleMaps(String destinationAddress) async {
    // Construct the Google Maps URL with the destination address
    final url = 'https://www.google.com/maps/dir/?api=1&destination=$destinationAddress';

    // Launch the URL
    try {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        print('Could not launch Google Maps');
      }
    } catch (e) {
      print('Error launching Google Maps: $e');
    }
  }

  // Update the filterItems method to filter itemData only when the search bar has a value
  void filterItems(String query) {
    if (query.isNotEmpty) {
      setState(() {
        filteredItemData = itemData
            .where((item) => item.address.toLowerCase().contains(query.toLowerCase()))
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
              //mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () {
                      // Navigate to the home page and replace the current page
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    },
                  ),
                ),
                Spacer(),
                Text(
                  'Pickup Store',
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
          _buildListView(), // Use the custom ListView
        ],
      ),

    );
  }
}