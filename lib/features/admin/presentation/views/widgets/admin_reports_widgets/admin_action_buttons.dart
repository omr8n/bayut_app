import 'package:flutter/material.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/features/reports/domain/entities/report_entity.dart';

class AdminActionButtons extends StatelessWidget {
  const AdminActionButtons({
    super.key,
    required this.report,
    required this.onUpdateStatus,
  });

  final ReportEntity report;
  final Function(ReportStatus status) onUpdateStatus;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (report.status == ReportStatus.pending) ...[
          SizedBox(
            width: double.infinity,
            child: _MainButton(
              label: 'بدء المراجعة (قيد المراجعة الآن)',
              icon: Icons.hourglass_top_rounded,
              color: AppColors.info,
              onPressed: () => onUpdateStatus(ReportStatus.underReview),
            ),
          ),
          const SizedBox(height: 12),
        ],
        Row(
          children: [
            Expanded(
              child: _MainButton(
                label: 'تم الحل',
                icon: Icons.check_circle,
                color: AppColors.success,
                onPressed: () => onUpdateStatus(ReportStatus.resolved),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _MainButton(
                label: 'مرفوض',
                icon: Icons.cancel,
                color: AppColors.error,
                onPressed: () => onUpdateStatus(ReportStatus.rejected),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MainButton extends StatelessWidget {
  const _MainButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20, color: Colors.white),
      label: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 0,
      ),
    );
  }
}
