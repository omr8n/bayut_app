import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/report_entity.dart';

class ReportModel extends ReportEntity {
  const ReportModel({
    required super.id,
    required super.propertyId,
    required super.propertyTitle,
    required super.reporterId,
    required super.reporterName,
    required super.reporterEmail,
    required super.reportedUserId,
    required super.reportedUserName,
    required super.reason,
    required super.description,
    required super.status,
    required super.createdAt,
    super.adminNote,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id'] ?? '',
      propertyId: json['propertyId'] ?? '',
      propertyTitle: json['propertyTitle'] ?? '',
      reporterId: json['reporterId'] ?? '',
      reporterName: json['reporterName'] ?? '',
      reporterEmail: json['reporterEmail'] ?? '',
      reportedUserId: json['reportedUserId'] ?? '',
      reportedUserName: json['reportedUserName'] ?? '',
      reason: ReportReason.values.firstWhere(
        (e) => e.name == json['reason'],
        orElse: () => ReportReason.other,
      ),
      description: json['description'] ?? '',
      status: ReportStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ReportStatus.pending,
      ),
      createdAt: _parseDate(json['createdAt']),
      adminNote: json['adminNote'],
    );
  }

  static DateTime _parseDate(dynamic date) {
    if (date == null) return DateTime.now();
    if (date is Timestamp) return date.toDate();
    if (date is String) return DateTime.parse(date);
    return DateTime.now();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'propertyId': propertyId,
      'propertyTitle': propertyTitle,
      'reporterId': reporterId,
      'reporterName': reporterName,
      'reporterEmail': reporterEmail,
      'reportedUserId': reportedUserId,
      'reportedUserName': reportedUserName,
      'reason': reason.name,
      'description': description,
      'status': status.name,
      'createdAt': createdAt.toIso8601String(),
      'adminNote': adminNote,
    };
  }

  factory ReportModel.fromEntity(ReportEntity entity) {
    return ReportModel(
      id: entity.id,
      propertyId: entity.propertyId,
      propertyTitle: entity.propertyTitle,
      reporterId: entity.reporterId,
      reporterName: entity.reporterName,
      reporterEmail: entity.reporterEmail,
      reportedUserId: entity.reportedUserId,
      reportedUserName: entity.reportedUserName,
      reason: entity.reason,
      description: entity.description,
      status: entity.status,
      createdAt: entity.createdAt,
      adminNote: entity.adminNote,
    );
  }
}
