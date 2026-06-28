import 'package:flutter/material.dart';
import 'package:test_graduation/core/language/lang_keys.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/models/report_model.dart';
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          locale.translate(LangKeys.whyReportingQuestion),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                  color: isSelected ? AppColors.error : Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? AppColors.error : Colors.grey[200]!,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.error.withOpacity(0.3),
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
                    color: isSelected ? Colors.white : AppColors.textPrimary,
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
