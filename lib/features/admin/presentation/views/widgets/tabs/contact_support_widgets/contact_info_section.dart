import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';
import 'package:test_graduation/core/models/app_config_model.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/features/admin/presentation/manager/admin_settings_cubit/admin_settings_cubit.dart';
import 'package:test_graduation/features/auth/domain/entites/user_entity.dart';
import 'package:test_graduation/features/profile/presentation/manager/profile_cubit/profile_cubit.dart';
import '../../common/settings_section.dart';
import '../../common/settings_tile.dart';
import 'contact_edit_dialog.dart';

class ContactInfoSection extends StatelessWidget {
  final AppConfigModel config;

  const ContactInfoSection({super.key, required this.config});

  void _showEditDialog(
    BuildContext context,
    String title,
    String initialValue,
    Function(String) onSave,
  ) {
    showDialog(
      context: context,
      builder: (_) => ContactEditDialog(
        title: title,
        initialValue: initialValue,
        onSave: onSave,
      ),
    );
  }

  void _fillFromAdmin(BuildContext context) {
    final profileCubit = context.read<ProfileCubit>();
    final UserEntity? user = profileCubit.user;
    if (user != null) {
      context.read<AdminSettingsCubit>().fillInfoFromAdmin(
        email: user.email,
        phone: user.phoneNumber ?? '',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    final cubit = context.read<AdminSettingsCubit>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SettingsSection(
      title: local.translate(LangKeys.contactAndSupport),
      headerAction: TextButton.icon(
        onPressed: () => _fillFromAdmin(context),
        icon: Icon(
          Icons.person_pin_rounded,
          size: 16.sp,
          color: AppColors.primary,
        ),
        label: Text(
          local.translate(LangKeys.fillFromProfile),
          style: TextStyle(
            fontSize: 11.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
            fontFamily: 'Cairo',
          ),
        ),
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          visualDensity: VisualDensity.compact,
        ),
      ),
      children: [
        // 1. Email Support (Required)
        _buildContactTile(
          context: context,
          title: "${local.translate(LangKeys.supportEmailLabel)} *",
          value: config.contactEmail.isEmpty
              ? (local.isEnLocale ? "Not set" : "غير محدد")
              : config.contactEmail,
          icon: Icons.email_rounded,
          iconColor: const Color(0xFF5C6BC0),
          onTap: () => _showEditDialog(
            context,
            local.translate(LangKeys.supportEmailLabel),
            config.contactEmail,
            (val) => cubit.updateContactInfo(email: val),
          ),
        ),
        // 2. Phone Support (Required)
        _buildContactTile(
          context: context,
          title: "${local.translate(LangKeys.supportPhoneLabel)} *",
          value: config.contactPhone.isEmpty
              ? (local.isEnLocale ? "Not set" : "غير محدد")
              : config.contactPhone,
          icon: Icons.phone_android_rounded,
          iconColor: const Color(0xFF42A5F5),
          onTap: () => _showEditDialog(
            context,
            local.translate(LangKeys.supportPhoneLabel),
            config.contactPhone,
            (val) => cubit.updateContactInfo(phone: val),
          ),
        ),
        // 3. WhatsApp Support (Required)
        _buildContactTile(
          context: context,
          title: "${local.translate(LangKeys.whatsappNumber)} *",
          value: config.whatsappNumber.isEmpty
              ? (local.isEnLocale ? "Not set" : "غير محدد")
              : config.whatsappNumber,
          icon: Icons.chat_rounded,
          iconColor: Colors.green,
          onTap: () => _showEditDialog(
            context,
            local.translate(LangKeys.whatsappNumber),
            config.whatsappNumber,
            (val) => cubit.updateContactInfo(whatsapp: val),
          ),
        ),
        // 4. Facebook Link (Optional)
        _buildContactTile(
          context: context,
          title: "Facebook Link",
          value: config.facebookUrl.isEmpty
              ? (local.isEnLocale ? "Optional - Not set" : "اختياري - غير محدد")
              : config.facebookUrl,
          icon: Icons.facebook_rounded,
          iconColor: const Color(0xFF1877F2),
          onTap: () => _showEditDialog(
            context,
            "Facebook Link",
            config.facebookUrl,
            (val) => cubit.updateContactInfo(facebook: val),
          ),
        ),
        // 5. Instagram Link (Optional)
        _buildContactTile(
          context: context,
          title: "Instagram Link",
          value: config.instagramUrl.isEmpty
              ? (local.isEnLocale ? "Optional - Not set" : "اختياري - غير محدد")
              : config.instagramUrl,
          icon: Icons.camera_alt_rounded,
          iconColor: const Color(0xFFE4405F),
          showDivider: false,
          onTap: () => _showEditDialog(
            context,
            "Instagram Link",
            config.instagramUrl,
            (val) => cubit.updateContactInfo(instagram: val),
          ),
        ),
      ],
    );
  }

  Widget _buildContactTile({
    required BuildContext context,
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
    VoidCallback? onTap,
    bool showDivider = true,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              children: [
                Icon(Icons.arrow_back_ios_new, size: 10.sp, color: Colors.grey.shade300),
                const Spacer(),
                Expanded(
                  flex: 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        value,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: isDark ? Colors.white70 : Colors.grey.shade500,
                          fontFamily: 'Cairo',
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16.w),
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(icon, color: iconColor, size: 20.sp),
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Divider(height: 1, color: isDark ? Colors.white12 : Colors.grey.shade100),
          ),
      ],
    );
  }
}
