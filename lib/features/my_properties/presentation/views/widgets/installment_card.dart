import 'package:flutter/material.dart';
import 'package:test_graduation/core/widgets/custom_text_form_field.dart';

class InstallmentCard extends StatelessWidget {
  final bool hasInstallment;
  final Function(bool?) onInstallmentChanged;
  final TextEditingController downPaymentController;
  final TextEditingController monthlyInstallmentController;
  final TextEditingController installmentDurationController;
  final FocusNode durationNode;
  final TextEditingController installmentNotesController;
  final VoidCallback showNotesDialog;

  const InstallmentCard({
    super.key,
    required this.hasInstallment,
    required this.onInstallmentChanged,
    required this.downPaymentController,
    required this.monthlyInstallmentController,
    required this.installmentDurationController,
    required this.durationNode,
    required this.installmentNotesController,
    required this.showNotesDialog,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue.shade100),
                borderRadius: BorderRadius.circular(8),
              ),
              child: CheckboxListTile(
                title: const Text('نعم متاح بالتقسيط'),
                value: hasInstallment,
                secondary: const Icon(Icons.credit_card),
                onChanged: onInstallmentChanged,
              ),
            ),
            if (hasInstallment) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: CustomTextFormField(
                      controller: downPaymentController,
                      textAlign: TextAlign.right,
                      labelText: 'الدفعة الأولى',
                      prefixIcon: Icons.account_balance_wallet,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomTextFormField(
                      controller: monthlyInstallmentController,
                      textAlign: TextAlign.right,
                      labelText: 'القسط الشهري',
                      prefixIcon: Icons.calendar_month,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: CustomTextFormField(
                      controller: installmentDurationController,
                      focusNode: durationNode,
                      textAlign: TextAlign.right,
                      labelText: 'مدة التقسيط',
                      prefixIcon: Icons.access_time,
                      keyboardType: TextInputType.number,
                      suffixText: durationNode.hasFocus ||
                              installmentDurationController.text.isNotEmpty
                          ? 'شهر'
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: showNotesDialog,
                      behavior: HitTestBehavior.opaque,
                      child: AbsorbPointer(
                        child: CustomTextFormField(
                          controller: installmentNotesController,
                          textAlign: TextAlign.right,
                          labelText: 'ملاحظات',
                          prefixIcon: Icons.note_alt,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
