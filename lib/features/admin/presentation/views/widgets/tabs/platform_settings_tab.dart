import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';
import 'package:test_graduation/features/admin/presentation/manager/admin_settings_cubit/admin_settings_cubit.dart';
import 'package:test_graduation/features/admin/presentation/manager/admin_settings_cubit/admin_settings_state.dart';
import '../common/settings_section.dart';
import '../common/settings_tile.dart';
import '../common/settings_switch_tile.dart';
import 'contact_support_widgets/contact_edit_dialog.dart';

class PlatformSettingsTab extends StatelessWidget {
  const PlatformSettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return BlocBuilder<AdminSettingsCubit, AdminSettingsState>(
      builder: (context, state) {
        final cubit = context.read<AdminSettingsCubit>();
        final config = cubit.currentConfig;

        if (config == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(bottom: 24.h),
          child: Column(
            children: [
              SettingsSection(
                title: local.translate(LangKeys.basicControl),
                children: [
                  SettingsSwitchTile(
                    title: local.translate(LangKeys.maintenanceMode),
                    subtitle: local.translate(LangKeys.maintenanceModeDesc),
                    icon: const Icon(Icons.build_rounded),
                    iconBackgroundColor: const Color(0xFFFFB74D),
                    value: config.maintenanceMode,
                    onChanged: (val) {
                      _showMaintenanceConfirmation(context, val, config, cubit);
                    },
                  ),
                  SettingsSwitchTile(
                    title: local.translate(LangKeys.generalNotifications),
                    subtitle: local.translate(LangKeys.generalNotificationsDesc),
                    icon: const Icon(Icons.notifications_active_rounded),
                    iconBackgroundColor: const Color(0xFF90CAF9),
                    showDivider: false,
                    value: false, // This could be tied to another config field if needed
                    onChanged: (val) {},
                  ),
                ],
              ),
              SettingsSection(
                title: local.translate(LangKeys.platformIdentity),
                children: [
                  SettingsTile(
                    title: local.translate(LangKeys.appNameLabel),
                    icon: const Icon(Icons.app_registration_rounded),
                    iconBackgroundColor: const Color(0xFF5C6BC0),
                    onTap: () => _showEditDialog(
                      context,
                      title: local.translate(LangKeys.appNameLabel),
                      initialValue: config.appName,
                      onSave: (val) {
                        final updated = config.copyWith(appName: val);
                        cubit.updateConfigLocally(updated);
                      },
                    ),
                    trailing: _buildValueText(config.appName),
                  ),
                  SettingsTile(
                    title: local.translate(LangKeys.systemVersion),
                    icon: const Icon(Icons.info_outline_rounded),
                    iconBackgroundColor: const Color(0xFF4FC3F7),
                    showDivider: false,
                    onTap: () => _showEditDialog(
                      context,
                      title: local.translate(LangKeys.systemVersion),
                      initialValue: config.appVersion,
                      onSave: (val) {
                        final updated = config.copyWith(appVersion: val);
                        cubit.updateConfigLocally(updated);
                      },
                    ),
                    trailing: _buildValueText(config.appVersion),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildValueText(String value) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.arrow_back_ios_new, size: 10.sp, color: const Color(0xFF9EA3AE)),
        SizedBox(width: 8.w),
        Text(
          value,
          style: TextStyle(
            fontSize: 13.sp,
            color: const Color(0xFF1E3A8A),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  void _showMaintenanceConfirmation(
    BuildContext context,
    bool newValue,
    dynamic config,
    AdminSettingsCubit cubit,
  ) {
    final local = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        title: Row(
          children: [
            Icon(
              newValue ? Icons.warning_amber_rounded : Icons.info_outline_rounded,
              color: newValue ? Colors.orange : Colors.blue,
            ),
            SizedBox(width: 10.w),
            Text(
              newValue ? "تفعيل وضع الصيانة" : "إيقاف وضع الصيانة",
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Text(
          newValue
              ? "هل أنت متأكد من تفعيل وضع الصيانة؟ هذا سيؤدي لمنع جميع المستخدمين من دخول التطبيق حالاً."
              : "هل أنت متأكد من إيقاف وضع الصيانة؟ التطبيق سيعود متاحاً لجميع المستخدمين.",
          style: TextStyle(fontSize: 14.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(local.translate(LangKeys.cancel)),
          ),
          ElevatedButton(
            onPressed: () {
              final updated = config.copyWith(maintenanceMode: newValue);
              cubit.updateConfigLocally(updated);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: newValue ? Colors.orange : const Color(0xFF1E3A8A),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
            ),
            child: Text(
              local.translate(LangKeys.save),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(
    BuildContext context, {
    required String title,
    required String initialValue,
    required Function(String) onSave,
  }) {
    showDialog(
      context: context,
      builder: (_) => ContactEditDialog(
        title: title,
        initialValue: initialValue,
        onSave: onSave,
      ),
    );
  }
}
