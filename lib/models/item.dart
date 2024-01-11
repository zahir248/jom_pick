import 'dart:typed_data';
import 'dart:convert';

class Item {
  final int itemId;
  final String itemName;
  //final String location;
  final String pickUpLocation;
  final DateTime registerDate;
  final String trackingNumber;
  final String itemType;
  final String address;
  final Uint8List imageData; // Use Uint8List for binary image data
  final String status;
  final DateTime dueDate;
  //final DateTime confirmationDate;
  final DateTime pickUpDate;
  final String penaltyStatus;
  final String fullName;
  final String pickupType;
  final int confirmationId;
  final Uint8List imageProofData; // Use Uint8List for binary image data

  Item({
    required this.itemId,
    required this.itemName,
    //required this.location,
    required this.pickUpLocation,
    required this.registerDate,
    required this.trackingNumber,
    required this.itemType,
    required this.address,
    required this.imageData,
    required this.status,
    required this.dueDate,
    //required this.confirmationDate,
    required this.pickUpDate,
    required this.penaltyStatus,
    required this.fullName,
    required this.pickupType,
    required this.confirmationId,
    required this.imageProofData,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    // Decode base64 to Uint8List
    Uint8List decodedImageData = base64.decode(json['image']);
    Uint8List decodedImageProofData = base64.decode(json['imageProof']);

    return Item(
      itemId: int.parse(json['item_id'] ?? '0'),
      itemName: json['name'] ?? '',
      //location: json['location'] ?? '',
      pickUpLocation: json['pickUpName'] ?? '',
      registerDate: DateTime.parse(json['registerDate'] ?? ''),
      trackingNumber: json['trackingNumber'] ?? '',
      itemType: json['itemType'] ?? '',
      address: json['address'] ?? '',
      imageData: decodedImageData,
      status: json['status'] ?? '',
      dueDate: DateTime.parse(json['dueDate'] ?? ''),
      //confirmationDate: DateTime.parse(json['confirmationDate'] ?? ''),
      pickUpDate: json['pickUpDate'] != null ? DateTime.parse(json['pickUpDate']) : DateTime.now(),
      penaltyStatus: json['penaltyStatus'] ?? '',
      fullName: json['fullName'] ?? '',
      pickupType: json['pickupType'] ?? '',
      confirmationId: int.parse(json['confirmation_id'] ?? '0'),
      imageProofData: decodedImageProofData,
    );
  }
}