import 'dart:convert';
import 'dart:typed_data';

class PenaltyDetails{
    final int itemId;
    final String itemName;
    final String location;
    final DateTime registerDate;
    final String trackingNumber;
    final String itemType;
    final String confirmationStatus;
    final DateTime confirmationDate;
    final String dueDateStatus;
    final String pickUpLocation;
    final String dueDate;
    final String paymentStatus;
    final String paymentAmount;
    final Uint8List imageData;


    PenaltyDetails({
    required this.itemId,
    required this.itemName,
    required this.location,
    required this.registerDate,
    required this.trackingNumber,
    required this.itemType,
    required this.confirmationStatus,
    required this.confirmationDate,
    required this.dueDateStatus,
    required this.pickUpLocation,
    required this.dueDate,
    required this.paymentStatus,
    required this.paymentAmount,
        required this.imageData,
});

factory PenaltyDetails.fromJson(Map<String, dynamic> json){
    Uint8List decodedImageData = base64Decode(json['image']);
  return PenaltyDetails(
      itemId: int.parse(json['item_id'] ?? '0'),
      itemName: json['name'] ?? '',
      location: json['location'] ?? '',
      registerDate: DateTime.parse(json['registerDate'] ?? ''),
      trackingNumber: json['trackingNumber'] ?? '',
      itemType: json['itemTypeName'] ?? '',
      confirmationStatus: json['confirmationStatus'] ?? '',
      confirmationDate: DateTime.parse(json['confirmationDate'] ?? ''),
      dueDateStatus: json['type'] ?? '',
      pickUpLocation: json['address'] ?? '',
      dueDate: json['dueDate'] ?? '',
      paymentStatus: json['paymentStatus'] ?? '',
      paymentAmount: json['paymentAmount'] ??'',
      imageData: decodedImageData
        );
    }
}