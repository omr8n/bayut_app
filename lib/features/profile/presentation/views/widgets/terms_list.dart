import 'package:flutter/material.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';
import 'package:test_graduation/features/profile/presentation/views/widgets/term_section.dart';

class TermsList extends StatelessWidget {
  const TermsList({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> terms = [
      {
        'titleKey': LangKeys.term1Title,
        'contentKey': LangKeys.term1Content,
        'icon': Icons.edit_note_rounded,
      },
      {
        'titleKey': LangKeys.term2Title,
        'contentKey': LangKeys.term2Content,
        'icon': Icons.gavel_rounded,
      },
      {
        'titleKey': LangKeys.term3Title,
        'contentKey': LangKeys.term3Content,
        'icon': Icons.payments_rounded,
      },
      {
        'titleKey': LangKeys.term4Title,
        'contentKey': LangKeys.term4Content,
        'icon': Icons.security_rounded,
      },
      {
        'titleKey': LangKeys.term5Title,
        'contentKey': LangKeys.term5Content,
        'icon': Icons.category_rounded,
      },
      {
        'titleKey': LangKeys.term6Title,
        'contentKey': LangKeys.term6Content,
        'icon': Icons.update_rounded,
      },
    ];

    final locale = AppLocalizations.of(context)!;
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final term = terms[index];
        return TermSection(
          title: locale.translate(term['titleKey']),
          content: locale.translate(term['contentKey']),
          icon: term['icon'],
        );
      }, childCount: terms.length),
    );
  }
}
