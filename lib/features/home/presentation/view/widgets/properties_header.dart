import 'package:flutter/material.dart';
import 'package:test_graduation/core/utils/colors.dart';

class PropertiesHeader extends StatelessWidget {
  const PropertiesHeader({
    super.key,
    required this.title,
    required this.onViewAll,
  });
  final String title;
  final VoidCallback onViewAll;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          GestureDetector(
            onTap: onViewAll,
            child: Text(
              'عرض الكل',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
