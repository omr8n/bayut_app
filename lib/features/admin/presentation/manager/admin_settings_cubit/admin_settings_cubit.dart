import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_graduation/core/models/app_config_model.dart';
import 'package:test_graduation/features/admin/domain/repos/app_settings_repo.dart';
import 'admin_settings_state.dart';

class AdminSettingsCubit extends Cubit<AdminSettingsState> {
  final AppSettingsRepo appSettingsRepo;
  StreamSubscription? _settingsSubscription;

  AdminSettingsCubit(this.appSettingsRepo) : super(AdminSettingsInitial());

  AppConfigModel? currentConfig;

  Future<void> getSettings() async {
    emit(AdminSettingsLoading());

    // إلغاء الاشتراك السابق إن وجد
    await _settingsSubscription?.cancel();

    // الاستماع للتغييرات بشكل مباشر
    _settingsSubscription = appSettingsRepo.watchAppSettings().listen(
      (result) {
        if (isClosed) return;
        result.fold(
          (failure) {
            if (!isClosed) emit(AdminSettingsFailure(failure.message));
          },
          (config) {
            currentConfig = config;
            if (!isClosed) emit(AdminSettingsLoaded(config));
          },
        );
      },
      onError: (e) {
        if (!isClosed) emit(AdminSettingsFailure(e.toString()));
      },
    );
  }

  @override
  Future<void> close() {
    _settingsSubscription?.cancel();
    return super.close();
  }

  // تحديث الإعدادات محلياً فقط (Draft)
  void updateConfigLocally(AppConfigModel config) {
    currentConfig = config;
    if (!isClosed) emit(AdminSettingsLoaded(config));
  }

  // حفظ كل التغييرات لقاعدة البيانات
  Future<void> saveAllSettings() async {
    if (currentConfig == null) return;
    if (!isClosed) emit(AdminSettingsLoading());
    final result = await appSettingsRepo.updateAppSettings(currentConfig!);
    if (isClosed) return;
    result.fold(
      (failure) {
        if (!isClosed) emit(AdminSettingsFailure(failure.message));
      },
      (_) {
        if (!isClosed) emit(AdminSettingsUpdateSuccess());
        if (!isClosed) emit(AdminSettingsLoaded(currentConfig!));
      },
    );
  }

  // Helper method to update specific fields locally
  void updateContactInfo({
    String? email,
    String? phone,
    String? whatsapp,
    String? facebook,
    String? instagram,
  }) {
    if (currentConfig == null) return;

    final updatedConfig = currentConfig!.copyWith(
      contactEmail: email,
      contactPhone: phone,
      whatsappNumber: whatsapp,
      facebookUrl: facebook,
      instagramUrl: instagram,
    );

    updateConfigLocally(updatedConfig);
  }

  // Pre-fill contact info from currently logged-in Admin profile
  void fillInfoFromAdmin({
    required String email,
    required String phone,
  }) {
    if (currentConfig == null) return;

    // Clean phone number to start with 09
    String cleanPhone = phone.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanPhone.startsWith('963')) {
      cleanPhone = cleanPhone.substring(3);
    }
    if (!cleanPhone.startsWith('09')) {
      if (cleanPhone.startsWith('9')) {
        cleanPhone = '0$cleanPhone';
      }
    }

    final updatedConfig = currentConfig!.copyWith(
      contactEmail: email,
      contactPhone: cleanPhone,
      whatsappNumber: cleanPhone,
    );

    updateConfigLocally(updatedConfig);
  }

  // Smart Pricing Logic: Update Monthly and calculate Weekly (33%) locally
  void updateMonthlyPrice(double monthlyPrice) {
    if (currentConfig == null) return;

    // Calculate weekly: 33% of monthly, rounded to nearest 100
    double weeklyPrice = (monthlyPrice * 0.33 / 100).roundToDouble() * 100;

    final updatedConfig = currentConfig!.copyWith(
      monthlyFeaturedPrice: monthlyPrice,
      weeklyFeaturedPrice: weeklyPrice,
    );

    updateConfigLocally(updatedConfig);
  }

  // Smart Pricing Logic: Update Weekly and calculate Monthly (Weekly / 0.33) locally
  void updateWeeklyPrice(double weeklyPrice) {
    if (currentConfig == null) return;

    // Calculate monthly: weekly / 0.33, rounded to nearest 100
    double monthlyPrice = (weeklyPrice / 0.33 / 100).roundToDouble() * 100;

    final updatedConfig = currentConfig!.copyWith(
      monthlyFeaturedPrice: monthlyPrice,
      weeklyFeaturedPrice: weeklyPrice,
    );

    updateConfigLocally(updatedConfig);
  }

  void updateMarketLimits({
    int? freeLimit,
    double? extraPrice,
    int? maxImages,
    int? maxVideos,
    String? currency,
  }) {
    if (currentConfig == null) return;

    final updatedConfig = currentConfig!.copyWith(
      freePropertyLimitPerDay: freeLimit,
      extraPropertyPrice: extraPrice,
      maxImagesPerProperty: maxImages,
      maxVideosPerProperty: maxVideos,
      baseCurrency: currency,
    );

    updateConfigLocally(updatedConfig);
  }
}
