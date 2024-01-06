import 'dart:convert';

import 'package:flutter/foundation.dart';

class User {
  final int userId;
  final String userName;
  final Uint8List? image;
  final String JomPick_ID;

  User({
    required this.userId,
    required this.userName,
    required this.image,
    required this.JomPick_ID,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    Uint8List? decodedImage;
    if (json['image'] != null) {
      decodedImage = base64.decode(json['image']);
    }
    return User(
      userId: int.parse(json['user_id'] ?? '0'), // Assuming userId is an integer, use 0 as default
      userName: json['userName'] ?? '',
      image: decodedImage,
      JomPick_ID: json['JomPick_ID'] ?? '',
    );
  }
}
