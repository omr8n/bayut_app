import 'package:cloud_firestore/cloud_firestore.dart';

class AdminActionModel {
  final String id;
  final String adminId;
  final String adminName;
  final String actionType;
  final String targetId;
  final String description;
  final DateTime createdAt;

  AdminActionModel({
    required this.id,
    required this.adminId,
    required this.adminName,
    required this.actionType,
    required this.targetId,
    required this.description,
    required this.createdAt,
  });

  factory AdminActionModel.fromJson(Map<String, dynamic> json) {
    return AdminActionModel(
      id: json['id'] as String,
      adminId: json['adminId'] as String,
      adminName: json['adminName'] as String,
      actionType: json['actionType'] as String,
      targetId: json['targetId'] as String,
      description: json['description'] as String,
      createdAt: json['createdAt'] is Timestamp
          ? (json['createdAt'] as Timestamp).toDate()
          : DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'adminId': adminId,
      'adminName': adminName,
      'actionType': actionType,
      'targetId': targetId,
      'description': description,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
