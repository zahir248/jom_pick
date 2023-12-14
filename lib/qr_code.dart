import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCode extends StatelessWidget {
  final int itemId;

  const QrCode({Key? key, required this.itemId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                SizedBox(width: 16.0), // Adjust the width for the desired spacing
              ],
            ),
          ),
          SizedBox(height: 80.0), // Add space between text and QR Code
          Center(
            child: QrImageView(
              data: 'itemID=$itemId&status=Picked',
              version: QrVersions.auto,
              size: 290.0,
            ),
          ),
        ],
      ),
    );
  }
}
