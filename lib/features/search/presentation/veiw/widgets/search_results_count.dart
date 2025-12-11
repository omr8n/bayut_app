import 'package:flutter/material.dart';
import 'package:test_graduation/core/utils/colors.dart';

class SearchResultsCount extends StatelessWidget {
  const SearchResultsCount({super.key, required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text(
            'تم العثور على $count عقار',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
