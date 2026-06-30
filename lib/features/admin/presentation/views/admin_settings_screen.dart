import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_graduation/core/widgets/loading_manager.dart';
import 'package:test_graduation/features/admin/presentation/manager/admin_settings_cubit/admin_settings_cubit.dart';
import 'package:test_graduation/features/admin/presentation/manager/admin_settings_cubit/admin_settings_state.dart';
import 'widgets/tabs/platform_settings_tab.dart';
import 'widgets/tabs/market_settings_tab.dart';
import 'widgets/tabs/property_data_settings_tab.dart';
import 'widgets/tabs/contact_support_settings_tab.dart';

class AdminSettingsScreen extends StatelessWidget {
  const AdminSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return BlocBuilder<AdminSettingsCubit, AdminSettingsState>(
      builder: (context, state) {
        return BlocListener<AdminSettingsCubit, AdminSettingsState>(
          listener: (context, state) {
            if (state is AdminSettingsUpdateSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.check_circle_outline, color: Colors.white),
                      SizedBox(width: 12.w),
                      Text(local.translate(LangKeys.updateSuccess)),
                    ],
                  ),
                  backgroundColor: Colors.green.shade600,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.r)),
                  margin: EdgeInsets.all(16.w),
                  duration: const Duration(seconds: 3),
                ),
              );
            }
            if (state is AdminSettingsFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.errMessage), backgroundColor: Colors.red),
              );
            }
          },
          child: LoadingManager(
            isLoading: state is AdminSettingsLoading,
            child: DefaultTabController(
              length: 4,
              initialIndex: 0,
              child: Scaffold(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                appBar: AppBar(
                  backgroundColor: Theme.of(context).brightness == Brightness.dark ? AppColors.darkBackground : Colors.white,
                  elevation: 0.5,
                  centerTitle: true,
                  automaticallyImplyLeading: false,
                  leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                      size: 20,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  actions: [
                    Padding(
                      padding: EdgeInsetsDirectional.only(end: 8.w),
                      child: TextButton.icon(
                        onPressed: () => context.read<AdminSettingsCubit>().saveAllSettings(),
                        icon: Icon(Icons.save_rounded, size: 18.sp, color: AppColors.primary),
                        label: Text(
                          local.translate(LangKeys.save),
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',
                            color: AppColors.primary,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            side: BorderSide(color: AppColors.primary.withOpacity(0.1)),
                          ),
                        ),
                      ),
                    ),
                  ],
                  title: Text(
                    local.translate(LangKeys.adminSettingsTitle),
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  bottom: TabBar(
                    isScrollable: true,
                    indicatorColor: AppColors.primary,
                    indicatorWeight: 3,
                    labelColor: Theme.of(context).brightness == Brightness.dark ? Colors.white : AppColors.primary,
                    unselectedLabelColor: const Color(0xFF9EA3AE),
                    labelStyle: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                    ),
                    unselectedLabelStyle: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.normal,
                    ),
                    tabs: [
                      Tab(
                        text: local.translate(LangKeys.platform),
                        icon: const Icon(Icons.tune_rounded),
                      ),
                      Tab(
                        text: local.translate(LangKeys.market),
                        icon: const Icon(Icons.shopping_bag_outlined),
                      ),
                      Tab(
                        text: local.translate(LangKeys.propertyData),
                        icon: const Icon(Icons.home_work_outlined),
                      ),
                      Tab(
                        text: local.translate(LangKeys.contactAndSupport),
                        icon: const Icon(Icons.gavel_rounded),
                      ),
                    ],
                  ),
                ),
                body: const TabBarView(
                  children: [
                    PlatformSettingsTab(),
                    MarketSettingsTab(),
                    PropertyDataSettingsTab(),
                    ContactSupportSettingsTab(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
