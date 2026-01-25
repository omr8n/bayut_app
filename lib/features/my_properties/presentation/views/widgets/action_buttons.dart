import 'package:flutter/material.dart';
import 'package:test_graduation/core/widgets/custom_primary_button.dart';

class ActionButtons extends StatelessWidget {
  final VoidCallback onSubmit;

  const ActionButtons({super.key, required this.onSubmit});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text('إلغاء'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: CustomPriamryButton(
            onPressed: onSubmit,
            title: 'إضافة العقار',
          ),
        ),
      ],
    );
  }
}
