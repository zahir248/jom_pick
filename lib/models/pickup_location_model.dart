import 'dart:typed_data';
import 'dart:convert';

class pickupLocationList{

  final int pickupLocation_id;
  final String address;
  final String name;
  final Uint8List? imageData;

  pickupLocationList({
    required this.pickupLocation_id,
    required this.address,
    required this.name,
    required this.imageData
  });

  factory pickupLocationList.fromJson(Map<String, dynamic> json){

    Uint8List? decodedImageData = json['image'] != null ? base64.decode(json['image']) : null;
    return pickupLocationList(
        pickupLocation_id: int.parse(json['pickupLocation_id'] ?? '0'),
        address: json['address'] ?? '',
        name: json['name'] ?? '',
        imageData: decodedImageData,
    );
  }
}