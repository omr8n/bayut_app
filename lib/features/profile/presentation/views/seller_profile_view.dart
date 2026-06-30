import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_graduation/core/helper/my_app_method.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';
import 'package:test_graduation/core/services/secure_storage_singleton.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/core/utils/service_locator.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';
import 'package:test_graduation/features/profile/presentation/manager/rating_cubit/rating_cubit.dart';
import 'widgets/seller_header.dart';
import 'widgets/seller_profile_view_bloc_builder.dart';

class SellerProfileView extends StatelessWidget {
  final PropertyEntity property;

  const SellerProfileView({super.key, required this.property});

  void _handleRatingAction(BuildContext context) {
    final bool isLoggedIn = SecureStorage.isLoggedIn;
    final locale = AppLocalizations.of(context)!;

    if (isLoggedIn) {
      MyAppMethods.showAddRatingDialog(context, sellerId: property.sellerId);
    } else {
      MyAppMethods.showErrorORWarningDialog(
        context: context,
        subtitle: locale.translate(LangKeys.loginToRateSeller),
        fct: () {
          // يمكن إضافة التوجيه لصفحة تسجيل الدخول هنا
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    // 🔥 توفير الكيوبيت للشاشة بالكامل (MVVM)
    return BlocProvider(
      create: (context) =>
          getIt.get<RatingCubit>()..fetchRatings(property.sellerId),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: isDark ? Colors.white : Colors.black,
              textDirection: locale.isEnLocale
                  ? TextDirection.ltr
                  : TextDirection.rtl,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            locale.translate(LangKeys.sellerProfile),
            style: TextStyle(
              color: isDark ? Colors.white : Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SellerHeader(property: property),
              const SizedBox(height: 16),
              _buildSectionTitle(
                context,
                locale.translate(LangKeys.usersReviews),
              ),
              // 🔥 استدعاء المحرك الذكي
              const SellerProfileViewBlocBuilder(),
              const SizedBox(height: 100),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
        // 🔥 التصحيح: استخدام Builder لتوفير context يحتوي على الـ BlocProvider
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _handleRatingAction(context),
          backgroundColor: isDark
              ? AppColors.primary.withValues(alpha: 0.2)
              : const Color(0xFFE3F2FD),
          elevation: 2,
          icon: Icon(
            Icons.star_rate_rounded,
            color: isDark ? Colors.white : Colors.blue,
          ),
          label: Text(
            locale.translate(LangKeys.rateSeller),
            style: TextStyle(
              color: isDark ? Colors.white : Colors.blue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    final locale = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      color: Theme.of(context).cardColor,
      child: Text(
        title,
        textAlign: locale.isEnLocale ? TextAlign.left : TextAlign.right,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: isDark ? Colors.white : Colors.black87,
        ),
      ),
    );
  }
}
