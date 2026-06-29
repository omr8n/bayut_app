import 'package:flutter/material.dart';
import '../../../../../core/language/app_localizations.dart';
import '../../../../../core/language/lang_keys.dart';
import '../../../../../core/utils/colors.dart';

class GuideFooter extends StatelessWidget {
  const GuideFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Column(
          children: [
            Text(
              localizations.translate(LangKeys.haveMoreQuestions),
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            Text(
              localizations.translate(LangKeys.contactTechnicalSupport),
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.underline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
