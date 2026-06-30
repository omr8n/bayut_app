import 'package:flutter/material.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';
import '../../../../../core/utils/colors.dart';

class TermsFooter extends StatelessWidget {
  const TermsFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            const Divider(indent: 50, endIndent: 50),
            const SizedBox(height: 10),
            Text(
              localizations.translate(LangKeys.lastUpdate).replaceFirst('{date}', '2024'),
              style: TextStyle(
                color: Theme.of(context).brightness == Brightness.dark ? AppColors.textSecondaryDark.withOpacity(0.6) : AppColors.textSecondary.withOpacity(0.6),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
