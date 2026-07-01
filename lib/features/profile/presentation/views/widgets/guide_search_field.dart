import 'package:flutter/material.dart';
import '../../../../../core/language/app_localizations.dart';
import '../../../../../core/language/lang_keys.dart';
import '../../../../../core/utils/colors.dart';

class GuideSearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const GuideSearchField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(
                context,
              )!.translate(LangKeys.searchYourQuestion),
              prefixIcon: const Icon(Icons.search, color: AppColors.primary),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 15),
            ),
          ),
        ),
      ),
    );
  }
}
