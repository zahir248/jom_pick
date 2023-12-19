import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCode extends StatelessWidget {
  final int itemId;
  final String itemName;
  final String fullName;
  final String pickupType;
  final int confirmationId;

  const QrCode({Key? key, required this.itemId, required this.itemName, required this.fullName, required this.pickupType, required this.confirmationId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Combine itemId and itemName in the data string
    String qrData = 'itemID=$itemId&itemName=$itemName&status=Picked&fullName=$fullName&pickupType=$pickupType&confirmationID=$confirmationId';

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 50.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(width: 70.0),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                      5.0, 70.0, 16.0, 50.0),
                  child: Text(
                    'QR Code',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 16.0),
              ],
            ),
          ),
          SizedBox(height: 80.0),
          Center(
            child: QrImageView(
              data: qrData, // Use the combined data string
              version: QrVersions.auto,
              size: 290.0,
            ),
          ),
        ],
      ),
    );
  }
}
