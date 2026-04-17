import 'package:flutter/material.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'widgets/profile_sliver_app_bar.dart';
import 'widgets/terms_footer.dart';
import 'widgets/terms_introduction.dart';
import 'widgets/terms_list.dart';

class TermsView extends StatelessWidget {
  const TermsView({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          ProfileSliverAppBar(
            title: localizations.translate(LangKeys.termsOfUse),
            icon: Icons.gavel_rounded,
          ),
          const TermsIntroduction(),
          const TermsList(),
          const TermsFooter(),
        ],
      ),
    );
  }
}
