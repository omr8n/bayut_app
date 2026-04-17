import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test_graduation/core/models/report_model.dart';
import 'package:test_graduation/core/utils/colors.dart';
import '../../features/reports/domain/entities/report_entity.dart';

// عنصر الإبلاغ في القائمة (نسخة متوافقة مع Clean Architecture)
class ReportItem extends StatelessWidget {
  final ReportEntity report;
  final VoidCallback? onTap;

  const ReportItem({super.key, required this.report, this.onTap});

  Color _getStatusColor() {
    switch (report.status) {
      case ReportStatus.pending:
        return AppColors.warning;
      case ReportStatus.underReview:
        return AppColors.info;
      case ReportStatus.resolved:
        return AppColors.success;
      case ReportStatus.rejected:
        return AppColors.error;
    }
  }

  Color _getReasonColor() {
    switch (report.reason) {
      case ReportReason.wrongInfo:
        return AppColors.info;
      case ReportReason.fake:
        return AppColors.error;
      case ReportReason.duplicate:
        return AppColors.warning;
      case ReportReason.scam:
      case ReportReason.fraud:
        return Colors.red.shade800;
      case ReportReason.inappropriate:
        return AppColors.error;
      case ReportReason.unavailable:
        return AppColors.textSecondary;
      case ReportReason.incorrectLocation:
        return AppColors.warning;
      case ReportReason.inaccuratePhotos:
        return AppColors.error;
      case ReportReason.other:
        return AppColors.textSecondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _getStatusColor().withOpacity(0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // الحالة والسبب
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      report.status.arabicName,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: _getStatusColor(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getReasonColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      report.reason.arabicName,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: _getReasonColor(),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    DateFormat('yyyy/MM/dd HH:mm').format(report.createdAt),
                    style: TextStyle(fontSize: 11, color: AppColors.textLight),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // عنوان العقار
              Text(
                report.propertyTitle,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),

              // المبلّغ
              Row(
                children: [
                  Icon(
                    Icons.person_outline,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'المبلّغ: ${report.reporterName}',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),

              // المبلّغ عنه
              Row(
                children: [
                  Icon(
                    Icons.warning_amber_outlined,
                    size: 16,
                    color: AppColors.error,
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'المبلّغ عنه: ${report.reportedUserName}',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // الوصف
              Text(
                report.description,
                style: TextStyle(fontSize: 13, color: AppColors.textPrimary),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              // ملاحظة الأدمن
              if (report.adminNote != null && report.adminNote!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.info.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.admin_panel_settings,
                        size: 16,
                        color: AppColors.info,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          report.adminNote!,
                          style: TextStyle(fontSize: 12, color: AppColors.info),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
