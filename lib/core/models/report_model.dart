import 'package:equatable/equatable.dart';
import '../../features/reports/domain/entities/report_entity.dart';

// هذا الكلاس قديم (Mock)، سنبقيه مؤقتاً لتجنب كسر أجزاء أخرى 
// ولكن يجب استخدامه مع Enums القادمة من ReportEntity
class Report extends Equatable {
  final String id;
  final String propertyId;
  final String propertyTitle;
  final String reporterId; 
  final String reporterName;
  final String reporterEmail; 
  final String reportedUserId; 
  final String reportedUserName;
  final ReportReason reason;
  final String description;
  final ReportStatus status;
  final DateTime createdAt;
  final DateTime? resolvedAt;
  final String? adminNote; 

  const Report({
    required this.id,
    required this.propertyId,
    required this.propertyTitle,
    required this.reporterId,
    required this.reporterName,
    required this.reporterEmail,
    required this.reportedUserId,
    required this.reportedUserName,
    required this.reason,
    required this.description,
    required this.status,
    required this.createdAt,
    this.resolvedAt,
    this.adminNote,
  });

  @override
  List<Object?> get props => [
    id, propertyId, propertyTitle, reporterId, reporterName, 
    reporterEmail, reportedUserId, reportedUserName, reason, 
    description, status, createdAt, resolvedAt, adminNote,
  ];
}
