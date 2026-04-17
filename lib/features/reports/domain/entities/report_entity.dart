import 'package:equatable/equatable.dart';

enum ReportStatus { pending, underReview, resolved, rejected }

extension ReportStatusX on ReportStatus {
  String get arabicName {
    switch (this) {
      case ReportStatus.pending:
        return 'جديد';
      case ReportStatus.underReview:
        return 'قيد المراجعة';
      case ReportStatus.resolved:
        return 'تم الحل';
      case ReportStatus.rejected:
        return 'مرفوض';
    }
  }
}

enum ReportReason {
  wrongInfo,
  fake,
  duplicate,
  scam,
  fraud,
  inappropriate,
  unavailable,
  incorrectLocation,
  inaccuratePhotos,
  other,
}

extension ReportReasonX on ReportReason {
  String get arabicName {
    switch (this) {
      case ReportReason.wrongInfo:
        return 'معلومات خاطئة';
      case ReportReason.fake:
        return 'إعلان وهمي';
      case ReportReason.duplicate:
        return 'إعلان متكرر';
      case ReportReason.scam:
        return 'احتيال';
      case ReportReason.fraud:
        return 'تلاعب بالسعر';
      case ReportReason.inappropriate:
        return 'محتوى غير لائق';
      case ReportReason.unavailable:
        return 'غير متاح';
      case ReportReason.incorrectLocation:
        return 'موقع خاطئ';
      case ReportReason.inaccuratePhotos:
        return 'صور غير دقيقة';
      case ReportReason.other:
        return 'أسباب أخرى';
    }
  }
}

class ReportEntity extends Equatable {
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
  final String? adminNote;

  const ReportEntity({
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
    this.adminNote,
  });

  @override
  List<Object?> get props => [
    id,
    propertyId,
    reporterId,
    status,
    reason,
    adminNote,
  ];
}
