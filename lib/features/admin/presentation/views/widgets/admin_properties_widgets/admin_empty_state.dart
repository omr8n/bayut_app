import 'package:flutter/material.dart';
import 'package:test_graduation/core/utils/colors.dart';

class AdminEmptyState extends StatelessWidget {
  const AdminEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.home_work_outlined, size: 80, color: AppColors.textLight),
          const SizedBox(height: 16),
          Text(
            'لا توجد عقارات',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
