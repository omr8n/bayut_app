import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;

import 'package:test_graduation/core/language/app_localizations.dart';
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
    final local = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final locale = Directionality.of(context);
    final isRtl = locale == TextDirection.rtl;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getStatusColor().withValues(alpha: isDark ? 0.2 : 0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.1 : 0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
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
              // الحالة والسبب والتاريخ
              Row(
                children: [
                  _buildBadge(
                    report.status.localizedName(context),
                    _getStatusColor(),
                    isDark,
                  ),
                  const SizedBox(width: 8),
                  _buildBadge(
                    report.reason.localizedName(context),
                    _getReasonColor(),
                    isDark,
                  ),
                  const Spacer(),
                  Text(
                    DateFormat('yyyy/MM/dd HH:mm').format(report.createdAt),
                    style: TextStyle(
                      fontSize: 10,
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textLight,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // عنوان العقار
              Text(
                report.propertyTitle,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),

              // المبلّغ والمبلّغ عنه
              _buildUserRow(
                Icons.person_outline,
                local.reporter + ": ",
                report.reporterName,
                AppColors.textSecondary,
                isDark,
              ),
              const SizedBox(height: 6),
              _buildUserRow(
                Icons.warning_amber_outlined,
                local.reported_user + ": ",
                report.reportedUserName,
                AppColors.error,
                isDark,
              ),

              const SizedBox(height: 12),
              // الوصف
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.03)
                      : Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  report.description,
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? Colors.white70 : AppColors.textPrimary,
                    height: 1.4,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // ملاحظة الأدمن
              if (report.adminNote != null && report.adminNote!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.info.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.info.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.admin_panel_settings_rounded,
                        size: 16,
                        color: AppColors.info,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          report.adminNote!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.info,
                            fontWeight: FontWeight.w500,
                          ),
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

  Widget _buildBadge(String text, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: isDark ? 0.15 : 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }

  Widget _buildUserRow(
    IconData icon,
    String label,
    String name,
    Color color,
    bool isDark,
  ) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color.withValues(alpha: 0.8)),
        const SizedBox(width: 6),
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 13,
              color: isDark
                  ? AppColors.textSecondaryDark
                  : AppColors.textSecondary,
              fontFamily: 'Cairo', // تأكد من استخدام الخط المناسب
            ),
            children: [
              TextSpan(text: label),
              TextSpan(
                text: name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
