import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:test_graduation/core/enums/property_enums.dart';
import 'package:test_graduation/core/routing/app_routes.dart';
import 'package:test_graduation/core/utils/colors.dart';
import 'package:test_graduation/core/language/app_localizations.dart';
import 'package:test_graduation/core/language/lang_keys.dart';
import 'package:test_graduation/features/my_properties/domain/entities/property_entity.dart';
import 'package:test_graduation/features/my_properties/presentation/manager/my_properties_cubit.dart';
import 'package:test_graduation/features/my_properties/presentation/views/widgets/properties_list_view.dart';

class MyPropertiesViewBody extends StatefulWidget {
  final List<PropertyEntity> properties;
  const MyPropertiesViewBody({super.key, required this.properties});

  @override
  State<MyPropertiesViewBody> createState() => _MyPropertiesViewBodyState();
}

class _MyPropertiesViewBodyState extends State<MyPropertiesViewBody>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  void navigateToSoldTab() {
    if (_tabController.index != 1) {
      _tabController.animateTo(1);
    }
  }

  Future<void> _onRefresh() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      context.read<MyPropertiesCubit>().fetchMyProperties(user.uid);
      await Future.delayed(const Duration(milliseconds: 1000));
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocalizations.of(context)!;
    final active = widget.properties
        .where((p) => p.status != PropertyStatus.sold)
        .toList();
    final sold = widget.properties
        .where((p) => p.status == PropertyStatus.sold)
        .toList();

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection: locale.isEnLocale ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(
            locale.translate(LangKeys.myProperties),
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 22.sp,
              color: isDark ? Colors.white : const Color(0xFF1E293B),
              letterSpacing: -0.5,
            ),
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: 0,
          scrolledUnderElevation: 0,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(60.h),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: TabBar(
                controller: _tabController,
                dividerColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.white,
                unselectedLabelColor: isDark
                    ? AppColors.textSecondaryDark
                    : const Color(0xFF64748B),
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  color: AppColors.primary,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                labelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w800,
                ),
                unselectedLabelStyle: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
                tabs: [
                  Tab(text: locale.translate(LangKeys.activeProperties)),
                  Tab(text: locale.translate(LangKeys.soldProperties)),
                ],
              ),
            ),
          ),
        ),
        body: RefreshIndicator(
          onRefresh: _onRefresh,
          color: AppColors.primary,
          strokeWidth: 3,
          child: TabBarView(
            controller: _tabController,
            children: [
              PropertiesListView(
                properties: active,
                onSoldAction: navigateToSoldTab,
              ),
              PropertiesListView(properties: sold),
            ],
          ),
        ),
        floatingActionButton: Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: FloatingActionButton.extended(
            onPressed: () =>
                GoRouter.of(context).push(AppRoutes.addPropertyScreen),
            backgroundColor: AppColors.primary,
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
            icon: Icon(Icons.add_rounded, color: Colors.white, size: 28.sp),
            label: Text(
              locale.translate(LangKeys.addProperty),
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.sp,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
