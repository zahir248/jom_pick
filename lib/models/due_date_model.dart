import 'dart:typed_data';
import 'dart:convert';

class dueDateStatus{
  final int dueDateStatus_id;
  final int paymentStatus_id;
  final DateTime dueDate;
  final String status;

  dueDateStatus({
    required this.dueDateStatus_id,
    required this.paymentStatus_id,
    required this.dueDate,
    required this.status,
});

  // This map represent JSON data receive from the API
  factory dueDateStatus.fromJson(Map<String, dynamic> json){
    return dueDateStatus(
        dueDateStatus_id: int.parse(json['dueDateStatus_id'] ?? 0), 
        paymentStatus_id: json['paymentStatus_id'] ?? '',
        dueDate: json['dueDate'] ?? '',
        status: json['status'] ?? ''
    );
  }
}

