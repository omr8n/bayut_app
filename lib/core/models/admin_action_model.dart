import 'package:cloud_firestore/cloud_firestore.dart';

class AdminActionModel {
  final String id;
  final String adminId;
  final String adminName;
  final String actionType; // e.g., 'DELETE_PROPERTY', 'BLOCK_USER', 'CHANGE_STATUS'
  final String targetId;   // ID of the property or user affected
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

  Map<String, dynamic> toJson() => {
        'id': id,
        'adminId': adminId,
        'adminName': adminName,
        'actionType': actionType,
        'targetId': targetId,
        'description': description,
        'createdAt': createdAt,
      };

  factory AdminActionModel.fromJson(Map<String, dynamic> json) => AdminActionModel(
        id: json['id'],
        adminId: json['adminId'],
        adminName: json['adminName'],
        actionType: json['actionType'],
        targetId: json['targetId'],
        description: json['description'],
        createdAt: (json['createdAt'] as Timestamp).toDate(),
      );
}
