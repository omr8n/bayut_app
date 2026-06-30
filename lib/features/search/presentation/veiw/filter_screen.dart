import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:test_graduation/core/enums/property_enums.dart';
import 'package:test_graduation/core/services/shared_preferences_singleton.dart';
import 'package:test_graduation/features/root/presentation/manager/navigation_cubit.dart';
import 'package:test_graduation/features/root/presentation/views/root_view.dart';
import '../manager/search_cubit/search_cubit.dart';
import 'widgets/filter_form.dart';

import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';

class FilterScreen extends StatelessWidget {
  final String? initialGovernorate;
  const FilterScreen({super.key, this.initialGovernorate});

  @override
  Widget build(BuildContext context) {
    final searchCubit = context.read<SearchCubit>();
    final locale = AppLocalizations.of(context);
    final String allText = locale!.translate(LangKeys.all);

    // 🎯 استعادة الموقع بذكاء
    final String? location =
        initialGovernorate ??
        searchCubit.currentGovernorate ??
        Prefs.getString('user_location');

    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark ? Colors.white : Colors.black,
            textDirection: locale.isEnLocale
                ? TextDirection.ltr
                : TextDirection.rtl,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          locale.translate(LangKeys.filterResults),
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Hero(
        tag: 'filter_hero',
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 40),
          child: Material(
            color: Colors.transparent,
            child: FilterForm(
              // 🔥 تمرير كافة قيم ذاكرة الجلسة لضمان عدم الحذف
              selectedListingType: searchCubit.currentListingType,
              selectedPropertyType: searchCubit.currentPropertyType,
              selectedGovernorate:
                  (location == null ||
                      location == 'الكل' ||
                      location == allText ||
                      location == '')
                  ? allText
                  : location,
              minPrice: searchCubit.currentMinPrice,
              maxPrice: searchCubit.currentMaxPrice,
              minArea: searchCubit.currentMinArea,
              maxArea: searchCubit.currentMaxArea,
              minRooms: searchCubit.currentRooms,
              minBedrooms: searchCubit.currentBedrooms,
              minBathrooms: searchCubit.currentBathrooms,
              floorNumber: searchCubit.currentFloor,
              isFeatured: searchCubit.currentFeatured,
              isLicensed: searchCubit.currentLicensed,
              hasInstallment: searchCubit.currentInstallment,

              onApplyFilters:
                  ({
                    propertyType,
                    listingType,
                    minPrice,
                    maxPrice,
                    minArea,
                    maxArea,
                    governorate,
                    minRooms,
                    minBedrooms,
                    minBathrooms,
                    floorNumber,
                    isLicensed,
                    hasInstallment,
                    isFeatured,
                    landType,
                    farmType,
                    irrigationType,
                    poolType,
                  }) {
                    // 🔥 تفكيك البارامترات وتمريرها للكيوبيت بسلام
                    searchCubit.applyFilters(
                      propertyType: propertyType,
                      listingType: listingType,
                      minPrice: minPrice,
                      maxPrice: maxPrice,
                      minArea: minArea,
                      maxArea: maxArea,
                      governorate: governorate,
                      minRooms: minRooms,
                      minBedrooms: minBedrooms,
                      minBathrooms: minBathrooms,
                      floorNumber: floorNumber,
                      isLicensed: isLicensed,
                      hasInstallment: hasInstallment,
                      isFeatured: isFeatured,
                      landType: landType,
                      farmType: farmType,
                      irrigationType: irrigationType,
                      poolType: poolType,
                    );

                    // 🔥 الذهاب للشاشة الرئيسية (التي تحتوي الـ BottomNav)
                    context.go('/mainScreen');

                    // 🎯 تأخير بسيط للتأكد من بناء الشاشة ثم تغيير التبويب للبحث (رقم 1)
                    Future.delayed(const Duration(milliseconds: 50), () {
                      if (context.mounted) {
                        context.read<NavigationCubit>().changeIndex(1);
                      }
                    });
                  },
            ),
          ),
        ),
      ),
    );
  }
}
