import 'package:flutter/foundation.dart';

class User {
  final int userId;
  final String userName;

  User({
    required this.userId,
    required this.userName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'] ?? 0, // Assuming userId is an integer, use 0 as default
      userName: json['userName'] ?? '',
    );
  }
}
