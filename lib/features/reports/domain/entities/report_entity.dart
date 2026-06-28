import 'package:equatable/equatable.dart';

import 'package:flutter/material.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';

enum ReportStatus { pending, underReview, resolved, rejected }

extension ReportStatusX on ReportStatus {
  String localizedName(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    switch (this) {
      case ReportStatus.pending:
        return locale.translate(LangKeys.statusPending);
      case ReportStatus.underReview:
        return locale.translate(LangKeys.statusUnderReview);
      case ReportStatus.resolved:
        return locale.translate(LangKeys.statusResolved);
      case ReportStatus.rejected:
        return locale.translate(LangKeys.statusRejected);
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
  String localizedName(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    switch (this) {
      case ReportReason.wrongInfo:
        return locale.translate(LangKeys.reasonWrongInfo);
      case ReportReason.fake:
        return locale.translate(LangKeys.reasonFake);
      case ReportReason.duplicate:
        return locale.translate(LangKeys.reasonDuplicate);
      case ReportReason.scam:
        return locale.translate(LangKeys.reasonScam);
      case ReportReason.fraud:
        return locale.translate(LangKeys.reasonFraud);
      case ReportReason.inappropriate:
        return locale.translate(LangKeys.reasonInappropriate);
      case ReportReason.unavailable:
        return locale.translate(LangKeys.reasonUnavailable);
      case ReportReason.incorrectLocation:
        return locale.translate(LangKeys.reasonIncorrectLocation);
      case ReportReason.inaccuratePhotos:
        return locale.translate(LangKeys.reasonInaccuratePhotos);
      case ReportReason.other:
        return locale.translate(LangKeys.reasonOther);
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
