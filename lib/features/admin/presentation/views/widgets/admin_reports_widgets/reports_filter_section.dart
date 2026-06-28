import 'package:flutter/material.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/features/reports/domain/entities/report_entity.dart';

class ReportsFilterSection extends StatelessWidget {
  const ReportsFilterSection({
    super.key,
    required this.allReports,
    required this.selectedStatus,
    required this.onStatusChanged,
  });

  final List<ReportEntity> allReports;
  final ReportStatus? selectedStatus;
  final Function(ReportStatus?) onStatusChanged;

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: const BoxDecoration(
        color: Color(0xFF0F172A),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            _FilterChip(
              label: local.all,
              isSelected: selectedStatus == null,
              onTap: () => onStatusChanged(null),
              count: allReports.length,
            ),
            const SizedBox(width: 8),
            _FilterChip(
              label: local.status_pending,
              isSelected: selectedStatus == ReportStatus.pending,
              onTap: () => onStatusChanged(ReportStatus.pending),
              color: AppColors.warning,
              count: allReports
                  .where((r) => r.status == ReportStatus.pending)
                  .length,
            ),
            const SizedBox(width: 8),
            _FilterChip(
              label: local.status_under_review,
              isSelected: selectedStatus == ReportStatus.underReview,
              onTap: () => onStatusChanged(ReportStatus.underReview),
              color: AppColors.info,
              count: allReports
                  .where((r) => r.status == ReportStatus.underReview)
                  .length,
            ),
            const SizedBox(width: 8),
            _FilterChip(
              label: local.status_resolved,
              isSelected: selectedStatus == ReportStatus.resolved,
              onTap: () => onStatusChanged(ReportStatus.resolved),
              color: AppColors.success,
              count: allReports
                  .where((r) => r.status == ReportStatus.resolved)
                  .length,
            ),
            const SizedBox(width: 8),
            _FilterChip(
              label: local.status_rejected,
              isSelected: selectedStatus == ReportStatus.rejected,
              onTap: () => onStatusChanged(ReportStatus.rejected),
              color: AppColors.error,
              count: allReports
                  .where((r) => r.status == ReportStatus.rejected)
                  .length,
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.color,
    this.count = 0,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? color;
  final int count;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected
              ? [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8)]
              : null,
        ),
        child: Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: isSelected ? AppColors.primary : Colors.white,
              ),
            ),
            if (count > 0) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (color ?? AppColors.primary)
                      : Colors.white.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  count.toString(),
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
