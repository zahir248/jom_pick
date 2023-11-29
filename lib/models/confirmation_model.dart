import 'dart:typed_data';
import 'dart:convert';

import 'package:flutter/material.dart';

class Confirmation {
  final int confirmationId;
  final String status;
  final Duration pickUpDuration;
  final String currentLocation;
  final DateTime confirmationDate;
  final String pickUpLocation;

  Confirmation({
    required this.confirmationId,
    required this.status,
    required this.pickUpDuration,
    required this.currentLocation,
    required this.confirmationDate,
    required this.pickUpLocation,
});

  factory Confirmation.fromJson(Map<String, dynamic> json) {
    return Confirmation(
        confirmationId: int.parse(json['confirmation_id'] ?? '0'),
        status: json['status'] ?? '',
        pickUpDuration: json['pickUpDuration'] ?? '',
        currentLocation: json['currentLocation'] ?? '',
        confirmationDate: DateTime.parse(json['condfirmationDate'] ?? ''),
        pickUpLocation: json['pickUpLocation'] ?? ''
    );
  } 
}