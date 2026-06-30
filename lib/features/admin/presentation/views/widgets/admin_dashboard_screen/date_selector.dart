import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/features/admin/presentation/manager/admin_cubit.dart';

import 'package:test_graduation/core/language/app_localizations.dart';

class DateSelector extends StatelessWidget {
  const DateSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<AdminCubit>();
    final local = AppLocalizations.of(context)!;
    return InkWell(
      onTap: () async {
        final DateTime? picked = await showDatePicker(
          context: context,
          initialDate: cubit.selectedDate,
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
          locale: Locale(local.locale.languageCode),
        );
        if (picked != null) cubit.getStats(date: picked);
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary.withOpacity(0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "${local.view_data_for}${cubit.selectedDate.day}/${cubit.selectedDate.month}/${cubit.selectedDate.year}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black87,
              ),
            ),
            const Icon(Icons.calendar_month, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
