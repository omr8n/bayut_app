import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';
import 'package:test_graduation/core/models/app_config_model.dart';
import 'package:test_graduation/features/admin/presentation/manager/admin_settings_cubit/admin_settings_cubit.dart';
import '../../common/settings_section.dart';
import '../../common/settings_tile.dart';
import 'contact_edit_dialog.dart';
import 'social_links_dialog.dart';

class ContactInfoSection extends StatelessWidget {
  final AppConfigModel config;

  const ContactInfoSection({super.key, required this.config});

  void _showEditDialog(BuildContext context, String title, String initialValue, Function(String) onSave) {
    showDialog(
      context: context,
      builder: (_) => ContactEditDialog(
        title: title,
        initialValue: initialValue,
        onSave: onSave,
      ),
    );
  }

  void _showSocialLinksDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => SocialLinksDialog(
        initialFacebook: config.facebookUrl,
        initialInstagram: config.instagramUrl,
        onSave: (fb, insta) => context.read<AdminSettingsCubit>().updateContactInfo(
              facebook: fb,
              instagram: insta,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    final cubit = context.read<AdminSettingsCubit>();

    return SettingsSection(
      title: local.translate(LangKeys.contactAndSupport),
      children: [
        // الدعم عبر الإيميل
        SettingsTile(
          title: local.translate(LangKeys.supportEmailLabel),
          subtitle: config.contactEmail.isEmpty ? (local.isEnLocale ? "Not set" : "غير محدد") : config.contactEmail,
          icon: const Icon(Icons.email_rounded),
          iconBackgroundColor: const Color(0xFF5C6BC0),
          onTap: () => _showEditDialog(
            context,
            local.translate(LangKeys.supportEmailLabel),
            config.contactEmail,
            (val) => cubit.updateContactInfo(email: val),
          ),
        ),
        // هاتف الدعم (عادي)
        SettingsTile(
          title: local.translate(LangKeys.supportPhoneLabel),
          subtitle: config.contactPhone.isEmpty ? (local.isEnLocale ? "Not set" : "غير محدد") : config.contactPhone,
          icon: const Icon(Icons.phone_android_rounded),
          iconBackgroundColor: const Color(0xFF42A5F5),
          onTap: () => _showEditDialog(
            context,
            local.translate(LangKeys.supportPhoneLabel),
            config.contactPhone,
            (val) => cubit.updateContactInfo(phone: val),
          ),
        ),
        // رقم واتساب
        SettingsTile(
          title: local.translate(LangKeys.whatsappNumber),
          subtitle: config.whatsappNumber.isEmpty ? (local.isEnLocale ? "Not set" : "غير محدد") : config.whatsappNumber,
          icon: const Icon(Icons.chat_rounded),
          iconBackgroundColor: Colors.green,
          onTap: () => _showEditDialog(
            context,
            local.translate(LangKeys.whatsappNumber),
            config.whatsappNumber,
            (val) => cubit.updateContactInfo(whatsapp: val),
          ),
        ),
        // رابط فيسبوك
        SettingsTile(
          title: "Facebook URL",
          subtitle: config.facebookUrl.isEmpty ? (local.isEnLocale ? "Not set" : "غير محدد") : config.facebookUrl,
          icon: const Icon(Icons.facebook_rounded),
          iconBackgroundColor: const Color(0xFF1877F2),
          onTap: () => _showEditDialog(
            context,
            "Facebook URL",
            config.facebookUrl,
            (val) => cubit.updateContactInfo(facebook: val),
          ),
        ),
        // رابط انستجرام
        SettingsTile(
          title: "Instagram URL",
          subtitle: config.instagramUrl.isEmpty ? (local.isEnLocale ? "Not set" : "غير محدد") : config.instagramUrl,
          icon: const Icon(Icons.camera_alt_rounded),
          iconBackgroundColor: const Color(0xFFE4405F),
          showDivider: false,
          onTap: () => _showEditDialog(
            context,
            "Instagram URL",
            config.instagramUrl,
            (val) => cubit.updateContactInfo(instagram: val),
          ),
        ),
      ],
    );
  }
}
