import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;
import 'main.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class AdminPage extends StatefulWidget {
  final String username;

  const AdminPage({Key? key, required this.username}) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;
  String successMessage = '';
  Map<String, String?> scannedItemDetails = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 70, 16, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome, ${widget.username}",
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
          SizedBox(height: 30),
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
                      fontSize: 16,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                // Display item details
                if (scannedItemDetails.isNotEmpty)
                  Column(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 50),
                      Text(
                        'Scanned Item Details:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        'Item Name: ${scannedItemDetails['itemName']}',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Item Owner: ${scannedItemDetails['fullName']}',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Receiver: ${scannedItemDetails['pickupType']}',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 15),
                      // Add a button
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            _takePicture();
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                          child: Text('Take Picture'),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _refresh,
        tooltip: 'Refresh',
        child: Icon(Icons.refresh),
      ),
    );
  }

  void _takePicture() async {
    final ImagePicker _picker = ImagePicker();

    int imageQuality = 50;

    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: imageQuality,
    );

    if (image != null) {
      // Pass confirmationId to the sendImageToServer method
      await _sendImageToServer(image, scannedItemDetails['confirmationID']);

      // Show toast message
      Fluttertoast.showToast(
        msg: 'Image uploaded successfully',
        backgroundColor: Colors.green,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_SHORT,
      );

      // Update the successMessage
      setState(() {
        //successMessage = 'Picture taken successfully';
      });
    }
  }


  Future<void> _sendImageToServer(XFile image, String? confirmationId) async {
    try {
      if (confirmationId != null && confirmationId.isNotEmpty) {

        final url = Uri(
          scheme: 'http',
          host: MyApp.baseIpAddress,
          path: MyApp.uploadProofImagePath,
        );

        final request = http.MultipartRequest('POST', url);
        request.fields['confirmationId'] = confirmationId;
        request.files.add(await http.MultipartFile.fromPath('imageProof', image.path));

        final response = await request.send();

        if (response.statusCode == 200) {
          print('Image uploaded successfully');
        } else {
          print('Failed to upload image. Server response: ${response.reasonPhrase}');
        }
      } else {
        print('Confirmation ID is null or empty');
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      Map<String, String?> data = processScannedData(scanData.code!);

      int itemId = data['itemID'] != null ? int.tryParse(data['itemID']!) ?? 0 : 0;
      String itemName = data['itemName'] ?? '';
      String status = data['status'] ?? '';
      String fullName = data['fullName'] ?? '';
      String pickupType = data['pickupType'] ?? '';
      int confirmationId = data['confirmationID'] != null ? int.tryParse(data['confirmationID']!) ?? 0 : 0;

      if (status.isNotEmpty) {
        updateConfirmationStatusOnServer(itemId, status);
      }

      // Store the scanned item details
      setState(() {
        scannedItemDetails = {
          'itemID': itemId.toString(),
          'itemName': itemName,
          'status': status,
          'fullName': fullName,
          'pickupType': pickupType,
          'confirmationID': confirmationId.toString(),
        };
      });

      controller.pauseCamera();
    });
  }

  void _refresh() {
    setState(() {
      successMessage = '';
      scannedItemDetails = {}; // Reset scanned item details
    });
    controller.resumeCamera();
  }

  Map<String, String?> processScannedData(String qrCodeData) {
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

    String? itemId = data['itemID'];
    String? itemName = data['itemName'];
    String? status = data['status'];
    String? fullName = data['fullName'];
    String? pickupType = data['pickupType'];
    String? confirmationId = data['confirmationID'];

    print('Scanned Item ID: $itemId, Item Name: $itemName, Status: $status, Owner: $fullName, Receiver: $pickupType, confirmation id: $confirmationId');

    return data;
  }

  Future<void> updateConfirmationStatusOnServer(int itemId, String? status) async {
    final url = Uri(
      scheme: 'http',
      host: MyApp.baseIpAddress,
      path: MyApp.updateConfirmationStatusAdminPath,
    );

    final nonNullableStatus = status ?? '';

    final response = await http.post(
      url,
      body: {
        'itemId': itemId.toString(),
        'status': nonNullableStatus,
      },
    );

    if (response.statusCode == 200) {
      print('Status updated successfully');
      setState(() {
        successMessage = 'Item Pick-up Confirmed';
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