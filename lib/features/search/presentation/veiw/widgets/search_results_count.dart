import 'package:flutter/material.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';
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
          Icon(Icons.search_rounded,
              size: 18, color: AppColors.textSecondary.withOpacity(0.7)),
          const SizedBox(width: 8),
          Text(
            _formatCountText(context, count),
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

  String _formatCountText(BuildContext context, int n) {
    final localizations = AppLocalizations.of(context)!;
    if (n == 0) return localizations.translate(LangKeys.noResults);
    if (n == 1) return localizations.translate(LangKeys.propertyFound);
    if (n == 2) return localizations.translate(LangKeys.twoPropertiesFound);
    if (n >= 3 && n <= 10) {
      return localizations.translate(LangKeys.propertiesFoundCount).replaceAll('{count}', n.toString());
    }
    return localizations.translate(LangKeys.propertyFoundCount).replaceAll('{count}', n.toString());
  }
}
