import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;
import 'main.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AdminPage extends StatefulWidget {
  final String username;

  const AdminPage({Key? key, required this.username}) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;
  String successMessage = ''; // Add this line to store success message

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 70, 16, 16), // Adjust top padding
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start, // Align items at the top
              children: [
                Text(
                  "Welcome, ${widget.username}", // Display a greeting message
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.logout),
                  onPressed: () {
                    Fluttertoast.showToast(
                      msg: "Logout successful",
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      toastLength: Toast.LENGTH_SHORT,
                    );
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MyHomePage()),
                    );
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: 150), // Add space between the two text widgets
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Place the QR Code in the area',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.width * 0.8,
                    child: QRView(
                      key: qrKey,
                      onQRViewCreated: _onQRViewCreated,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    successMessage,
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            successMessage = '';
          });
          controller.resumeCamera();
        },
        tooltip: 'Refresh',
        child: Icon(Icons.refresh),
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      // Explicitly cast scanData.code to non-nullable String
      Map<String, String?> data = processScannedData(scanData.code!);

      // Once the information is extracted, you can update the status on the database
      int itemId = data['itemID'] != null ? int.tryParse(data['itemID']!) ?? 0 : 0;
      String status = data['status'] ?? '';

      // Check for non-null and non-empty status before updating
      if (status.isNotEmpty) {
        updateConfirmationStatusOnServer(itemId, status);
      }

      // Pause the camera after the first scan
      controller.pauseCamera();
    });
  }


  Map<String, String?> processScannedData(String qrCodeData) {
    // Parse the QR code data to extract information
    // Example: 'itemID=123&status=Picked'
    List<String> pairs = qrCodeData.split('&');
    Map<String, String?> data = {};
    for (String pair in pairs) {
      List<String> keyValue = pair.split('=');
      if (keyValue.length == 2) {
        if (keyValue[0] == 'itemID') {
          data[keyValue[0]] = int.tryParse(keyValue[1])?.toString();
        } else {
          data[keyValue[0]] = keyValue[1];
        }
      }
    }

    // Extracted information
    String? itemId = data['itemID'];
    String? status = data['status'];

    // Handle the extracted information as needed
    print('Scanned Item ID: $itemId, Status: $status');

    return data;
  }

  Future<void> updateConfirmationStatusOnServer(int itemId, String? status) async {
    final url = Uri(
      scheme: 'http',
      host: MyApp.baseIpAddress,
      path: MyApp.updateConfirmationStatusPath,
    );

    // Convert null status to an empty string
    final nonNullableStatus = status ?? '';

    // Send a POST request to the server
    final response = await http.post(
      url,
      body: {
        'itemId': itemId.toString(), // toString() on int returns a non-nullable String
        'status': nonNullableStatus,
      },
    );

    if (response.statusCode == 200) {
      print('Status updated successfully');
      setState(() {
        successMessage = 'Update successful';
      });
    } else {
      print('Failed to update status. Server response: ${response.body}');
    }
  }


  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
