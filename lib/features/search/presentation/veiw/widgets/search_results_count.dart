import 'package:flutter/material.dart';
import 'package:test_graduation/core/utils/colors.dart';

class SearchResultsCount extends StatelessWidget {
  const SearchResultsCount({super.key, required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(Icons.search_rounded, size: 18, color: AppColors.textSecondary.withOpacity(0.7)),
          const SizedBox(width: 8),
          Text(
            _formatCountText(count),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  String _formatCountText(int n) {
    if (n == 0) return 'لا توجد نتائج';
    if (n == 1) return 'تم العثور على عقار واحد';
    if (n == 2) return 'تم العثور على عقارين';
    if (n >= 3 && n <= 10) return 'تم العثور على $n عقارات';
    return 'تم العثور على $n عقار';
  }
}
