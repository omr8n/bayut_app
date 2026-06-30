import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';
import 'package:test_graduation/features/admin/presentation/manager/admin_settings_cubit/admin_settings_cubit.dart';
import 'package:test_graduation/features/admin/presentation/manager/admin_settings_cubit/admin_settings_state.dart';
import 'contact_support_widgets/live_contact_preview_card.dart';
import 'contact_support_widgets/contact_info_section.dart';
import 'contact_support_widgets/legal_policies_section.dart';

class ContactSupportSettingsTab extends StatelessWidget {
  const ContactSupportSettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return BlocConsumer<AdminSettingsCubit, AdminSettingsState>(
      listener: _onStateChange,
      builder: (context, state) {
        final cubit = context.read<AdminSettingsCubit>();
        final config = cubit.currentConfig;

        if (config != null) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.only(bottom: 24.h),
            child: Column(
              children: [
                LiveContactPreviewCard(config: config),
                ContactInfoSection(config: config),
              ],
            ),
          );
        }

        if (state is AdminSettingsLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is AdminSettingsFailure) {
          return _buildErrorState(context, local, state.errMessage);
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  void _onStateChange(BuildContext context, AdminSettingsState state) {
    final local = AppLocalizations.of(context)!;
    if (state is AdminSettingsFailure) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.errMessage),
          backgroundColor: Colors.red,
        ),
      );
    }
    if (state is AdminSettingsUpdateSuccess) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(local.translate(LangKeys.saved)),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Widget _buildErrorState(BuildContext context, AppLocalizations local, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(message),
          TextButton(
            onPressed: () => context.read<AdminSettingsCubit>().getSettings(),
            child: Text(local.translate(LangKeys.retry)),
          ),
        ],
      ),
    );
  }
}
