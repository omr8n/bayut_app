import 'package:flutter/material.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';

class TermsIntroduction extends StatelessWidget {
  const TermsIntroduction({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
            ),
          ),
          child: Text(
            localizations.translate(LangKeys.termsIntroduction),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              height: 1.6,
              color: Theme.of(context).textTheme.bodyLarge?.color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
