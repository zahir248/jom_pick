import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:jom_pick/HomeScreen.dart';
import 'package:jom_pick/penalty_details.dart';
import 'package:jom_pick/setting.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/penalty_details_model.dart';
import 'history.dart';
import 'package:http/http.dart' as http;
import 'main.dart';


class Penalty extends StatefulWidget {
  const Penalty({Key? key}) : super(key: key);

  @override
  _PenaltyState createState() => _PenaltyState();
}

class _PenaltyState extends State<Penalty> {
  int? userId;  // Check if userId have value or null
  String? jomPickId;
  int _selectedIndex = 2; // Index of the selected tab
  bool isLoading = true;

  List<PenaltyDetails> itemData = [];
  List<PenaltyDetails> filteredItemData = [];

  final List<String> categories = [
    'Paid',
    'Unpaid'
  ];

  List<String> selectedCategories =[];

  TextEditingController searchController = TextEditingController();

  // Ensure that data fetching process start as soon as the widget is created
  @override
  void initState(){
    super.initState();
    fetchItemData();
  }

  Future<void> fetchItemData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //userId = prefs.getInt('user_id');
    jomPickId =  prefs.getString('JomPick_ID');

    if (jomPickId != null) {
      try {
        final response = await http.get(
          Uri.parse('http://${MyApp.baseIpAddress}${MyApp.itemPenaltyPath}?JomPick_ID=\'${jomPickId}\''),
        );

        print('Raw JSON response: ${response.body}');

        if (response.statusCode == 200) {
          try {
            final List<dynamic> jsonData = json.decode(response.body);

            setState(() {
              itemData = (jsonData as List).map((item) => PenaltyDetails.fromJson(item)).toList();
              itemData.sort((a, b) => b.registerDate!.compareTo(a.registerDate!));
              filteredItemData = List.from(itemData);
              isLoading = false;
            });
          } catch (e) {
            print('Server responded with "0 results". User has no item data.');
            setState(() {
              itemData = [];
              filteredItemData = [];
            });
          }
        } else {
          throw Exception('Failed to load user data. Status code: ${response.statusCode}');
        }
      } catch (e) {
        print('Error fetching data from the server: $e');
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

    final filterCategory = filteredItemData.where((PenaltyDetails) {
      return selectedCategories.isEmpty ||
          selectedCategories.contains(PenaltyDetails.paymentStatus);
    }).toList();

    // final filterCategory = filteredItemData.where((PenaltyDetails) {
    //   return (selectedCategories.isEmpty ||
    //       selectedCategories.contains(PenaltyDetails.paymentStatus)) &&
    //   !(PenaltyDetails.confirmationStatus == 'Disposed');
    // }).toList();


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
                          'Arrived at ${filterCategory[index].pickUpLocationName}',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        trailing: Container(
                          width: 90,
                          height: 25,
                          decoration: BoxDecoration(
                            color: getStatusColor(filterCategory[index].paymentStatus),
                          ),
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SizedBox(width: 4),
                              Text(
                                filterCategory[index].paymentStatus,
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
                              _detailsPenaltyItem(
                                  filterCategory[index].itemId,
                                  filterCategory[index].itemName,
                                  filterCategory[index].itemType,
                                  filterCategory[index].confirmationStatus,
                                  filterCategory[index].trackingNumber,
                                  filterCategory[index].dueDateStatus,
                                  filterCategory[index].paymentStatus,
                                  filterCategory[index].paymentAmount,
                                  filterCategory[index].pickUpLocation,
                                  filterCategory[index].dueDate,
                                  filterCategory[index].imageData
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

  // void handleSetting() async {
  //   // Navigate to the login page (Assuming your login page is named Setting)
  //   Navigator.pushReplacement(
  //       context, MaterialPageRoute(builder: (context) => Setting()));
  // }

  // void _detailsItem(int itemId, String itemName, String trackingNumber, String itemType, Uint8List imageData, String status, DateTime confirmationDate) {
  //   // Navigate to the item detail page and pass the item_id
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => ItemDetailPenaltyPage(
  //         itemId: itemId,
  //         itemName: itemName,
  //         trackingNumber : trackingNumber,
  //         itemType : itemType,
  //         imageData: imageData,
  //         status: status,
  //         confirmationDate: confirmationDate,
  //       ),
  //     ),
  //   );
  // }

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
    if(status == 'Paid'){
      return Colors.green;
    }else if(status == 'Unpaid'){
      return Colors.red;
    }else{
      return Colors.grey;
    }
  }


  void _detailsPenaltyItem(
      int itemId,
      String itemName,
      String itemType,
      String confirmationStatus,
      String trackingNumber,
      String dueDateStatus,
      String paymentStatus,
      String paymentAmount,
      String pickUpLocation,
      DateTime dueDate,
      Uint8List imageData
      ){

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context)=> penaltyDetailPage(
          itemId: itemId,
          itemName: itemName,
          itemType: itemType,
          confirmationStatus: confirmationStatus,
          trackingNumber : trackingNumber,
          dueDateStatus: dueDateStatus,
          paymentStatus: paymentStatus,
          paymentAmount: paymentAmount,
          pickUpLocation: pickUpLocation,
          dueDate : dueDate,
          imageData: imageData,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final filterCategory = filteredItemData.where((categories) {
    //   return selectedCategories.isEmpty || selectedCategories.contains(categories.itemType);
    // }).toList();
    return Scaffold(
      appBar: null,
      body: Stack(
        children:[
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 50.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Penalty',
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
              // Create filter button to filter the item category
              Container(
                padding: const EdgeInsets.all(1.0),
                margin: const EdgeInsets.all(1.0),
                child: Row(
                  children: categories.map(
                        (paymentStatus) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FilterChip(
                          selected: selectedCategories.contains(paymentStatus),
                          label: Text(paymentStatus),
                          onSelected: (selected){
                            setState(() {
                              if(selected){
                                selectedCategories.add(paymentStatus);
                              }else{
                                selectedCategories.remove(paymentStatus);
                              }
                            });
                          }),
                    ),
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
        ]
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



