import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';
import 'package:test_graduation/core/models/app_config_model.dart';
import '../../common/settings_section.dart';
import '../../common/settings_tile.dart';

class LegalPoliciesSection extends StatelessWidget {
  final AppConfigModel config;

  const LegalPoliciesSection({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;

    return SettingsSection(
      title: local.translate(LangKeys.legalPolicies),
      children: [
        SettingsTile(
          title: local.translate(LangKeys.termsOfUseEdit),
          subtitle: local.translate(LangKeys.termsOfUseEditDesc),
          icon: const Icon(Icons.gavel_rounded),
          iconBackgroundColor: const Color(0xFF455A64),
          onTap: () {
            // Future implementation for editing terms
          },
          trailing: Icon(
            Icons.arrow_back_ios_new,
            size: 12.sp,
            color: const Color(0xFF9EA3AE),
          ),
        ),
        SettingsTile(
          title: local.translate(LangKeys.privacyPolicyEdit),
          subtitle: local.translate(LangKeys.privacyPolicyEditDesc),
          icon: const Icon(Icons.privacy_tip_rounded),
          iconBackgroundColor: const Color(0xFF607D8B),
          showDivider: false,
          onTap: () {
            // Future implementation for editing privacy policy
          },
          trailing: Icon(
            Icons.arrow_back_ios_new,
            size: 12.sp,
            color: const Color(0xFF9EA3AE),
          ),
        ),
      ],
    );
  }
}
