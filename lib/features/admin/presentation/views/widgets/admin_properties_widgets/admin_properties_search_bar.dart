import 'package:flutter/material.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/utils/colors.dart';

class AdminPropertiesSearchBar extends StatelessWidget {
  const AdminPropertiesSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppColors.background,
      child: TextField(
        onChanged: (value) {
          // TODO: Implement search logic in Cubit
        },
        decoration: InputDecoration(
          hintText: local.search_property_hint,
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
