import 'package:flutter/material.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';
import '../common/admin_settings_placeholder.dart';

class PropertyDataSettingsTab extends StatelessWidget {
  const PropertyDataSettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return AdminSettingsPlaceholder(
      title: local.translate(LangKeys.propertyData),
      icon: Icons.edit_note_outlined,
    );
  }
}
