import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'main.dart';
import 'qr_code.dart';
import 'package:intl/intl.dart';


class PickupDetailPage extends StatefulWidget {
  final String address;
  final int itemId;
  final DateTime dueDate;
  final DateTime pickUpDate;
  final String itemName;
  final String fullName;
  final String pickupType;
  final int confirmationId;
  final String status;

  // In the constructor, require the address property.

  PickupDetailPage({
    Key? key,
    required this.address,
    required this.itemId,
    required this.dueDate,
    required this.pickUpDate,
    required this.itemName,
    required this.fullName,
    required this.pickupType,
    required this.confirmationId,
    required this.status,
  }) : super(key: key);

  @override
  _PickupDetailPageState createState() => _PickupDetailPageState();
}

class _PickupDetailPageState extends State<PickupDetailPage> {

  String userLocation = 'Fetching...';
  late Position currentPosition;
  Future<Map<String, String>>? durationFuture;


  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _refresh() async {
    // Fetch user location and durations again
    await _getUserLocation();
    await _calculateDurations();
  }

  String formattedUserLocation = '';


  Future<void> _getUserLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Reverse geocoding
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      setState(() {
        currentPosition = position;

        if (placemarks.isNotEmpty) {
          Placemark firstPlacemark = placemarks[0];

          // Construct the address format
          userLocation = '${firstPlacemark.name ?? ''}, '
              '${firstPlacemark.postalCode ?? ''} ${firstPlacemark.locality ?? ''}, '
              '${firstPlacemark.administrativeArea ?? ''}';

          // Store the formatted address
          formattedUserLocation = '${firstPlacemark.locality ?? ''}, '
              '${firstPlacemark.postalCode ?? ''} ${firstPlacemark.locality ?? ''}, '
              '${firstPlacemark.administrativeArea ?? ''}';

          print('User Location: $userLocation');
          //print('Formatted User Location: $formattedUserLocation');

        } else {
          userLocation = 'Unknown Location';
          formattedUserLocation = 'Unknown Location';
        }

        _calculateDurations();
      });
    } catch (e) {
      print('Error getting user location: $e');
      setState(() {
        userLocation = 'Error fetching location';
        formattedUserLocation = 'Error fetching location';
      });
    }
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

  // void _launchGoogleMaps() async {
  //   final url =
  //       'https://www.google.com/maps/search/?api=1&query=${widget.address}';
  //
  //   if (await canLaunch(url)) {
  //     await launch(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  Future<Map<String, String>> _getDurations() async {
    try {
      if (currentPosition == null) {
        throw 'Current position is null';
      }

      String apiKey =
          'AIzaSyBgod1ukFHd2DOAwVNedNvKWxCdQoQXvww'; // Replace with your actual API key
      String destination = widget.address;

      print('adaaaaaa ${widget.address}');

      Map<String, String> durations = {};

      // Fetch driving duration
      String drivingUrl =
          'https://maps.googleapis.com/maps/api/directions/json?'
          'origin=${currentPosition.latitude},${currentPosition.longitude}&'
          'destination=$destination&mode=driving&key=$apiKey';

      print('Driving URL: $drivingUrl');

      // Fetch two-wheeler duration
      String twoWheelerUrl =
          'https://maps.googleapis.com/maps/api/directions/json?'
          'origin=${currentPosition.latitude},${currentPosition.longitude}&'
          'destination=$destination&mode=motorcycle&key=$apiKey';
      durations['Two-wheeler'] = await _fetchDuration(twoWheelerUrl);

      // Fetch transit duration
      String transitUrl =
          'https://maps.googleapis.com/maps/api/directions/json?'
          'origin=${currentPosition.latitude},${currentPosition.longitude}&'
          'destination=$destination&mode=transit&key=$apiKey';
      durations['Transit'] = await _fetchDuration(transitUrl);

      // Fetch walking duration
      String walkingUrl =
          'https://maps.googleapis.com/maps/api/directions/json?'
          'origin=${currentPosition.latitude},${currentPosition.longitude}&'
          'destination=$destination&mode=walking&key=$apiKey';
      durations['Walking'] = await _fetchDuration(walkingUrl);

      // check existence of data
      durations['Driving'] = await _fetchDuration(drivingUrl);
      print('Two-wheeler URL: $twoWheelerUrl');
      print('Transit URL: $transitUrl');
      print('Walking URL: $walkingUrl');

      return durations;
    } catch (e) {
      print('Error getting durations: $e');
      return {
        'Driving': 'Error fetching duration',
        'Two-wheeler': 'Error fetching duration',
        'Transit': 'Error fetching duration',
        'Walking': 'Error fetching duration',
      };
    }
  }

  Future<String> _fetchDuration(String url) async {

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<dynamic>? routes = data['routes'];

        if (routes != null && routes.isNotEmpty) {
          List<dynamic>? legs = routes[0]['legs'];

          if (legs != null && legs.isNotEmpty) {
            dynamic duration = legs[0]['duration'];

            if (duration != null) {
              return duration['text'];
            }
          }
        }
        throw 'Invalid response structure from the Google Directions API';
      } else {
        print('Failed to fetch duration. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw 'Failed to fetch duration. Status code: ${response.statusCode}';
      }
    } catch (e) {
      print('Error fetching duration: $e');
      return 'Error fetching duration';
    }
  }

  Future<void> _calculateDurations() async {
    try {
      if (currentPosition == null) {
        throw 'Current position is null';
      }

      // Call _getDurations directly
      Map<String, String> durations = await _getDurations();

      // Update the UI directly
      setState(() {
        userLocation =
        'Lat: ${currentPosition.latitude}, Lng: ${currentPosition.longitude}';
        durationFuture = Future.value(durations); // Assign durations to durationFuture
      });
    } catch (e) {
      print('Error calculating durations: $e');
    }
  }

  void _showPickupForm() {
    String _vehicleType = 'Driving'; // Default selection
    String _pickupType = 'Self Pickup'; // Default selection

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
            child: SingleChildScrollView(
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
                    SizedBox(height: 16),
                    Text(
                      'Please select the type of vehicle you will be riding to reach the pickup location:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    RadioListTile<String>(
                      title: Row(
                        children: [
                          Icon(
                            Icons.directions_car,
                            color: Colors.blue, // Change the color to blue
                          ),
                          SizedBox(width: 8),
                          Text('Driving'),
                        ],
                      ),
                      value: 'Driving',
                      groupValue: _vehicleType,
                      onChanged: (String? value) {
                        setState(() {
                          _vehicleType = value!;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: Row(
                        children: [
                          Icon(
                            Icons.motorcycle,
                            color: Colors.green, // Change the color to blue
                          ),
                          SizedBox(width: 8),
                          Text('Two-wheeler'),
                        ],
                      ),
                      value: 'Two-wheeler',
                      groupValue: _vehicleType,
                      onChanged: (String? value) {
                        setState(() {
                          _vehicleType = value!;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: Row(
                        children: [
                          Icon(
                            Icons.train,
                            color: Colors.orange, // Change the color to blue
                          ),
                          SizedBox(width: 8),
                          Text('Transit'),
                        ],
                      ),
                      value: 'Transit',
                      groupValue: _vehicleType,
                      onChanged: (String? value) {
                        setState(() {
                          _vehicleType = value!;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: Row(
                        children: [
                          Icon(
                            Icons.directions_walk,
                            color: Colors.red, // Change the color to blue
                          ),
                          SizedBox(width: 8),
                          Text('Walking'),
                        ],
                      ),
                      value: 'Walking',
                      groupValue: _vehicleType,
                      onChanged: (String? value) {
                        setState(() {
                          _vehicleType = value!;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Please select the person who will pick up your item:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    CheckboxListTile(
                      title: Text('Take the item myself'),
                      value: _pickupType == 'Self Pickup',
                      onChanged: (bool? value) {
                        setState(() {
                          _pickupType = 'Self Pickup';
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: Text('Someone else will take my item'),
                      value: _pickupType == 'Someone Else Pickup',
                      onChanged: (bool? value) {
                        setState(() {
                          _pickupType = 'Someone Else Pickup';
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () async {
                        // Get the durations
                        Map<String, String> durations = await _getDurations();

                        // Send data to the server
                        await _sendDataToServer(widget.itemId.toString(), durations['$_vehicleType'], formattedUserLocation, _pickupType);

                        // Show success message
                        Fluttertoast.showToast(
                          msg: "Have a safe ride!",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                          fontSize: 16.0,
                        );

                        // Close the dialog
                        Navigator.pop(context);                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        fixedSize: Size(250, 30), // Adjust the width and height as needed
                      ),
                      child: Text('Proceed'),
                    ),
                  ],
                ),
              ),
            )
            );
          },
        );
      },
    );
  }

  void _showUnavailableMessage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Align(
                //   alignment: Alignment.topLeft,
                //   child: IconButton(
                //     icon: Icon(Icons.cancel),
                //     onPressed: () {
                //       if (mounted) {
                //         Navigator.pop(context);
                //       }
                //     },
                //   ),
                // ),
                SizedBox(height: 16),
                Text(
                  'Sorry, we are closed today',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Please make the request from Monday to Friday',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                    fixedSize: Size(100, 30), // Adjust the width and height as needed
                  ),
                  child: Text('OK'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


  void _showCancelPickNowMessage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: SizedBox(
            width: 420, // Adjust the width as needed
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 16),
                  Text(
                    'Do you confirm to cancel your pick up process',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          await _sendPickNowStatusDataToServer(widget.itemId.toString());
                          Navigator.pop(context); // Close the dialog
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          fixedSize: Size(100, 30),
                        ),
                        child: Text('Yes'),
                      ),
                      SizedBox(width: 15,),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // Close the dialog
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          fixedSize: Size(100, 30),
                        ),
                        child: Text('No'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }




  Future<void> _sendDataToServer(String itemId, String? duration, String formattedUserLocation, String pickupType) async {
    try {
      // Print the values before sending
      print('Item ID: $itemId, Pick-up Duration: $duration, User Location: $formattedUserLocation, Pickup Type: $pickupType');

      final url = Uri(
        scheme: 'http',
        host: MyApp.baseIpAddress,
        path: MyApp.updateConfirmationDurationLocationPath,
      );

      // Send a POST request to the server
      final response = await http.post(
        url,
        body: {
          'itemId': itemId,
          'pickUpDuration': duration ?? 'default_duration', // Replace 'default_duration' with your default value or handle it accordingly
          'currentLocation': formattedUserLocation,
          'pickupType': pickupType,
        },
      );

      if (response.statusCode == 200) {
        // Handle successful response (if needed)
        //print('Data sent successfully');
      } else {
        // Handle errors or display a message to the user
        print('Failed to send data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending data to the server: $e');
    }
  }

  Future<void> _sendPickNowStatusDataToServer(String itemId) async {
    try {
      // Print the values before sending
      //print('Item ID: $itemId, Pick-up Duration: $duration, User Location: $formattedUserLocation, Pickup Type: $pickupType');

      final url = Uri(
        scheme: 'http',
        host: MyApp.baseIpAddress,
        path: MyApp.updatePickNowStatusPath,
      );

      // Send a POST request to the server
      final response = await http.post(
        url,
        body: {
          'itemId': itemId,
        },
      );

      if (response.statusCode == 200) {
        // Handle successful response (if needed)
        //print('Data sent successfully');
      } else {
        // Handle errors or display a message to the user
        print('Failed to send data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending data to the server: $e');
    }
  }

  Future<String> updateConfirmationStatusOnServer(int itemId, String status) async {
    final url = Uri(
      scheme: 'http',
      host: MyApp.baseIpAddress,
      path: MyApp.updateConfirmationStatusPath,
    );

    // Send a POST request to the server
    final response = await http.post(
      url,
      body: {
        'itemId': itemId.toString(),
        'status': status,
      },
    );

    return response.body;
  }

  Future<void> _selectDate(BuildContext context) async {

    // DateTime currentDate = DateTime.now();
    // DateTime lastSelectableDate = widget.confirmationDate;

    DateTime? picked = await showDatePicker(
      context: context,
      // initialDate: currentDate,
      // firstDate: currentDate,
      //  lastDate: lastSelectableDate.isAfter(currentDate) ? lastSelectableDate : DateTime(9999),
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: widget.dueDate,
      // selectableDayPredicate: (DateTime date) {
      //   // Disable Saturdays and Sundays
      //   return date.weekday != DateTime.saturday && date.weekday != DateTime.sunday;
      // },
    );

    if (picked != null) {
      // Check if the selected date is a weekend (Saturday or Sunday)
      if (picked.weekday == DateTime.saturday || picked.weekday == DateTime.sunday) {
        // Show a message that the service is closed on weekends
        _unavailableDateMessage();
      } else {
        // Convert the selected date to a string in a suitable format
        String formattedDate = picked.toIso8601String();

        // Send the date to the server
        await updatePickUpDateOnServer(widget.itemId, formattedDate);

        Fluttertoast.showToast(
          msg: "Pick-up Date set successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } else {
      // User canceled date selection
    }
  }

void _unavailableDateMessage(){
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Align(
              //   alignment: Alignment.topLeft,
              //   child: IconButton(
              //     icon: Icon(Icons.cancel),
              //     onPressed: () {
              //       if (mounted) {
              //         Navigator.pop(context);
              //       }
              //     },
              //   ),
              // ),
              SizedBox(height: 16),
              Text(
                'Sorry, we are closed on selected date',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Please select your pick up date from Monday to Friday',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  fixedSize: Size(100, 30), // Adjust the width and height as needed
                ),
                child: Text('OK'),
              ),
            ],
          ),
        ),
      );
    },
  );
}


  Future<void> updatePickUpDateOnServer(int itemId, String newPickupDate) async {
    final url = Uri(
      scheme: 'http',
      host: MyApp.baseIpAddress,
      path: MyApp.updatePickupDatePath,
    );

    // Send a POST request to the server
    final response = await http.post(
      url,
      body: {
        'itemId': itemId.toString(),
        'newPickupDate': newPickupDate,
      },
    );

    if (response.statusCode == 200) {
      print("Date updated successfully");
      // You can handle the response here if needed
    } else {
      print("Failed to update date. Server returned ${response.statusCode}");
      // Handle the error
    }
  }


  @override
  Widget build(BuildContext context) {
    String destinationAddress = widget.address;
    return Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
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
                        'Pick Up Details',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 50),
                  ],
                ),
                SizedBox(height: 30,),
                Row(
                  children: [
                    Text(
                      'Pick-up Location:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: () => _launchGoogleMaps(destinationAddress),
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(70, 30),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      child: Text('Go'),
                    ),
                    SizedBox(width: 8),
                    // Use Column to display two lines of text
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '*Navigates the route',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          'in Google Maps App',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  widget.address,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 50),
                /*
                Text(
                  'Coordinates of your current location:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 16,
                          color: Colors.blue, // Customize the color as needed
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Latitude: ',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '${userLocation != 'Fetching...' ? currentPosition.latitude.toString() : 'Coordinating...'}',
                      style: TextStyle(
                        fontSize: 16,
                        //fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 16,
                          color: Colors.blue, // Customize the color as needed
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Longitude: ',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '${userLocation != 'Fetching...' ? currentPosition.longitude.toString() : 'Coordinating...'}',
                      style: TextStyle(
                        fontSize: 16,
                        //fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 50),
                */
                FutureBuilder<Map<String, String>>(
                  future: durationFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text(
                        '',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text(
                        'Error fetching durations',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    } else {
                      final durations = snapshot.data ?? {};
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Durations:',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '*Travel time from your current location',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      Text(
                                        'to the pick-up location',
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 20), // Add space between label and durations
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Icon(
                                Icons.directions_car,
                                size: 24,
                                color: Colors.blue, // Customize the color as needed
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Driving: ${durations['Driving'] ?? 'Calculating...'}',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.motorcycle,
                                size: 24,
                                color: Colors.green, // Customize the color as needed
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Two-wheeler: ${durations['Two-wheeler'] ?? 'Calculating...'}',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.directions_transit,
                                size: 24,
                                color: Colors.orange, // Customize the color as needed
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Transit: ${durations['Transit'] ?? 'Calculating...'}',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.directions_walk,
                                size: 24,
                                color: Colors.red, // Customize the color as needed
                              ),
                              SizedBox(width: 8),
                              Text(
                                'Walking: ${durations['Walking'] ?? 'Calculating...'}',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 50),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start, // Align items to the start
                            children: [
                              Text(
                                'Choose Pick-up date',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              RichText(
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(text: '*Please set date to take your item on '),
                                    TextSpan(
                                      text: 'weekdays',
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    TextSpan(text: ' only'),
                                  ],
                                ),
                              ),
                              SizedBox(height: 10),
                              Text('Pick-up date : ${DateFormat('yyyy-MM-dd').format(widget.pickUpDate)}',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: () {
                                  _selectDate(context); // Call the method to show the date picker
                                },
                                style: ElevatedButton.styleFrom(
                                  fixedSize: Size(100, 30),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                ),
                                child: Text('Select'),
                              ),

                            ],
                          ),
                          SizedBox(height: 50),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start, // Align items to the start
                            children: [
                              Text(
                                'Do you want to pick up your item now?',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '*Notify management to prepare your item',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 8), // Add some space between notes and button
                              Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      // Get the current day of the week (1 for Monday, 7 for Sunday)
                                      int currentDayOfWeek = DateTime.now().weekday;

                                      // Check if it's a weekend (Saturday or Sunday)
                                      bool isWeekend = currentDayOfWeek == DateTime.saturday || currentDayOfWeek == DateTime.sunday;

                                      if (isWeekend) {
                                        // Show a message that the service is unavailable on weekends
                                        _showUnavailableMessage();
                                      } else {
                                        // Execute the _showPickUpForm() function
                                        _showPickupForm();
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      fixedSize: Size(100, 30),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(100),
                                      ),
                                    ),
                                    child: Text('Pick Now'),
                                  ),
                                  SizedBox(width: 20,),
                                  ElevatedButton(
                                    onPressed: widget.status == 'Pending' ? null : () {
                                      _showCancelPickNowMessage();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      fixedSize: Size(100, 30),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(100),
                                      ),
                                      backgroundColor: widget.status == 'Pending' ? Colors.grey : Colors.red,
                                    ),
                                    child: Text('Cancel'),
                                  )


                                ],
                              ),

                            ],
                          ),
                          SizedBox(height: 50),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start, // Align items to the start
                            children: [
                              Text(
                                'Item Pick-up confirmation',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8), // Add some space between text and button
                              Text(
                                '*Show QR Code to the management staff',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              SizedBox(height: 8), // Add some space between notes and button
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => QrCode(
                                        itemId: widget.itemId,
                                        itemName: widget.itemName, // Pass the itemName to the next page
                                        fullName: widget.fullName,
                                        pickupType: widget.pickupType,
                                        confirmationId: widget.confirmationId,
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  fixedSize: Size(100, 30),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                ),
                                child: Text('Show'),
                              ),
                            ],
                          )
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      floatingActionButton: FloatingActionButton(
      onPressed: _refresh,
      child: Icon(Icons.refresh),
    ),
    );
  }
}