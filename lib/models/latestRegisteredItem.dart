import 'dart:typed_data';
import 'dart:convert';

class latestRegisteredItem {
  final int itemId;
  final String itemName;
  final DateTime registerDate;
  final String trackingNumber;
  final Uint8List imageData; // Use Uint8List for binary image data
  final String status;
  final DateTime confirmationDate;
// Use Uint8List for binary image data

  latestRegisteredItem({
    required this.itemId,
    required this.itemName,
    required this.registerDate,
    required this.trackingNumber,
    required this.imageData,
    required this.status,
    required this.confirmationDate,
  });

  factory latestRegisteredItem.fromJson(Map<String, dynamic> json) {
    // Decode base64 to Uint8List
    Uint8List decodedImageData = base64.decode(json['image']);

    return latestRegisteredItem(
      itemId: int.parse(json['item_id'] ?? '0'),
      itemName: json['name'] ?? '',
      registerDate: DateTime.parse(json['registerDate'] ?? ''),
      trackingNumber: json['trackingNumber'] ?? '',
      imageData: decodedImageData,
      status: json['status'] ?? '',
      confirmationDate: DateTime.parse(json['confirmationDate'] ?? ''),
    );
  }
}