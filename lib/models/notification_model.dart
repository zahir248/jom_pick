import 'dart:typed_data';
import 'dart:convert';

import 'package:flutter/material.dart';

class SendNotification {
  final int itemId;
  final String itemName;
  final String status;
  final String pickUpLocation;
  final String dueDate;
  final DateTime registerDate;


  SendNotification({
    required this.itemId,
    required this.itemName,
    required this.status,
    required this.pickUpLocation,
    required this.dueDate,
    required this.registerDate,
  });

  factory SendNotification.fromJson(Map<String, dynamic> json) {
    return SendNotification(
      itemId: int.parse(json['item_id'] ?? '0'),
      itemName: json['name'] ?? '',
      status: json['status'] ?? '',
      pickUpLocation: json['address'] ?? '',
      dueDate: json['dueDate'] ?? '',
      registerDate: DateTime.parse(json['registerDate'] ?? ''),
    );
  }

}