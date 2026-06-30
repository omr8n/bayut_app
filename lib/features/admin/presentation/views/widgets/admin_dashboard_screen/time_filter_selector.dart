import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/features/admin/presentation/manager/admin_cubit.dart';

import 'package:test_graduation/core/language/app_localizations.dart';

class TimeFilterSelector extends StatelessWidget {
  const TimeFilterSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<AdminCubit>();
    final local = AppLocalizations.of(context)!;
    final filters = [
      {'key': 'day', 'label': local.day_filter},
      {'key': 'week', 'label': local.week_filter},
      {'key': 'month', 'label': local.month_filter},
      {'key': 'year', 'label': local.year_filter},
    ];
    return Container(
      height: 45,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: filters.map((f) {
          bool isSelected = cubit.currentFilter == f['key'];
          return Expanded(
            child: GestureDetector(
              onTap: () => cubit.getStats(filter: f['key'] as String),
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  f['label'] as String,
                  style: TextStyle(
                    color: isSelected ? Colors.white : (Theme.of(context).brightness == Brightness.dark ? AppColors.textSecondaryDark : Colors.grey[600]),
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
