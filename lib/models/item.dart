import 'dart:typed_data';
import 'dart:convert';

class Item {
  final int itemId;
  final String itemName;
  final String location;
  final DateTime registerDate;
  final String trackingNumber;
  final String itemType;
  final String address;
  final Uint8List imageData; // Use Uint8List for binary image data
  final String status;
  final DateTime confirmationDate;
  final String penaltyStatus;
  final String paymentStatus;

  Item({
    required this.itemId,
    required this.itemName,
    required this.location,
    required this.registerDate,
    required this.trackingNumber,
    required this.itemType,
    required this.address,
    required this.imageData,
    required this.status,
    required this.confirmationDate,
    required this.penaltyStatus,
    required this.paymentStatus,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    // Decode base64 to Uint8List
    Uint8List decodedImageData = base64.decode(json['image']);
    return Item(
      itemId: int.parse(json['item_id'] ?? '0'),
      itemName: json['name'] ?? '',
      location: json['location'] ?? '',
      registerDate: DateTime.parse(json['registerDate'] ?? ''),
      trackingNumber: json['trackingNumber'] ?? '',
      itemType: json['itemType'] ?? '',
      address: json['address'] ?? '',
      imageData: decodedImageData,
      status: json['status'] ?? '',
      confirmationDate: DateTime.parse(json['confirmationDate'] ?? ''),
      penaltyStatus: json['penaltyStatus'] ?? '',
      paymentStatus: json['paymentStatus'] ?? '',
    );
  }
}