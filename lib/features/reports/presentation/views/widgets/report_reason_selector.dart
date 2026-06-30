import 'package:flutter/material.dart';
import 'package:test_graduation/core/language/lang_keys.dart';
import 'package:test_graduation/core/language/app_localizations.dart';

import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/features/reports/domain/entities/report_entity.dart';

class ReportReasonSelector extends StatelessWidget {
  final ReportReason? selectedReason;
  final ValueChanged<ReportReason> onReasonSelected;

  const ReportReasonSelector({
    super.key,
    required this.selectedReason,
    required this.onReasonSelected,
  });

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          locale.translate(LangKeys.whyReportingQuestion),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 10,
          children: ReportReason.values.map((reason) {
            final isSelected = selectedReason == reason;
            return GestureDetector(
              onTap: () => onReasonSelected(reason),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.error
                      : (isDark ? AppColors.darkSurface : Colors.grey[50]),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.error
                        : (isDark ? Colors.white10 : Colors.grey[200]!),
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.error.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [],
                ),
                child: Text(
                  reason.localizedName(context),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: isSelected
                        ? Colors.white
                        : (isDark ? Colors.white70 : AppColors.textPrimary),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
