import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';
import 'package:test_graduation/features/admin/presentation/manager/admin_settings_cubit/admin_settings_cubit.dart';
import 'package:test_graduation/features/admin/presentation/manager/admin_settings_cubit/admin_settings_state.dart';
import '../common/settings_section.dart';
import '../common/settings_tile.dart';

class MarketSettingsTab extends StatelessWidget {
  const MarketSettingsTab({super.key});

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
              // 1. Featured Pricing Section (Monthly / Weekly)
              SettingsSection(
                title: local.translate(LangKeys.marketPricingEngine),
                children: [
                  SettingsTile(
                    title: local.translate(LangKeys.monthlyFeaturedPrice),
                    icon: const Icon(Icons.calendar_month_rounded),
                    iconBackgroundColor: const Color(0xFF1E3A8A),
                    onTap: () => _showEditDialog(
                      context,
                      title: local.translate(LangKeys.monthlyFeaturedPrice),
                      initialValue: config.monthlyFeaturedPrice.toString(),
                      onSave: (val) =>
                          cubit.updateMonthlyPrice(double.parse(val)),
                      isNumeric: true,
                    ),
                    trailing: _buildValueText(
                      '${config.monthlyFeaturedPrice} ${config.baseCurrency}',
                    ),
                  ),
                  SettingsTile(
                    title: local.translate(LangKeys.weeklyFeaturedPrice),
                    icon: const Icon(Icons.view_week_rounded),
                    iconBackgroundColor: const Color(0xFF3B82F6),
                    onTap: () => _showEditDialog(
                      context,
                      title: local.translate(LangKeys.weeklyFeaturedPrice),
                      initialValue: config.weeklyFeaturedPrice.toString(),
                      onSave: (val) =>
                          cubit.updateWeeklyPrice(double.parse(val)),
                      isNumeric: true,
                    ),
                    trailing: _buildValueText(
                      '${config.weeklyFeaturedPrice} ${config.baseCurrency}',
                    ),
                  ),
                  SettingsTile(
                    title: local.translate(LangKeys.baseCurrency),
                    icon: const Icon(Icons.monetization_on_rounded),
                    iconBackgroundColor: const Color(0xFF60A5FA),
                    showDivider: false,
                    onTap: () => _showEditDialog(
                      context,
                      title: local.translate(LangKeys.baseCurrency),
                      initialValue: config.baseCurrency,
                      onSave: (val) => cubit.updateMarketLimits(currency: val),
                    ),
                    trailing: _buildValueText(config.baseCurrency),
                  ),
                ],
              ),

              // 2. Listing Limits Section
              SettingsSection(
                title: local.translate(LangKeys.marketStatus),
                children: [
                  SettingsTile(
                    title: local.translate(LangKeys.freePropertyLimit),
                    icon: const Icon(Icons.countertops_rounded),
                    iconBackgroundColor: const Color(0xFF10B981),
                    onTap: () => _showEditDialog(
                      context,
                      title: local.translate(LangKeys.freePropertyLimit),
                      initialValue: config.freePropertyLimitPerDay.toString(),
                      onSave: (val) =>
                          cubit.updateMarketLimits(freeLimit: int.parse(val)),
                      isNumeric: true,
                    ),
                    trailing: _buildValueText(
                      config.freePropertyLimitPerDay.toString(),
                    ),
                  ),
                  SettingsTile(
                    title: local.translate(LangKeys.extraPropertyPrice),
                    icon: const Icon(Icons.add_card_rounded),
                    iconBackgroundColor: const Color(0xFFF59E0B),
                    showDivider: false,
                    onTap: () => _showEditDialog(
                      context,
                      title: local.translate(LangKeys.extraPropertyPrice),
                      initialValue: config.extraPropertyPrice.toString(),
                      onSave: (val) => cubit.updateMarketLimits(
                        extraPrice: double.parse(val),
                      ),
                      isNumeric: true,
                    ),
                    trailing: _buildValueText(
                      '${config.extraPropertyPrice} ${config.baseCurrency}',
                    ),
                  ),
                ],
              ),

              // 3. Media Limits Section
              SettingsSection(
                title: local.translate(LangKeys.mediaLimits),
                children: [
                  SettingsTile(
                    title: local.translate(LangKeys.maxImages),
                    icon: const Icon(Icons.image_rounded),
                    iconBackgroundColor: const Color(0xFF8B5CF6),
                    onTap: () => _showEditDialog(
                      context,
                      title: local.translate(LangKeys.maxImages),
                      initialValue: config.maxImagesPerProperty.toString(),
                      onSave: (val) =>
                          cubit.updateMarketLimits(maxImages: int.parse(val)),
                      isNumeric: true,
                    ),
                    trailing: _buildValueText(
                      local
                          .translate(LangKeys.imagesCount)
                          .replaceFirst(
                            '{count}',
                            config.maxImagesPerProperty.toString(),
                          ),
                    ),
                  ),
                  SettingsTile(
                    title: local.translate(LangKeys.maxVideos),
                    icon: const Icon(Icons.video_collection_rounded),
                    iconBackgroundColor: const Color(0xFFEC4899),
                    showDivider: false,
                    onTap: () => _showEditDialog(
                      context,
                      title: local.translate(LangKeys.maxVideos),
                      initialValue: config.maxVideosPerProperty.toString(),
                      onSave: (val) =>
                          cubit.updateMarketLimits(maxVideos: int.parse(val)),
                      isNumeric: true,
                    ),
                    trailing: _buildValueText(
                      local
                          .translate(LangKeys.videosCount)
                          .replaceFirst(
                            '{count}',
                            config.maxVideosPerProperty.toString(),
                          ),
                    ),
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
        Icon(
          Icons.arrow_back_ios_new,
          size: 10.sp,
          color: const Color(0xFF9EA3AE),
        ),
        SizedBox(width: 8.w),
        Text(
          value,
          style: TextStyle(
            fontSize: 13.sp,
            color: const Color(0xFF1E3A8A),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  void _showEditDialog(
    BuildContext context, {
    required String title,
    required String initialValue,
    required Function(String) onSave,
    bool isNumeric = false,
  }) {
    final controller = TextEditingController(text: initialValue);
    final local = AppLocalizations.of(
      context,
    )!; // 🔥 تعريف الـ local داخل الدالة لإصلاح الخطأ
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Text(title, style: TextStyle(fontSize: 16.sp)),
        content: TextField(
          controller: controller,
          keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(foregroundColor: Colors.grey.shade600),
            child: Text(local.translate(LangKeys.cancel)),
          ),
          ElevatedButton(
            onPressed: () {
              final val = controller.text.trim();
              if (val.isNotEmpty) {
                // استخدام tryParse لضمان عدم حدوث Crash إذا كان الإدخال غير صحيح
                if (isNumeric) {
                  final numVal = double.tryParse(val);
                  if (numVal != null) onSave(val);
                } else {
                  onSave(val);
                }
              }
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E3A8A),
              foregroundColor: Colors.white,
              elevation: 2,
              shadowColor: const Color(0xFF1E3A8A).withValues(alpha: 0.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            child: Text(
              local.translate(LangKeys.save),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
